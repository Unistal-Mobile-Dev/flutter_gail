import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/root.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/services/battery_optimization_helper.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ APPLY PORTAL LICENSE FIRST
  // await applyRuntimeStandardLicense();

  // ✅ APPLY LICENSE FIRST (before any map usage)
  try {
    const apiKey = String.fromEnvironment('API_KEY');
    if (apiKey.isEmpty) {
      debugPrint('Warning: ArcGIS API key not provided via environment variable');
    } else {
      ArcGISEnvironment.apiKey = apiKey;
      debugPrint("ArcGISEnvironment initialized with provided API key");
    }
  } catch (e) {
    debugPrint("Error setting ArcGIS API key: $e");
  }

  try {
    await Hive.initFlutter();
    debugPrint("Hive initialized");
  } catch (e) {
    debugPrint("Hive initialization error: $e");
  }

  try {
    await FirebaseService.instance.initializeService().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        debugPrint("Firebase initialization timeout");
      },
    );
    debugPrint("Firebase initialized");
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // ✅ 1. Location Permission (with timeout)
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    debugPrint("Location permission status: $permission");
  } catch (e) {
    debugPrint("Location permission error: $e");
  }

  try {
    await DashboardHelper.requestPermission();
    debugPrint("Dashboard permission requested");
  } catch (e) {
    debugPrint("Dashboard permission error: $e");
  }

  try {
    // ✅ 2. Notification Initialization
    final FlutterLocalNotificationsPlugin notificationPlugin =
    FlutterLocalNotificationsPlugin();
    debugPrint(
      "Plugin => ${notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()}",
    );
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher_upims');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await notificationPlugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        debugPrint("Notification plugin initialization timeout");
      },
    );

    // ✅ 3. Request Notification Permission (Android 13+ & iOS)
    await requestNotificationPermission(notificationPlugin).timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        debugPrint("Notification permission request timeout");
      },
    );

    // ✅ 4. Create Android Notification Channel
    const channel = AndroidNotificationChannel(
      'my_foreground',
      'Background Service Channel',
      description: 'Used for background location updates',
      importance: Importance.high,
    );

    await notificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    debugPrint("Notifications initialized successfully");
  } catch (e) {
    debugPrint("Notification Init Error: $e");
  }

  try {
    await WakelockPlus.enable();
    debugPrint("Wakelock enabled");
  } catch (e) {
    debugPrint("Wakelock error: $e");
  }

  try {
    final isIgnoring = await BatteryOptimizationHelper
        .isIgnoringBatteryOptimizations();
    if (!isIgnoring) {
      // ✅ OPTION 1: Non-blocking battery optimization dialog
      // This prevents the app from getting stuck waiting for user interaction
      unawaited(BatteryOptimizationHelper.openIgnoreBatteryOptimizations());
      debugPrint("Battery optimization dialog opened (non-blocking)");
    }
  } catch (e) {
    debugPrint("Battery optimization error: $e");
  }

  try {
    // ✅ 5. Background service management (with timeout)
    final backgroundManager = BackgroundManager();
    await backgroundManager.initializeService().timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        debugPrint("Background service initialization timeout");
      },
    );

    BackgroundManager.isServiceRunning.addListener(() {
      debugPrint(
        "Service State Changed → ${BackgroundManager.isServiceRunning.value ? 'RUNNING' : 'STOPPED'}",
      );
    });
    debugPrint("Background service initialized");
  } catch (e) {
    debugPrint("Background service error: $e");
  }

  // ✅ 7. App Config
  var configuredApp = const EnvironmentConfig(
    flavours: EnvironmentFlavours.productionIglCng,
    child: Root(client: Client.gail),
  );

  // ✅ 8. Lock orientation & run app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}

/// ✅ Helper function to request notification permission
Future<void> requestNotificationPermission(
    FlutterLocalNotificationsPlugin notificationPlugin) async {
  try {
    // For Android 13+ (API 33+)
    final androidImplementation = notificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? granted =
      await androidImplementation.requestNotificationsPermission();
      debugPrint("Android Notification Permission: $granted");
    }

    // For iOS
    final iosImplementation = notificationPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint("iOS Notification Permission: $granted");
    }
  } catch (e) {
    debugPrint("Notification permission request error: $e");
  }
}

Future<void> applyRuntimeStandardLicense() async {
  try {
    final portal = Portal(
      Uri.parse('https://gailgis.gail.co.in/portal'),
      connection: PortalConnection.authenticated,
    );

    await portal.load().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        debugPrint("Portal load timeout");
      },
    );

    final result = await ArcGISEnvironment.getLicense();

    debugPrint('License Status: $result');
  } catch (e) {
    debugPrint("License error: $e");
  }
}