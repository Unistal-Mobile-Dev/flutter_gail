import 'dart:io';
import 'package:flutter/services.dart';

class BatteryOptimizationHelper {
  static const _channel = MethodChannel('com.gail.app/channel');

  static Future<void> openIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return;

    await _channel.invokeMethod('openIgnoreBatteryOptimizations');
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;

    return await _channel.invokeMethod<bool>(
      'isIgnoringBatteryOptimizations',
    ) ??
        true;
  }
}