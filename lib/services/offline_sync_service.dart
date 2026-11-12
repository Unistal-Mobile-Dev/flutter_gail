import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/services/ios_background_location_service.dart';
import 'package:flutter_gail/services/network_helper.dart';

/// 🔄 Drains the offline location queue as soon as the device is back online.
///
/// [MapHelper.syncOfflineLocations] used to be reachable only from inside
/// [MapHelper.locationSave], so points recorded offline stayed in Hive until
/// tracking happened to run again — and if the task was finished offline they
/// were never uploaded at all. Listening to connectivity closes that gap.
class OfflineSyncService {
  OfflineSyncService._();

  static final OfflineSyncService instance = OfflineSyncService._();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// ✅ Start watching for connectivity changes
  void start() {
    if (_subscription != null) return;

    _subscription = NetworkHelper.connectivityStream.listen(
      (results) {
        final hasNetwork =
            results.any((result) => result != ConnectivityResult.none);
        if (!hasNetwork) return;
        unawaited(_flush("network restored"));
      },
      onError: (e, s) => log("⚠️ Connectivity stream error: $e",
          stackTrace: s is StackTrace ? s : null),
    );

    // Anything left queued by a previous run goes out now.
    unawaited(_flush("app start"));
  }

  /// ✅ Stop watching
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _flush(String reason) async {
    try {
      // On iOS the points are collected and queued natively, so the retry
      // has to go there; the Hive queue is only used on Android now.
      if (Platform.isIOS) {
        await IosBackgroundLocationService.instance.flush();
        return;
      }
      // Hive is not isolate-safe. On Android the queue is written from the
      // background service's own isolate, which already drains it every 30s
      // via MapHelper.locationSave — so this isolate only touches the box
      // while that service is stopped. On iOS everything runs here.
      if (Platform.isAndroid && await BackgroundManager().isRunning()) {
        return;
      }
      await MapHelper.syncOfflineLocations();
    } catch (e, s) {
      log("⚠️ Offline location sync ($reason) failed: $e", stackTrace: s);
    }
  }
}
