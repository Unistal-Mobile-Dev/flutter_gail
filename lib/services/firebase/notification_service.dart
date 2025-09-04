import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/services/firebase/default_notification_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'notifications_priority', // id
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("mario"),
);

int notificationId = 1;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Notification ${message.data}");
  List<String> notificationList = [];
  notificationList.add(jsonEncode(message.data));

  String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
  if(notificationSilent.toString() != "1"){
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 10000);
    }
    final player = AudioPlayer();
    player.play(AssetSource('siren_alert.mp3'));
  }

}

class FirebaseService {
  static FirebaseService get instance {
    return FirebaseService();
  }

  initializeService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_gail');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    _isAndroidPermissionGranted();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      if (kDebugMode) {
        print("Notification permission ====== ${granted.toString()}");
      }
    }
    // setupInteractedMessage();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_inAppNotification);
  }

  void _handleMessage(RemoteMessage message) async {
    log('Message data ---  handleMessage ${message.data}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      // navigatorKey.currentState!.pushNamed('/second');
    }
  }

  void _inAppNotification(RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data --- App Open: ${message.toMap()}');
    log('Message data --- App Open: ${message.data}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      notificationId++;
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'notifications_priority', // id
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "id",
            'View',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_igl'),
            contextual: true,
          ),
        ],
      );

    const NotificationDetails(
        android: androidNotificationDetails,
      );
    }
  }
}
