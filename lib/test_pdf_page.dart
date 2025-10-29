import 'package:flutter/material.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Request permission before starting service
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  // 🔹 Initialize background service
  await BackgroundManager().initializeService();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRunning = false;
  String lastLocation = "No data yet";

  @override
  void initState() {
    super.initState();

    // 🔹 Listen to background updates
    final service = FlutterBackgroundService();
    service.on('update').listen((data) {
      if (data != null) {
        setState(() {
          lastLocation =
          "📍 Lat: ${data['lat']} | Lng: ${data['lng']}\n🕒 ${data['timestamp']}";
        });
      }
    });
  }

  Future<void> _toggleService() async {
    final service = FlutterBackgroundService();
    bool running = await service.isRunning();

    if (running) {
      service.invoke('stopService');
    } else {
      await service.startService();
    }

    setState(() => isRunning = !running);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Background Service Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lastLocation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _toggleService,
                child: Text(isRunning ? "Stop Service" : "Start Service"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
