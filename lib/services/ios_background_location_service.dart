import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_gail/services/apis.dart';
import 'package:flutter_gail/services/session_helper.dart';
import 'package:flutter_gail/services/tracking_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 📍 Background patrolling on iOS.
///
/// The tracking itself lives in native code — see
/// ios/Runner/LocationTrackingService.swift. A Dart timer or stream only
/// keeps running while the Flutter engine does, and iOS throttles the engine
/// once the app leaves the screen, which is why points stopped being saved
/// in the background. CoreLocation keeps calling a native delegate for as
/// long as the `location` background mode is active, so collecting, queueing
/// and uploading all happen there.
///
/// This class only hands the native side what it needs and starts/stops it.
class IosBackgroundLocationService {
  IosBackgroundLocationService._();

  static final IosBackgroundLocationService instance =
      IosBackgroundLocationService._();

  static const _tracking = MethodChannel('com.gail.app/tracking');

  /// Gets the app relaunched after a force quit — see
  /// ios/Runner/BackgroundLocationRelauncher.swift.
  static const _relauncher = MethodChannel('com.gail.app/relaunch');

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  bool _listening = false;

  /// Print what the native tracker is doing into the Flutter console.
  ///
  /// The native side uses NSLog, which only reaches the Xcode console — so
  /// nothing showed up where the rest of the app's logs are read. Native now
  /// mirrors every event here instead.
  void _listenToNative() {
    if (_listening) return;
    _listening = true;

    _tracking.setMethodCallHandler((call) async {
      if (call.method != 'onTrackingEvent') return null;
      final data = Map<String, dynamic>.from(call.arguments as Map);
      final event = data['event'];

      switch (event) {
        case 'SAVED':
          log("📍 SAVED #${data['point']} at ${data['time']} (${data['gap']}) "
              "| lat=${data['lat']} lng=${data['lng']} "
              "| acc=${data['accuracy']}m speed=${data['speed']}m/s "
              "bearing=${data['bearing']}° dist=${data['distance']}m "
              "batt=${data['battery']}% | task=${data['taskId']}");
          break;
        case 'QUEUED':
          log("📦 Queued — ${data['pending']} point(s) waiting to upload");
          break;
        case 'UPLOADING':
          log("⬆️ Uploading ${data['count']} point(s) → ${data['url']}");
          break;
        case 'UPLOADED':
          log("✅ Uploaded ${data['count']} point(s)");
          break;
        case 'UPLOAD_ERROR':
          log("⚠️ Upload error: ${data['reason']} — "
              "${data['kept']} point(s) kept offline");
          break;
        case 'UPLOAD_REJECTED':
          log("⚠️ Upload rejected (status ${data['status']}) — "
              "${data['kept']} point(s) kept offline");
          break;
        case 'NO_FIX':
          log("⏳ Timer fired but no GPS fix yet, nothing saved");
          break;
        default:
          log("ℹ️ Tracking event: $data");
      }
      return null;
    });
  }

  /// ✅ Hand the native tracker its config and start it
  Future<bool> start() async {
    if (!Platform.isIOS) return false;

    if (_isRunning) {
      log("⚠️ iOS tracking already running");
      return true;
    }

    _listenToNative();

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        log("⚠️ Location service disabled, not starting iOS tracking");
        return false;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log("⚠️ Location permission not granted, not starting iOS tracking");
        return false;
      }

      if (!await Permission.locationAlways.isGranted &&
          permission != LocationPermission.always) {
        log("⚠️ Only 'While Using' location granted — iOS will suspend "
            "tracking once the app is backgrounded for a while");
      }

      final prefs = await SharedPreferences.getInstance();
      final taskId = prefs.getString("taskId") ?? "";
      if (taskId.isEmpty) {
        log("⚠️ No active task id, not starting iOS tracking");
        return false;
      }

      // The pref is only written at login; fall back to the flavour's URL so
      // an older install does not end up posting to a relative path.
      var baseUrl = prefs.getString("baseUrl") ?? "";
      if (baseUrl.isEmpty) {
        baseUrl = APIs.baseUrl;
        if (baseUrl.isNotEmpty) {
          await prefs.setString("baseUrl", baseUrl);
        }
      }
      if (baseUrl.isEmpty) {
        log("⚠️ No base url available, native uploads will fail");
      }

      final interval = await TrackingConfig.saveInterval();
      final started = await _tracking.invokeMethod<bool>('start', {
        "baseUrl": baseUrl,
        "endpoint": APIs.saveLocationDataApi,
        "token": await SessionHelper.authToken(),
        "schema": await SessionHelper.schema(),
        "taskId": taskId,
        "subTaskId": prefs.getString("subTaskId") ?? "",
        "intervalSeconds": interval.inSeconds,
      });

      _isRunning = started ?? false;
      if (_isRunning) {
        await _setRelauncher(armed: true);
        log("🟢 iOS native tracking started "
            "(task $taskId, every ${interval.inSeconds}s)");
      } else {
        log("⚠️ Native tracker refused to start");
      }
      return _isRunning;
    } catch (e, s) {
      log("⚠️ Error starting iOS tracking: $e", stackTrace: s);
      _isRunning = false;
      return false;
    }
  }

  /// ✅ Stop the native tracker
  Future<void> stop() async {
    await _setRelauncher(armed: false);
    try {
      await _tracking.invokeMethod('stop');
    } catch (e, s) {
      log("⚠️ Error stopping iOS tracking: $e", stackTrace: s);
    } finally {
      _isRunning = false;
      log("🔴 iOS native tracking stopped");
    }
  }

  /// How many points are still waiting to reach the server.
  Future<int> pendingCount() async {
    if (!Platform.isIOS) return 0;
    try {
      return await _tracking.invokeMethod<int>('pendingCount') ?? 0;
    } catch (e) {
      log("⚠️ Could not read pending count: $e");
      return 0;
    }
  }

  /// Ask the native side to retry its queue, e.g. when the network returns.
  Future<void> flush() async {
    if (!Platform.isIOS) return;
    try {
      await _tracking.invokeMethod('flush');
    } catch (e) {
      log("⚠️ Could not flush native queue: $e");
    }
  }

  /// Restart tracking if a task was still running when the app died.
  ///
  /// After a force quit iOS relaunches the app for a region exit, but it only
  /// starts the process. The task state lives in SharedPreferences (written
  /// by MapBloc), so it survives and says whether patrolling should resume.
  static Future<void> resumeIfTaskActive() async {
    if (!Platform.isIOS) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskStatus = prefs.getString("taskStatus") ?? "0";
      final taskId = prefs.getString("taskId") ?? "";

      // "1" = started, "5" = resumed; see MapBloc._updateTask.
      if (taskId.isEmpty || (taskStatus != "1" && taskStatus != "5")) return;

      log("🔁 Task $taskId still active (status $taskStatus), resuming");
      await instance.start();
    } catch (e, s) {
      log("⚠️ Could not resume iOS tracking: $e", stackTrace: s);
    }
  }

  Future<void> _setRelauncher({required bool armed}) async {
    try {
      await _relauncher.invokeMethod(armed ? 'arm' : 'disarm');
    } catch (e) {
      // A missing handler only costs force-quit recovery; tracking itself is
      // unaffected, so this must not take the service down with it.
      log("⚠️ Relauncher ${armed ? 'arm' : 'disarm'} failed: $e");
    }
  }
}
