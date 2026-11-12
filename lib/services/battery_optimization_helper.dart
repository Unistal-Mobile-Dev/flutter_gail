import 'dart:io';

import 'package:flutter/services.dart';

class BatteryOptimizationHelper {
  static const _channel = MethodChannel('com.gail.app/channel');

  /// Android only — the channel has no iOS handler, so calling it there
  /// throws MissingPluginException and aborts whatever startup block it
  /// sits in.
  static Future<void> openIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('openIgnoreBatteryOptimizations');
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    return await _channel.invokeMethod('isIgnoringBatteryOptimizations');
  }
}
