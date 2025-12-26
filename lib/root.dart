import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/page/view_task_page.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/testing_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Root extends StatefulWidget {
  final Client client;

  const Root({super.key, required this.client});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton.instance.setContext(context);
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return blocMultiProvider(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Gail',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: '/',
        routes: {'/second': (context) => const TestPage()},
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: const SplashScreen(),
        // home: const LoginScreenPage(),
      ),
    );
  }
}



class NavigateRoute extends StatefulWidget {
  const NavigateRoute({super.key});

  @override
  State<NavigateRoute> createState() => _NavigateRouteState();
}

class _NavigateRouteState extends State<NavigateRoute> {
  final ArcGISMapViewController _mapController = ArcGISMapView.createController();

  final GraphicsOverlay _graphicsOverlay = GraphicsOverlay();

  ArcGISPoint? _currentLocationPoint;
  ArcGISPoint? _destinationPoint;

  late RouteTask _routeTask;
  double? _distanceKm;
  double? _travelTimeMin;

  final Uri _routingUri = Uri.parse(
    'https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World',
  );


  @override
  void dispose() {
    _mapController.locationDisplay.stop();
    super.dispose();
  }

  // ---------------- MAP READY ----------------
  Future<void> _onMapViewReady() async {
    _mapController.arcGISMap = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISNavigation);

    _mapController.graphicsOverlays.add(_graphicsOverlay);

    _routeTask = RouteTask.withUri(_routingUri);

    await _startCurrentLocation();
  }

  // ---------------- START GPS ----------------
  Future<void> _startCurrentLocation() async {
    final locationDataSource = SystemLocationDataSource();
    await locationDataSource.start();

    _mapController.locationDisplay.dataSource = locationDataSource;
    _mapController.locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;

     _mapController.locationDisplay.start();

    locationDataSource.onLocationChanged.listen((location) {
      final pos = location.position;
      if (pos == null) return;

      // Reject invalid GPS fixes
      if (pos.x == 0 || pos.y == 0) return;

      _currentLocationPoint = _toWgs84(
        ArcGISPoint(
          x: pos.x,
          y: pos.y,
          spatialReference: pos.spatialReference,
        ),
      );
    });

  }

  ArcGISPoint _toWgs84(ArcGISPoint point) {
    if (point.spatialReference == SpatialReference.wgs84) {
      return point;
    }

    return GeometryEngine.project(
      point,
      outputSpatialReference:  SpatialReference.wgs84,
    ) as ArcGISPoint;
  }



  Future<void> _onMapTap(Offset localPosition) async {
    if (_currentLocationPoint == null) return;

    final mapPoint =
    _mapController.screenToLocation( screen: localPosition);

    if (mapPoint == null) return;

    _destinationPoint = mapPoint;

    _graphicsOverlay.graphics.clear();

    _drawPoint(_currentLocationPoint!, Colors.green);
    _drawPoint(_destinationPoint!, Colors.red);

    await _solveRoute();
  }


  // ---------------- DRAW POINT ----------------
  void _drawPoint(ArcGISPoint point, Color color) {
    final graphic = Graphic(
      geometry: point,
      symbol: SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: color,
        size: 12,
      ),
    );

    _graphicsOverlay.graphics.add(graphic);
  }

  // ---------------- SOLVE ROUTE ----------------
  Future<void> _solveRoute() async {
    if (_currentLocationPoint == null || _destinationPoint == null) return;
    final params = await _routeTask.createDefaultParameters();

    params.setStops([
      Stop(_currentLocationPoint!),
      Stop(_destinationPoint!),
    ]);

    params.returnRoutes = true;
    params.returnDirections = true;
    params.outputSpatialReference = SpatialReference.wgs84;

    final result = await _routeTask.solveRoute(params);
    if (result.routes.isEmpty) return;
    final route = result.routes.first;

    setState(() {
      _distanceKm = route.totalLength / 1000; // meters → km
      _travelTimeMin = route.travelTime;      // minutes
    });
    _drawRoute(route.routeGeometry!);
  }

  // ---------------- DRAW ROUTE ----------------
  void _drawRoute(Geometry geometry) {
    final routeGraphic = Graphic(
      geometry: geometry,
      symbol: SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.blue,
        width: 4,
      ),
    );

    _graphicsOverlay.graphics.add(routeGraphic);

    _mapController.setViewpoint(
      Viewpoint.fromTargetExtent(geometry),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Location → Tap Routing')),
      body: Stack(
        children: [
          ArcGISMapView(
            controllerProvider: () => _mapController,
            onMapViewReady: _onMapViewReady,
            onTap: _onMapTap,
          ),
          if (_distanceKm != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Distance: ${_distanceKm!.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'ETA: ${_travelTimeMin!.toStringAsFixed(0)} min',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
