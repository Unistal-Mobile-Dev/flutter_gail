import 'package:flutter/services.dart';

class AppLifecycleChannel {
  static const EventChannel _eventChannel = EventChannel('com.gail.app/events');

  static void listenToLifecycleEvents() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      print('🔁 Native lifecycle event: $event');

      if (event == "onDestroy") {
        // Perform cleanup or save data here
      }
    });
  }
}
