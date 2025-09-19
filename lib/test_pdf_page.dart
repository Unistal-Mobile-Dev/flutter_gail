import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const GasPipelineMapPage(),
    );
  }
}

class GasPipelineMapPage extends StatefulWidget {
  const GasPipelineMapPage({super.key});

  @override
  State<GasPipelineMapPage> createState() => _GasPipelineMapPageState();
}

class _GasPipelineMapPageState extends State<GasPipelineMapPage> {
  GoogleMapController? _mapController;

  // Example pipeline points (replace with API/DB data)
  final List<LatLng> _pipelinePoints = const [
    LatLng(28.6139, 77.2090), // Delhi
    LatLng(27.1767, 78.0081), // Agra
    LatLng(26.9124, 75.7873), // Jaipur
    LatLng(25.3176, 82.9739), // Varanasi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: const Text(
          "Gas Pipeline Viewer",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🌍 Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.6139, 77.2090), // Start Delhi
              zoom: 6,
              tilt: 60, // Tilt for 3D effect
              bearing: 30,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId("gas_pipeline"),
                points: _pipelinePoints,
                color: Colors.orange.shade700,
                width: 6,
                patterns: [
                  PatternItem.dash(30),
                  PatternItem.gap(10),
                ],
              ),
            },
            markers: {
              const Marker(
                markerId: MarkerId("start"),
                position: LatLng(28.6139, 77.2090),
                infoWindow: InfoWindow(title: "Pipeline Start (Delhi)"),
              ),
              const Marker(
                markerId: MarkerId("end"),
                position: LatLng(25.3176, 82.9739),
                infoWindow: InfoWindow(title: "Pipeline End (Varanasi)"),
              ),
            },
            mapType: MapType.hybrid, // Satellite + terrain 3D
            compassEnabled: true,
            zoomControlsEnabled: false, // Custom zoom buttons banayenge
          ),

          // 🔹 Floating Buttons (Zoom In / Out)
          Positioned(
            right: 10,
            bottom: 150,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoomIn",
                  backgroundColor: Colors.green.shade700,
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "zoomOut",
                  backgroundColor: Colors.green.shade700,
                  onPressed: () {
                    _mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ],
            ),
          ),

          // 🔹 Bottom Information Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Pipeline Route",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.location_on, color: Colors.green),
                      Text("Start: Delhi"),
                      Spacer(),
                      Icon(Icons.flag, color: Colors.red),
                      Text("End: Varanasi"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
