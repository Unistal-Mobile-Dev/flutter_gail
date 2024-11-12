import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math' as math;

class MapHelper {

  static Future<dynamic> fetchRouteDirection(
      {required ArcGISPoint startPoint,
        required ArcGISPoint endPoint,
        required ArcGISPoint currentPoint}) async {

    try{
      double startPointDistance = calculateDistance(
          currentPoint.y, currentPoint.x,
          startPoint.y, startPoint.x);
      double endPointDistance = calculateDistance(
          currentPoint.y, currentPoint.x,
          endPoint.y, endPoint.x);
      ArcGISPoint toAddress =  startPoint;
      if(startPointDistance < endPointDistance) {
        toAddress =  startPoint;
      }
      else if(startPointDistance > endPointDistance){
        toAddress =  endPoint;
      }
       return await fetchRoute(startPoint: currentPoint, endPoint: toAddress);
    } catch(_) {
      return null;
    }
  }

  static Future<dynamic> fetchRoute({required ArcGISPoint startPoint,
    required ArcGISPoint endPoint}) async {
    List<ArcGISPoint> directionList = [];
    try{
      String url = "https://maps.googleapis.com/maps/api/directions/json?destination=${endPoint.y},${endPoint.x}&origin=${startPoint.y},${startPoint.x}&mode=walking&key=AIzaSyAiFoe5ZuDbEVu0B3wyCrQsODy0lFQTxZ0";
      var res =  await ServerRequest.getGoogleData(url: Uri.parse(url));
      if(res != null && res['geocoded_waypoints'] != null){
        GoogleRouteModel routeData =  GoogleRouteModel.fromJson(res);
        for(var routeData in routeData.routes!){
           for(var legsData in routeData.legs!) {
             for(var steps in legsData.steps!){
               if(steps.polyline!.points.toString().isNotEmpty){
                 directionList.addAll(decodePolyline(steps.polyline!.points.toString()));
               }
             }
           }
        }
      }
      if(directionList.isNotEmpty){
        directionList.add(endPoint);
      }
      return directionList;
    }catch(_){}
    return directionList;
  }

  static Future<dynamic> locationSave(
      {required PointsModel lastPoint,
    required ArcGISPoint currentPoint}) async {
    try{
      String distance = "0.0";
      if(lastPoint.y != null){
       double calculateDistance = MapHelper.calculateDistance(
            lastPoint.y, lastPoint.x, currentPoint.y, currentPoint.x) * 1000;
         distance  = calculateDistance.toStringAsFixed(2);
      }
    }catch(_){}
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
      coordinates.add(
          ArcGISPoint (x: lng / accuracyMultiplier, y: lat / accuracyMultiplier));
    }
    return coordinates;
  }



  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    var radiusOfEarth = 6371;
    return radiusOfEarth * 2 * asin(sqrt(a));
  }

}