import 'dart:convert';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHelper {
  static Future<dynamic> fetchRoutes({required String routeId}) async {
    try {
      String url = APIs.getRouteApi + routeId;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return MapModel.fromJson(res);
      }
    } catch (_) {}
    return null;
  }

  static List<LatLng> decodeEncodedPolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encoded);
    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  static Future<dynamic> fetchMarkerList({required String sectionCode}) async {
    try {
      String url = APIs.getMarkerApi + "?sectionCode=$sectionCode";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return markerListResponse(res);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchRouteDirection(
      {required ArcGISPoint startPoint,
      required ArcGISPoint endPoint,
      required ArcGISPoint currentPoint}) async {
    try {
      double startPointDistance = calculateDistance(
          currentPoint.y, currentPoint.x, startPoint.y, startPoint.x);
      double endPointDistance = calculateDistance(
          currentPoint.y, currentPoint.x, endPoint.y, endPoint.x);
      ArcGISPoint toAddress = startPoint;
      if (startPointDistance < endPointDistance) {
        toAddress = startPoint;
      } else if (startPointDistance > endPointDistance) {
        toAddress = endPoint;
      }
      return await fetchRoute(startPoint: currentPoint, endPoint: toAddress);
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> fetchRoute(
      {required ArcGISPoint startPoint, required ArcGISPoint endPoint}) async {
    List<ArcGISPoint> directionList = [];
    try {
      String url = APIs.googleDirectionsApi +
          "?destination=${endPoint.y},${endPoint.x}&origin=${startPoint.y},${startPoint.x}&mode=walking&key=AIzaSyAiFoe5ZuDbEVu0B3wyCrQsODy0lFQTxZ0";
      var res = await ServerRequest.getGoogleData(url: Uri.parse(url));
      if (res != null && res['geocoded_waypoints'] != null) {
        GoogleRouteModel routeData = GoogleRouteModel.fromJson(res);
        for (var routeData in routeData.routes!) {
          for (var legsData in routeData.legs!) {
            for (var steps in legsData.steps!) {
              if (steps.polyline!.points.toString().isNotEmpty) {
                directionList
                    .addAll(decodePolyline(steps.polyline!.points.toString()));
              }
            }
          }
        }
      }
      if (directionList.isNotEmpty) {
        directionList.add(endPoint);
      }
      return directionList;
    } catch (_) {}
    return directionList;
  }

  static Future<dynamic> locationSave({
    required PointsModel lastPoint,
    required ArcGISPoint currentPoint,
    required double speed,
    required double verticalAccuracy,
    required BuildContext context,
    required TaskModel taskData,
  }) async {
    try {
      String distance = "0.0";
      double bearing = 0.0;

      var locationRes = await LocationHelper.getLocationOfflineMode(
          context: !context.mounted ? context : context);
      LocationModel locationData = LocationModel();
      if (locationRes != null) {
        locationData = locationRes;
      }

      if (lastPoint.y != null) {
        double calculateDistance = MapHelper.calculateDistance(
                lastPoint.y, lastPoint.x, locationData.lat, locationData.long) *
            1000;
        distance = calculateDistance.toStringAsFixed(2);
      }
      bearing = calculateBearing(
          locationData.lat, locationData.long, lastPoint.y, lastPoint.x);

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
        "distance": "0",
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
          context: !context.mounted ? context : context);
      if (res != null) {
        return res;
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchPointsDetails(
      {required String sectionCode}) async {
    try {
      String url = APIs.getMarkerCrossingInidentTypePointsApi +
          "?sectionCode=$sectionCode";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return RoutePointsModel.fromJson(res, sectionCode);
      }
    } catch (e) {
      print("Get Poinst Errpor ===== ${e.toString()}");
    }
    return null;
  }

  static List<ArcGISPoint> decodePolyline(String polyline,
      {int accuracyExponent = 5}) {
    final accuracyMultiplier = math.pow(10, accuracyExponent);
    List<ArcGISPoint> coordinates = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < polyline.length) {
      int char;
      int shift = 0;
      int result = 0;

      int getCoordinate() {
        do {
          char = polyline.codeUnitAt(index++) - 63;
          result |= (char & 0x1f) << shift;
          shift += 5;
        } while (char >= 0x20);
        final value = result >> 1;
        final coordinateChange =
            (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;

        shift = result = 0;
        return coordinateChange;
      }

      lat += getCoordinate();
      lng += getCoordinate();
      coordinates.add(ArcGISPoint(
          x: lng / accuracyMultiplier, y: lat / accuracyMultiplier));
    }
    return coordinates;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var radiusOfEarth = 6371;
    return radiusOfEarth * 2 * asin(sqrt(a));
  }

  static double calculateBearing(lat1, lon1, lat2, lon2) {
    final double startLat = toRadians(lat1);
    final double startLng = toRadians(lon1);
    final double endLat = toRadians(lat2);
    final double endLng = toRadians(lon2);

    final double deltaLng = endLng - startLng;
    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);
    return (toDegrees(bearing) + 360) % 360;
  }

  static double toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  static double toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  static Future<bool> getNearestLocation(
      {required ArcGISPoint currentLocation,
      required List<List<PointsModel>> routes}) async {

    double shortestDistance = 100;

    for(var routeData in routes){
      List<PointsModel> pointsList =  routeData;
      for(var points in pointsList){
        double distance = calculateBearing(
            currentLocation.y, currentLocation.x, points.y, points.x);
        if(distance < shortestDistance){
          print("Get Distance ===== $distance");
          return true;
        }
      }
    }
    return false;
  }

}
