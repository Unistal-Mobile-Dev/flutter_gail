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
  await Hive.initFlutter();

  await FirebaseService.instance.initializeService();

  // ✅ 1. Location Permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  await DashboardHelper.requestPermission();

  try {
    // ✅ 2. Notification Initialization
    final FlutterLocalNotificationsPlugin notificationPlugin =
    FlutterLocalNotificationsPlugin();

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
    );

    // ✅ 3. Request Notification Permission (Android 13+ & iOS)
    await requestNotificationPermission(notificationPlugin);

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


    await WakelockPlus.enable(); // Keeps CPU awake while screen off

    final isIgnoring = await BatteryOptimizationHelper.isIgnoringBatteryOptimizations();
    if (!isIgnoring) {
      await BatteryOptimizationHelper.openIgnoreBatteryOptimizations();
    }

    // ✅ 5. Background service management
    final backgroundManager = BackgroundManager();
    backgroundManager.initializeService();

    BackgroundManager.isServiceRunning.addListener(() {
      debugPrint(
        "Service State Changed → ${BackgroundManager.isServiceRunning.value ? 'RUNNING' : 'STOPPED'}",
      );
    });
  } catch (e) {
    debugPrint("Notification Init Error: $e");
  }


  var apiKey = Platform.isAndroid ?  const String.fromEnvironment('API_KEY') : "AAPK61287a314f53402d91bb41dffde6de9c_BFuvT1vTFyCyRq4Cx46fgTaP_ax8er0gNXa1ZR-_Tnw4xmBJj6GDtrrxad7rfzL";
  if (apiKey.isEmpty) {
    throw Exception('apiKey undefined');
  } else {
    ArcGISEnvironment.apiKey = apiKey;
  }

  var licenseKey = Platform.isAndroid ?  const String.fromEnvironment('License_Key') : "runtimelite,1000,rud8814547710,none,TRB3LNBHPBJL6XCFK216";
  ArcGISEnvironment.setLicenseUsingKey(
    licenseKey,
  );


  // ✅ 7. App Config
  var configuredApp = const EnvironmentConfig(
    flavours: EnvironmentFlavours.developmentIglCng,
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
  // For Android 13+ (API 33+)
  final androidImplementation = notificationPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  if (androidImplementation != null) {
    final bool? granted = await androidImplementation.requestNotificationsPermission();
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
}
