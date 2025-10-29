import 'package:flutter/services.dart';

class AppControlHelper {
  static const MethodChannel _channel = MethodChannel('com.gail.app/channel');

  static Future<void> forceStopApp() async {
    try {
      await _channel.invokeMethod('forceStopApp');
    } catch (e) {
      print('❌ Error forcing app stop: $e');
    }
  }
}
