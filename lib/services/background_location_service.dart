import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/utils/res/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundManager {
  static const channelId = 'my_foreground_oil';
  static const _notificationId = 941678999;

  /// 🔄 Stream to notify app when service starts/stops
  static final ValueNotifier<bool> isServiceRunning = ValueNotifier(false);

  static Future<void>? _initFuture;

  /// 🔧 Initialize background service (configured only once)
  Future<void> initializeService() {
    return _initFuture ??= _configure().catchError((Object e, StackTrace s) {
      _initFuture = null;
      log("⚠️ Error initializing background service: $e", stackTrace: s);
    });
  }

  Future<void> _configure() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: 'Tracking Active',
        initialNotificationContent: 'Starting location tracking...',
        foregroundServiceNotificationId: _notificationId,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(autoStart: false),
    );

    isServiceRunning.value = await service.isRunning();
  }

  /// ✅ Start tracking. If the service is still running (e.g. uploading pending
  /// offline data after a pause), location tracking is resumed in it.
  Future<void> startService() async {
    try {
      await initializeService();
      final service = FlutterBackgroundService();

      if (await service.isRunning()) {
        service.invoke('startTracking');
        log("🟢 Background tracking resumed");
      } else {
        await service.startService();
        log("🟢 Background service started");
      }
      isServiceRunning.value = true;
    } catch (e, s) {
      log("⚠️ Error starting background service: $e", stackTrace: s);
    }
  }

  /// ✅ Stop tracking. The service uploads pending offline data and then stops itself.
  Future<void> stopService() async {
    try {
      final service = FlutterBackgroundService();

      if (await service.isRunning()) {
        service.invoke('stopService');
        log("🔴 Background tracking stop requested");
      } else {
        log("⚠️ Background service already stopped");
      }
      isServiceRunning.value = false;
    } catch (e, s) {
      log("⚠️ Error stopping background service: $e", stackTrace: s);
    }
  }

  static bool _isActiveStatus(String? taskStatus) => taskStatus == "1" || taskStatus == "5";

  /// 🚀 App open: stop the service if no task is started/resumed locally.
  Future<void> stopIfNoActiveTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      if (!_isActiveStatus(prefs.getString("taskStatus")) && await isRunning()) {
        log("🔴 No active task on app open, stopping background service");
        await stopService();
      }
    } catch (e, s) {
      log("⚠️ Error checking active task: $e", stackTrace: s);
    }
  }

  /// 🔄 Keep the service in sync with the task list from the server:
  /// no started/resumed task → stop, active task → make sure tracking runs.
  Future<void> syncWithTasks(List<TaskModel> tasks) async {
    try {
      final activeTasks = tasks
          .where((task) => task.taskStatus == TaskStatus.started || task.taskStatus == TaskStatus.resume)
          .toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      if (activeTasks.isEmpty) {
        if (_isActiveStatus(prefs.getString("taskStatus"))) {
          await prefs.setString("taskStatus", "0");
        }
        if (await isRunning()) {
          log("🔴 No active task on server, stopping background service");
          await stopService();
        }
        return;
      }

      final task = activeTasks.first;
      await prefs.setString("taskId", task.taskId.toString());
      await prefs.setString("subTaskId", task.subTaskId.toString());
      await prefs.setString("taskStatus", task.taskStatus == TaskStatus.resume ? "5" : "1");
      if (!await isRunning()) {
        log("🟢 Active task found, starting background service");
        await startService();
      }
    } catch (e, s) {
      log("⚠️ Error syncing service with tasks: $e", stackTrace: s);
    }
  }

  /// ✅ Check if running safely
  Future<bool> isRunning() async {
    try {
      final service = FlutterBackgroundService();
      final running = await service.isRunning();
      isServiceRunning.value = running;
      return running;
    } catch (e, s) {
      log("⚠️ Error checking service state: $e", stackTrace: s);
      return false;
    }
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      await service.setAsForegroundService();
    }

    final tracker = _LocationTracker(service);

    service.on('stopService').listen((_) => tracker.stopTracking());
    service.on('startTracking').listen((_) => tracker.startTracking());
    service.on('restartService').listen((_) => tracker.startTracking());

    // If Android restarted the service while the task was paused/completed,
    // only upload pending data instead of tracking.
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final taskStatus = prefs.getString("taskStatus");
    if (taskStatus == null || taskStatus == "1" || taskStatus == "5") {
      await tracker.startTracking();
    } else {
      tracker.stopTracking();
    }
  } catch (e, s) {
    log("💥 Fatal error in onStart(): $e", stackTrace: s);
  }
}

