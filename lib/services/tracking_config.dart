import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// ⏱️ How often a patrolling point is recorded.
///
/// The server sends this as `time_interval` in the map configuration;
/// MapBloc resolves it and writes it to SharedPreferences, which is what
/// makes it reachable from the Android background isolate. Nothing read it
/// back, so both background services ran on a hard-coded 30 seconds and the
/// server setting had no effect at all.
class TrackingConfig {
  static const Duration defaultInterval = Duration(seconds: 30);

  /// Key written by MapBloc after fetching the map configuration.
  static const String _prefsKey = "timeInterval";

  /// Seconds between saved points, as configured by the server.
  static Future<Duration> saveInterval() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seconds = int.tryParse(prefs.getString(_prefsKey) ?? "");
      if (seconds == null || seconds <= 0) {
        return defaultInterval;
      }
      return Duration(seconds: seconds);
    } catch (e, s) {
      log("⚠️ Could not read tracking interval: $e", stackTrace: s);
      return defaultInterval;
    }
  }
}
