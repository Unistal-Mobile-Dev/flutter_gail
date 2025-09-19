import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/configuration_model.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/domain/model/marker_point_model.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_gail/utils/commonWidgets/gps_alert_pop_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  /// Fetch Google Directions polyline points
  static Future<List<ArcGISPoint>> fetchRoute({
    required ArcGISPoint startPoint,
    required ArcGISPoint endPoint,
  }) async {
    List<ArcGISPoint> directionList = [];
    try {
      String url = APIs.googleDirectionsApi +
          "?destination=${endPoint.y},${endPoint.x}&origin=${startPoint.y},${startPoint.x}&mode=walking&key=AIzaSyAiFoe5ZuDbEVu0B3wyCrQsODy0lFQTxZ0";

      var res = await ServerRequest.getGoogleData(url: Uri.parse(url));
      if (res != null && res['geocoded_waypoints'] != null) {
        GoogleRouteModel routeData = GoogleRouteModel.fromJson(res);
        for (var route in routeData.routes!) {
          for (var leg in route.legs!) {
            for (var step in leg.steps!) {
              if (step.polyline?.points != null && step.polyline!.points!.isNotEmpty) {
                directionList.addAll(decodePolyline(step.polyline!.points!));
              }
            }
          }
        }
      }

      if (directionList.isNotEmpty) directionList.add(endPoint);
    } catch (_) {}
    return directionList;
  }

  /// Decode Google polyline to ArcGIS points
  static List<ArcGISPoint> decodePolyline(String polyline, {int accuracyExponent = 5}) {
    final accuracyMultiplier = math.pow(10, accuracyExponent);
    List<ArcGISPoint> coordinates = [];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int shift = 0, result = 0, char;

      int getCoordinate() {
        do {
          char = polyline.codeUnitAt(index++) - 63;
          result |= (char & 0x1f) << shift;
          shift += 5;
        } while (char >= 0x20);

        final value = result >> 1;
        return (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;
      }

      lat += getCoordinate();
      lng += getCoordinate();
      coordinates.add(ArcGISPoint(x: lng / accuracyMultiplier, y: lat / accuracyMultiplier));
    }
    return coordinates;
  }

  /// Calculate distance in meters
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371000.0; // meters
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
  static Future<bool> getNearestLocation({
    required ArcGISPoint currentLocation,
    required List<List<PointsModel>> routes,
  }) async {
    double shortestDistance = double.infinity;

    for (var routeData in routes) {
      for (var points in routeData) {
        double distance = calculateDistance(currentLocation.y, currentLocation.x, points.y, points.x);
        if (distance < shortestDistance) {
          shortestDistance = distance;
          return true;
        }
      }
    }
    return false;
  }

  /// Save location data for a task
  static Future<dynamic> locationSave({
    required PointsModel lastPoint,
    required ArcGISPoint currentPoint,
    required double speed,
    required double verticalAccuracy,
    required BuildContext context,
    required TaskModel taskData,
  }) async {
    try {
      var locationRes = await LocationHelper.getLocationOfflineMode(context: context);
      LocationModel locationData = locationRes ?? LocationModel();

      double distance = 0;
      if (lastPoint.y != null) {
        distance = calculateDistance(lastPoint.y, lastPoint.x, locationData.lat, locationData.long) * 1000;
      }
      double bearing = calculateBearing(locationData.lat, locationData.long, lastPoint.y, lastPoint.x);

      var battery = Battery();
      int batteryPercentage = await battery.batteryLevel;

      var location = {
        "gpsx": locationData.long.toString(),
        "gpsy": locationData.lat.toString(),
        "inspected_datetime": DateTime.now().toString(),
        "gpsaccuracy": locationData.accuracy.toString(),
        "provider": "GPS1",
        "speed": speed.toString(),
        "bearing": bearing.toString(),
        "buffer": 15.0,
        "distance": distance.toStringAsFixed(2),
        "battery": batteryPercentage.toString(),
      };

      var json = {
        "task_id": taskData.taskId.toString(),
        "subtask_id": taskData.subTaskId.toString(),
        "locations": [location],
      };

      String url = APIs.saveLocationDataApi;
      var res = await ServerRequest.postData(
        urlEndPoint: url,
        body: jsonEncode(json),
        context: context,
      );

      return res;
    } catch (e) {
      print("Location Save Error: ${e.toString()}");
    }
    return null;
  }
}