/// Runs inside the background isolate.
/// Each tick: save current location offline (Hive) → upload pending data if
/// internet is available. When tracking is stopped the service keeps running
/// only until all offline data is uploaded, then stops itself.
class _LocationTracker {
  _LocationTracker(this.service);

  final ServiceInstance service;
  static const _defaultInterval = Duration(seconds: 30);
  static const _minIntervalSeconds = 10;

  Timer? _timer;
  bool _tracking = false;
  bool _busy = false;
  double? _lastLat;
  double? _lastLng;

  Future<void> startTracking() async {
    _tracking = true;
    final interval = await _readInterval();
    _restartTimer(interval);
    log("🟢 Location tracking started (every ${interval.inSeconds}s)");
    unawaited(_tick());
  }

  void stopTracking() {
    _tracking = false;
    _restartTimer(_defaultInterval);
    log("🔴 Location tracking stopped, uploading pending data");
    unawaited(_tick());
  }

  void _restartTimer(Duration interval) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _tick());
  }

  Future<Duration> _readInterval() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final seconds = int.tryParse(prefs.getString("timeInterval") ?? "");
      if (seconds == null || seconds <= 0) return _defaultInterval;
      return Duration(seconds: seconds < _minIntervalSeconds ? _minIntervalSeconds : seconds);
    } catch (_) {
      return _defaultInterval;
    }
  }

  Future<void> _tick() async {
    // Skip if the previous tick (GPS / upload) is still running
    if (_busy) return;
    _busy = true;
    try {
      String? activeTaskId;

      // 1. Save location offline
      if (_tracking) {
        final result = await MapHelper.locationSave();
        if (result["status"] == "saved") {
          activeTaskId = result["taskId"];
          _lastLat = result["lat"];
          _lastLng = result["lng"];
          log("📍 Background Location saved: $_lastLat, $_lastLng");

          service.invoke("update", {
            "lat": _lastLat,
            "lng": _lastLng,
            "timestamp": DateTime.now().toIso8601String(),
          });
        } else {
          log("⚠️ Location not saved: ${result["message"]}");
        }
      }

      // 2. Upload pending offline data (if internet available)
      final closedTaskIds = await MapHelper.syncOfflineLocations();
      if (_tracking && activeTaskId != null && closedTaskIds.contains(activeTaskId)) {
        log("🔴 Task closed on server, stopping tracking");
        _tracking = false;
        _restartTimer(_defaultInterval);
      }

      // 3. Stop the service once tracking is off and nothing is pending
      final pending = await MapHelper.pendingLocationCount();
      if (!_tracking && pending == 0) {
        _timer?.cancel();
        log("🔴 All data uploaded, stopping background service");
        await service.stopSelf();
        return;
      }

      _updateNotification(pending);
    } catch (e, s) {
      log("⚠️ Background tick error: $e", stackTrace: s);
    } finally {
      _busy = false;
    }
  }

  void _updateNotification(int pending) {
    final service = this.service;
    if (service is! AndroidServiceInstance) return;

    final pendingText = pending > 0 ? "Pending upload: $pending" : "All data uploaded";
    if (_tracking) {
      final locationText = _lastLat != null
          ? "Lat: ${_lastLat!.toStringAsFixed(5)}, Lng: ${_lastLng!.toStringAsFixed(5)}"
          : "Waiting for location...";
      service.setForegroundNotificationInfo(
        title: "Tracking Active",
        content: "$locationText • $pendingText",
      );
    } else {
      service.setForegroundNotificationInfo(
        title: "Uploading pending data",
        content: "$pending locations waiting for internet",
      );
    }
  }
}
