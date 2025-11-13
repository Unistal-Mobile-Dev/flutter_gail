import 'package:flutter/services.dart';

class BatteryOptimizationHelper {
  static const _channel = MethodChannel('com.gail.app/channel');

  static Future<void> openIgnoreBatteryOptimizations() async {
    await _channel.invokeMethod('openIgnoreBatteryOptimizations');
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    return await _channel.invokeMethod('isIgnoringBatteryOptimizations');
  }
}
