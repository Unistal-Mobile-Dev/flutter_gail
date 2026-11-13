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

  static const String _locationBoxName = 'location_box';
  static const int _syncBatchSize = 100;
  static Future<Box<HiveLocationModel>>? _locationBoxFuture;

  // GPS filter settings for background tracking
  static const double _maxGpsAccuracyMeters = 30; // ignore weak GPS fixes
  static const double _maxSpeedMps = 30; // ~108 km/h, faster means a GPS spike
  static const double _minMovementMeters = 5; // smaller movement is GPS noise
  static const int _maxSkippedJumps = 3;
  static String? _lastSavedTaskId;
  static DateTime? _lastSavedTime;
  static int _skippedJumps = 0;

  /// Opens the offline location box once per isolate.
  static Future<Box<HiveLocationModel>> _openLocationBox() {
    return _locationBoxFuture ??= () async {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(HiveLocationModelAdapter());
      }
      return Hive.openBox<HiveLocationModel>(_locationBoxName);
    }().catchError((Object e) {
      _locationBoxFuture = null;
      throw e;
    });
  }

  /// Number of locations saved offline and not yet uploaded.
  static Future<int> pendingLocationCount() async {
    final box = await _openLocationBox();
    return box.length;
  }

  /// Fetch the current location and save it offline (Hive) for the active task.
  /// Uploading is done separately by [syncOfflineLocations], so points are never
  /// lost when there is no internet.
  static Future<Map<String, dynamic>> locationSave() async {
    try {
      // 1. Active task (reload: main isolate may have changed it)
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      String taskId = prefs.getString("taskId") ?? "";
      if (taskId.isEmpty) {
        return {"status": "error", "message": "No active task"};
      }
      String subTaskId = prefs.getString("subTaskId") ?? "";

      // 2. Get current location (works offline, GPS only)
      LocationModel? locationData = await LocationHelper.getLocationFetchForBackground();
      if (locationData == null || locationData.lat == null || locationData.long == null) {
        return {"status": "error", "message": "Location not available"};
      }

      // 3. Filter GPS noise
      final DateTime now = DateTime.now();
      double accuracy = double.tryParse(locationData.accuracy ?? "") ?? 0.0;
      double speed = double.tryParse(locationData.speed ?? "") ?? 0.0;
      if (accuracy > _maxGpsAccuracyMeters) {
        return {"status": "error", "message": "Low GPS accuracy (${accuracy.toStringAsFixed(0)} m), point skipped"};
      }

      // New task: don't measure distance from the previous task's last point
      if (_lastSavedTaskId != taskId) {
        lastPoint = PointsModel();
        _lastSavedTime = null;
        _skippedJumps = 0;
      }

      double lat = locationData.lat!;
      double long = locationData.long!;
      double distance = 0;
      double bearing = 0;
      if (lastPoint.y != null && lastPoint.x != null) {
        distance = calculateDistance(lastPoint.y, lastPoint.x, lat, long) * 1000;
        final int seconds = _lastSavedTime == null ? 0 : now.difference(_lastSavedTime!).inSeconds;

        if (seconds > 0 && distance / seconds > _maxSpeedMps && _skippedJumps < _maxSkippedJumps) {
          // Impossible jump (GPS spike): skip it. After a few skips accept, the user really moved.
          _skippedJumps++;
          return {"status": "error", "message": "GPS jump of ${distance.toStringAsFixed(0)} m skipped"};
        }

        if (distance < math.max(accuracy, _minMovementMeters)) {
          // Movement is within GPS noise: user is standing still, keep the last position
          lat = lastPoint.y!;
          long = lastPoint.x!;
          distance = 0;
          speed = 0;
        } else {
          bearing = calculateBearing(lastPoint.y, lastPoint.x, lat, long);
        }
      }
      _skippedJumps = 0;
      _lastSavedTaskId = taskId;
      _lastSavedTime = now;
      lastPoint = PointsModel(x: long, y: lat);

      // 4. Get battery
      int batteryPercentage = 0;
      try {
        batteryPercentage = await Battery().batteryLevel;
      } catch (_) {}

      // 5. Save offline in Hive
      HiveLocationModel hiveLocation = HiveLocationModel(
        taskId: taskId,
        subTaskId: subTaskId,
        gpsX: long,
        gpsY: lat,
        distance: distance,
        bearing: bearing,
        speed: speed,
        gpsAccuracy: accuracy,
        battery: batteryPercentage,
        inspectedDateTime: now,
      );
      final box = await _openLocationBox();
      await box.add(hiveLocation);

      return {
        "status": "saved",
        "taskId": taskId,
        "lat": hiveLocation.gpsY,
        "lng": hiveLocation.gpsX,
      };
    } catch (e) {
      print("Location Save Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }

  /// Upload offline locations to the server, grouped by task and in batches.
  /// Uploaded points are deleted from Hive; on failure they stay for the next try.
  /// Returns the task ids the server reported as closed (close_status == 3).
  static Future<Set<String>> syncOfflineLocations() async {
    final Set<String> closedTaskIds = {};
    final box = await _openLocationBox();
    if (box.isEmpty) return closedTaskIds;

    bool connected = await NetworkHelper.isConnected();
    if (!connected) return closedTaskIds;

    // Snapshot keys so points added during upload are not touched
    final Map<String, List<dynamic>> keysByTask = {};
    for (final key in box.keys.toList()) {
      final location = box.get(key);
      if (location == null) continue;
      keysByTask.putIfAbsent(location.taskId, () => []).add(key);
    }

    for (final entry in keysByTask.entries) {
      final keys = entry.value;
      for (int i = 0; i < keys.length; i += _syncBatchSize) {
        final batchKeys = keys.sublist(i, math.min(i + _syncBatchSize, keys.length));
        final payload = batchKeys
            .map((key) => box.get(key))
            .whereType<HiveLocationModel>()
            .map((location) => location.toServerJson())
            .toList();
        if (payload.isEmpty) continue;

        dynamic res;
        try {
          res = await ServerRequest.backgroundPostData(
            urlEndPoint: APIs.saveLocationDataApi,
            body: jsonEncode(payload),
          );
        } catch (e) {
          print("Batch sync failed: $e");
          return closedTaskIds;
        }

        // Network/server error: keep data offline and retry on next tick
        if (res is! Map || res['close_status'] == null) {
          print("Batch sync failed, keeping offline: $res");
          return closedTaskIds;
        }

        // Accepted (or task already closed on server): remove uploaded points
        await box.deleteAll(batchKeys);

        if (res['close_status'].toString() == "3") {
          closedTaskIds.add(entry.key);
          // Task is closed, remaining points for it are not needed
          await box.deleteAll(keys.sublist(math.min(i + _syncBatchSize, keys.length)));
          break;
        }
      }
    }
    return closedTaskIds;
  }
}
