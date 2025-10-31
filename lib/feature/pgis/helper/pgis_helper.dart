import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/pgis/domain/model/station_model.dart';
import 'package:flutter_gail/feature/pgis/domain/model/tlp_model.dart';
import 'package:http/http.dart';

class PGISHelper {

  static Future<List<dynamic>> searchPlaces({required String input}) async {
    final url =
        'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates'
        '?f=json&SingleLine=${Uri.encodeComponent(input)}&maxLocations=5';
    final res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final candidates = json['candidates'] as List<dynamic>;
      return candidates;
    } else {
      throw Exception('Failed to fetch places: ${res.statusCode}');
    }
  }

  static Future<List<PipelineModel>?> pipelineSuggestionName({
    required BuildContext context,
    required String query,
  }) async {
    Map<String, String> para = {
      'where': "UPPER(ADMIN.PipelineLine.engroutename) LIKE '%${query.toUpperCase()}%'",
      'outFields': 'ADMIN.PipelineLine.engroutename,dbo.vw_Pipeline_GIS_Attributes.sectionName',
      'returnGeometry': 'false',
      'f': 'json',
    };
    String json = Uri(queryParameters: para).query;
    final res = await ServerRequest.getDataGail(urlEndPoint:  APIs.pipelineQuery + json);
    if (res != null && res['features'] != null) {
      final features = res['features'] as List;
      print("features--->${features}");


      return features.map((e) {
        final attr = e['attributes'];
        return PipelineModel(
        //  objectId: attr['OBJECTID'] ?? 0,
          objectId: attr['ADMIN.PipelineLine.OBJECTID'] ?? 0,
          sectionName: attr['dbo.vw_Pipeline_GIS_Attributes.sectionName']?.toString() ?? '',
          engRouteName: attr['ADMIN.PipelineLine.engroutename']?.toString() ?? '',
        );
      }).toList();
    }
    return null;
  }

  static Future<List<dynamic>?> zoomToPipeLine({
    required BuildContext context,
    required String query,
  }) async {
    try {
      Map<String, String> para = {
        'where': "UPPER(ADMIN.PipelineLine.engroutename) LIKE '%${query.toUpperCase()}%'",
        'outFields': 'ADMIN.PipelineLine.engroutename',
        'returnGeometry': 'true',
        'f': 'json',
      };
      String json = Uri(queryParameters: para).query;
      final res = await ServerRequest.getDataGail(urlEndPoint:  APIs.pipelineQuery + json);
      if (res != null && res['features'] != null) {
        final features = res['features'] as List;
        if (features.isNotEmpty) {
          final geometry = features[0]['geometry'];
          if (geometry != null && geometry['paths'] != null) {
            return geometry['paths'][0];
          }
        }
      }
    } catch (e) {
      print("zoomToEngRoute error: ${e.toString()}");
    }
    return null;
  }

  static Future<List<StationModel>> stationSuggestionName({
    required BuildContext context,
    required String query,
    String? pipelineNameOrCode,
  }) async {
    try {
      String whereClause = "UPPER(stationname) LIKE '%${query.toUpperCase()}%'";
      if (pipelineNameOrCode != null && pipelineNameOrCode.isNotEmpty) {
        whereClause += " AND UPPER(engroutename) = '${pipelineNameOrCode.toUpperCase()}'";
      }
      final params = {
        'where': whereClause,
        'outFields': 'OBJECTID,stationname,engroutename',
        'returnGeometry': 'false',
        'f': 'json',
      };
      final queryString = Uri(queryParameters: params).query;
      final fullUrl = '${APIs.stationQuery}$queryString';

      final res = await ServerRequest.getDataGail(urlEndPoint: fullUrl);
      if (res != null && res['features'] != null) {
        final features = res['features'] as List;
        return features.map((e) {
          final attr = e['attributes'];
          return StationModel(
            objectId: attr['OBJECTID'] ?? 0,
            stationName: attr['stationname']?.toString() ?? '',
            engRouteName: attr['engroutename']?.toString() ?? '',
          );
        }).toList();
      }
    } catch (e, stack) {
      print("❌ stationSuggestionName error: $e\n$stack");
    }
    return [];
  }


  static Future<Map<String, dynamic>?> zoomToStation({
    required BuildContext context,
    required String query,
  }) async {
    try {
      final geometryUrl = "${APIs.stationObject}/$query?f=pjson";
      final geometryRes = await ServerRequest.getDataGail(urlEndPoint: geometryUrl);
      if (geometryRes != null && geometryRes['feature'] != null) {
        final geometry = geometryRes['feature']['geometry'];
        if (geometry != null ) {
          if (geometry['rings'] != null) {
            return {
              'geometryType': 'polygon',
              'points': List<List<double>>.from(
                geometry['rings'][0].map<List<double>>(
                      (pt) => List<double>.from(pt),
                ),
              ),
            };
          } else if (geometry['paths'] != null) {
            return {
              'geometryType': 'polyline',
              'points': List<List<double>>.from(
                geometry['paths'][0].map<List<double>>(
                      (pt) => List<double>.from(pt),
                ),
              ),
            };
          } else {
            print("❌ Geometry found, but no 'rings' or 'paths'");
          }
        } else {
          print("❌ Geometry is null");
        }
      } else {
        print("❌ Invalid response: 'feature' not found");
      }

    } catch (e, stack) {
      print("zoomToTLPByObjectId error: $e\n$stack");
    }
    return null;
  }


  static Future<List<TLPModel>> tlpSuggestionName({
    required BuildContext context,
    required String query,
    String? pipelineNameOrCode,
  }) async {
    try {
      String whereClause = "UPPER(tlpno) LIKE '%${query.toUpperCase()}%'";
      if (pipelineNameOrCode != null && pipelineNameOrCode.isNotEmpty) {
        whereClause += " AND UPPER(engroutename) = '${pipelineNameOrCode.toUpperCase()}'";
      }

      final params = {
        'where': whereClause,
        'outFields': 'OBJECTID,tlpno,TLPType,engroutename',
        'returnGeometry': 'false',
        'f': 'json',
      };
      final queryString = Uri(queryParameters: params).query;
      final fullUrl = '${APIs.tlpQuery}$queryString';

      final res = await ServerRequest.getDataGail(urlEndPoint: fullUrl);
      if (res != null && res['features'] != null) {
        final features = res['features'] as List;
        return features.map((e) {
          final attr = e['attributes'];
          return TLPModel(
            objectId: attr['OBJECTID'] ?? 0,
            tlpno: attr['tlpno']?.toString() ?? '',
            tlpType: attr['TLPType']?.toString() ?? '',
            engRouteName: attr['engroutename']?.toString() ?? '',
          );
        }).toList();
      }
    } catch (e, stack) {
      print("❌ tlpSuggestionName error: $e\n$stack");
    }
    return [];
  }


  static Future<Map<String, dynamic>?> zoomToTLP({
    required BuildContext context,
    required String query,
  }) async {
    try {
      final geometryUrl = "${APIs.tlpObject}/$query?f=pjson";
      final geometryRes = await ServerRequest.getDataGail(urlEndPoint: geometryUrl);
      if (geometryRes != null && geometryRes.containsKey('feature')) {
        final feature = geometryRes['feature'];
        if (feature != null || feature['geometry'] != null) {
          final geom = feature['geometry'];
          final attri = feature['attributes'];
          if (geom != null && attri != null) {
            return {
              'geometryType': 'point',
              'x': geom['x'],
              'y': geom['y'],
              'attributes': attri ?? {},
            };
          }
        }
      }
    } catch (e, stack) {
      print("zoomToTLPByObjectId error: $e\n$stack");
    }
    return null;
  }

  static String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}