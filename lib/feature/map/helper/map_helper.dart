import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/domain/model/configuration_model.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/map/domain/model/hive_location_model.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/domain/model/marker_point_model.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_gail/services/network_helper.dart';
import 'package:flutter_gail/utils/commonWidgets/gps_alert_pop_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class MapHelper {
  // StreamController and Subscription
  StreamController<LatLng>? _locationController;
  StreamSubscription<Position>? _positionSubscription;

  /// Return GPS location stream
  Stream<LatLng> getLocationStream(BuildContext context) {
    _locationController ??= StreamController<LatLng>.broadcast();
    _startListening(context);
    return _locationController!.stream;
  }

  /// Start listening to GPS updates
  void _startListening(BuildContext context) async {
    await _positionSubscription?.cancel();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => const GPSAlertPopWidget(),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      _locationController?.add(LatLng(position.latitude, position.longitude));
    });
  }


  /// Stop GPS tracking
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Dispose everything
  void dispose() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _locationController?.close();
    _locationController = null;
  }

  /// Fetch routes from server
  static Future<MapModel?> fetchRoutes({required String routeId}) async {
    try {
      String url = APIs.getRouteApi + routeId;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) return MapModel.fromJson(res);
    } catch (_) {}
    return null;
  }

  /// Fetch configuration from server
  static Future<ConfigurationModel?> fetchConfiguration() async {
    try {
      String url = APIs.getConfigurationApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['success'] == true &&
          res['config'] != null) {
        return ConfigurationModel.fromJson(res['config']);
      }
    } catch (_) {}
    return null;
  }


  static Future<List<MarkerPointsModel>> fetchMovingPath({required String taskId}) async {
    List<MarkerPointsModel> directionList = [];
      try {
        String url = APIs.getMovingPointApi + "?task_id=$taskId";
        var res = await ServerRequest.getData(urlEndPoint: url);
        if (res != null && res['success'] != null && res['success'] == true && res['data'] != null){
          return markerPointListResponse(res['data']);
        }
      }catch(_){}
    return directionList;
  }

  /// Fetch markers for a section
  static Future<List<MarkerModel>?> fetchMarkerList({required String sectionCode}) async {
    try {
      String url = APIs.getMarkerApi + "?sectionCode=$sectionCode";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) return markerListResponse(res);
    } catch (_) {}
    return null;
  }


  /// Calculate distance in meters
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    // const R = 6371000.0; // meters
    const R = 6371.0; // meters
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(toRadians(lat1)) * math.cos(toRadians(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  static double calculateBearing(lat1, lon1, lat2, lon2) {
    final deltaLon = toRadians(lon2 - lon1);
    final y = math.sin(deltaLon) * math.cos(toRadians(lat2));
    final x = math.cos(toRadians(lat1)) * math.sin(toRadians(lat2)) -
        math.sin(toRadians(lat1)) * math.cos(toRadians(lat2)) * math.cos(deltaLon);
    return (toDegrees(math.atan2(y, x)) + 360) % 360;
  }

  static double toRadians(double deg) => deg * (math.pi / 180.0);
  static double toDegrees(double rad) => rad * (180.0 / math.pi);

  /// Fetch section points details
  static Future<RoutePointsModel?> fetchPointsDetails({required String sectionCode}) async {
    try {
      String url = APIs.getMarkerCrossingInidentTypePointsApi + "?sectionCode=$sectionCode";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) return RoutePointsModel.fromJson(res, sectionCode);
    } catch (e) {
      print("Fetch Points Error: ${e.toString()}");
    }
    return null;
  }

  /// Check if nearest point exists in routes
  /// Check if nearest point exists in routes
  static Future<bool> getNearestLocation({
    required LatLng currentLocation,
    required List<List<PointsModel>> routes,
    required double bufferZone,
  }) async {
    double shortestDistance = bufferZone;

    for (var routeData in routes) {
      for (var points in routeData) {
        double distance = calculateDistance(currentLocation.latitude, currentLocation.longitude, points.y, points.x);
        if (distance < shortestDistance) {
          shortestDistance = distance;
          return true;
        }
      }
    }
    return false;
  }

  /// Save location data for a task
  static Future<Map<String, dynamic>> locationSave() async {
    try {
      // 1. Get current location
      var locationRes = await LocationHelper.getLocationFetchForBackground();
      LocationModel locationData = locationRes ?? LocationModel();

      // 2. Calculate distance & bearing
      double distance = 0;
      double bearing = 0;
      if (lastPoint.y != null) {
        distance = calculateDistance(lastPoint.y, lastPoint.x, locationData.lat, locationData.long) * 1000;
        bearing = calculateBearing(locationData.lat, locationData.long, lastPoint.y, lastPoint.x);
      }

      lastPoint = PointsModel(x: locationData.long, y: locationData.lat);

      // 3. Get battery
      var battery = Battery();
      int batteryPercentage = await battery.batteryLevel;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String taskId =  prefs.getString("taskId") ?? "";
      print("--------------------Task Id $taskId");
      if(taskId.isEmpty){
        return {"status": "error", "message": ""};
      }
      String subTaskId =  prefs.getString("subTaskId") ?? "";

      // 4. Create Hive model
      HiveLocationModel hiveLocation = HiveLocationModel(
        taskId: taskId,
        subTaskId: subTaskId,
        gpsX: locationData.long ?? 0.0,
        gpsY: locationData.lat ?? 0.0,
        distance: distance,
        bearing: bearing,
        speed: double.parse(locationData.speed ?? "0.0"),
        gpsAccuracy: double.parse(locationData.accuracy.toString().isEmpty ? "0.0" : locationData.accuracy.toString()),
        battery: batteryPercentage,
        inspectedDateTime: DateTime.now(),
      );

      // 5. Save offline in Hive
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(HiveLocationModelAdapter());
        print("📦 Hive Adapter Registered (typeId: 1)");
      } else {
        print("⚠️ Hive Adapter already registered (typeId: 1)");
      }
      await Hive.openBox<HiveLocationModel>('location_box');
      var box = Hive.box<HiveLocationModel>('location_box');
      await box.add(hiveLocation);

      List<Map<String, dynamic>> payload = [];
      payload.add(hiveLocation.toServerJson());

      // 6. Check network
      bool connected = await NetworkHelper.isConnected();
      print("Check connection 1 $connected");
      if (connected) {
        try {
          await syncOfflineLocations();
        } catch (e) {
          print("Server upload failed, keeping offline: $e");
        }
      }

      // 7. Return status
      return {"status": "saved", "isSynced": hiveLocation.isSynced};
    } catch (e) {
      print("Location Save Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }


  static Future<void> syncOfflineLocations() async {
    var box = Hive.box<HiveLocationModel>('location_box');
    bool connected = await NetworkHelper.isConnected();
    print("Check connection 2 $connected");
    if (!connected) return;

    // Collect all unsynced locations
    List<Map<String, dynamic>> payload = [];

    for (var location in box.values) {
      if (!location.isSynced) {
        payload.add(location.toServerJson());
      }
    }

    if (payload.isEmpty) return;

    try {
      // Send all unsynced locations in a single array
      var res = await ServerRequest.backgroundPostData(
        urlEndPoint: APIs.saveLocationDataApi,
        body: jsonEncode(payload),
      );

      // If server response is successful, mark all as synced
      if (res != null && res['close_status'] != null && res['close_status'] != 3) {
        for (var location in box.values) {
          if (!location.isSynced) {
            location.isSynced = true;
            await location.delete();
          }
        }
      } else if (res != null && res['close_status'] != null && res['close_status'] == 3) {
        final manager = BackgroundManager();
        if(await manager.isRunning()){
          manager.stopService();
        }
      }
    } catch (e) {
      print("Batch sync failed: $e");
    }
  }


}
