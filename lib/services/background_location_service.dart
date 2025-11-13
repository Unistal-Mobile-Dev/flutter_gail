import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundManager {
  static const _channelId = 'my_foreground_oil';
  static const _notificationId = 941678999;

  /// 🔄 Stream to notify app when service starts/stops
  static final ValueNotifier<bool> isServiceRunning = ValueNotifier(false);

  /// 🔧 Initialize background service safely
  Future<void> initializeService() async {
    try {
      final service = FlutterBackgroundService();

      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          autoStartOnBoot: false,
          isForegroundMode: true,
          notificationChannelId: _channelId,
          initialNotificationTitle: 'Background Service',
          initialNotificationContent: 'Running background tasks...',
          foregroundServiceNotificationId: _notificationId,
        ),
        iosConfiguration: IosConfiguration(),
      );

      // final running = await service.isRunning();
      // isServiceRunning.value = running;
    } catch (e, s) {
      log("⚠️ Error initializing background service: $e", stackTrace: s);
    }
  }

  /// ✅ Start background service safely
  Future<void> startService() async {
    try {
      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();

      if (!isRunning) {
        await service.startService();
        isServiceRunning.value = true;
        log("🟢 Background service started");
      } else {
        log("⚠️ Background service already running");
      }
    } catch (e, s) {
      log("⚠️ Error starting background service: $e", stackTrace: s);
    }
  }

  /// ✅ Stop background service safely
  Future<void> stopService() async {
    try {
      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();

      if (isRunning) {
        service.invoke('stopService');
        isServiceRunning.value = false;

        log("🔴 Background service stopped");
      } else {
        log("⚠️ Background service already stopped");
      }
    } catch (e, s) {
      log("⚠️ Error stopping background service: $e", stackTrace: s);
    }
  }

  /// ✅ Check if running safely
  Future<bool> isRunning() async {
    try {
      print("Service 3 === ");
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
void onStart(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.setForegroundNotificationInfo(
        title: "Tracking Active",
        content: "Running even when locked",
      );
    }

    final notifications = FlutterLocalNotificationsPlugin();
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher_oil');
    const initSettings = InitializationSettings(android: initSettingsAndroid);
    await notifications.initialize(initSettings);

    // 🔄 Timer reference
    Timer? locationTimer;

    Future<void> stopLocationTimer() async {
      if (locationTimer != null && locationTimer!.isActive) {
        locationTimer!.cancel();
        locationTimer = null;
      }
    }

    /// 🧭 Function to start periodic location updates
    Future<void> startLocationTimer() async {
      locationTimer?.cancel(); // Cancel any old timer before starting new one
      locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
        try {
          if (!(await Geolocator.isLocationServiceEnabled())) {
            log("⚠️ Location service disabled");
            return;
          }

          final permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            log("⚠️ Location permission not granted");
            return;
          }

          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          );

          log("📍 Background Location: ${pos.latitude}, ${pos.longitude}");
          await MapHelper.locationSave();

          // ✅ Update notification safely
          if (service is AndroidServiceInstance &&
              await service.isForegroundService()) {
            await notifications.show(
              999,
              "Background Service Running",
              "Lat: ${pos.latitude}, Lng: ${pos.longitude}",
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  BackgroundManager._channelId,
                  'Background Service',
                  channelDescription: 'Used for background location tracking',
                  ongoing: true,
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher_oil',
                ),
              ),
            );
          }

          // ✅ Notify main isolate
          service.invoke("update", {
            "lat": pos.latitude,
            "lng": pos.longitude,
            "timestamp": DateTime.now().toIso8601String(),
          });
        } catch (e, s) {
          log("⚠️ Location update error: $e", stackTrace: s);
        }
      });
      log("🟢 Location timer started");
    }

    // 🛑 Stop listener
    service.on('stopService').listen((event) async {
      try {
        stopLocationTimer();
        log("🔴 Background service stop requested");
        service.stopSelf();
      } catch (e, s) {
        log("⚠️ Error stopping service listener: $e", stackTrace: s);
      }
    });

    // 🔄 Restart listener (optional)
    service.on('restartService').listen((event) async {
      log("🔁 Restarting background timer...");
      await startLocationTimer();
    });

    // ✅ Start timer initially
    await startLocationTimer();

    // ✅ Periodic location update every 20 seconds
    /*Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        if (!(await Geolocator.isLocationServiceEnabled())) {
          if (kDebugMode) print("⚠️ Location service disabled");
          return;
        }

        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        );

        log("📍 Background Location: ${pos.latitude}, ${pos.longitude}");
        await MapHelper.locationSave();

        // ✅ Update notification safely
        try {
          if (service is AndroidServiceInstance &&
              await service.isForegroundService()) {
            await notifications.show(
              999,
              "Background Service Running",
              "Lat: ${pos.latitude}, Lng: ${pos.longitude}",
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'Foreground Service',
                  channelDescription: 'Used for background location tracking',
                  ongoing: true,
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher_oil',
                ),
              ),
            );
          }
        } catch (notifError, s) {
          log("⚠️ Error showing notification: $notifError", stackTrace: s);
        }

        // ✅ Send update safely
        try {
          service.invoke("update", {
            "lat": pos.latitude,
            "lng": pos.longitude,
            "timestamp": DateTime.now().toIso8601String(),
          });
        } catch (invokeError, s) {
          log("⚠️ Error invoking update: $invokeError", stackTrace: s);
        }
      } catch (locError, s) {
        log("⚠️ Location fetch error: $locError", stackTrace: s);
      }
    });*/
  } catch (e, s) {
    log("💥 Fatal error in onStart(): $e", stackTrace: s);
  }
}
