import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static final Connectivity _connectivity = Connectivity();

  /// Check if device is connected to internet (Wi-Fi, mobile data, etc.)
  static Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    // Optional: verify actual internet access (not just Wi-Fi connection)
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
    return false;
  }

  /// Measure network download speed (in Mbps)
  static Future<double> checkDownloadSpeed() async {
    const url = 'http://speed.hetzner.de/100MB.bin'; // Reliable public file
    const downloadSize = 100 * 1024 * 1024; // 100 MB in bytes

    final stopwatch = Stopwatch()..start();
    final response = await http.Client()
        .send(http.Request('GET', Uri.parse(url)))
        .timeout(const Duration(seconds: 10));

    int bytesReceived = 0;
    await for (var chunk in response.stream) {
      bytesReceived += chunk.length;
      if (stopwatch.elapsed.inSeconds >= 5) break; // Measure for 5 seconds only
    }
    stopwatch.stop();

    double speedBps = (bytesReceived * 8) / stopwatch.elapsed.inSeconds;
    double speedMbps = speedBps / (1024 * 1024);
    return double.parse(speedMbps.toStringAsFixed(2));
  }

  /// Stream to listen for connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
