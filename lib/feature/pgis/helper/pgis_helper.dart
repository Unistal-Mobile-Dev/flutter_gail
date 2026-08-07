import 'dart:convert';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/pgis/domain/model/station_model.dart';
import 'package:flutter_gail/feature/pgis/domain/model/structure_boundary_point_model.dart';
import 'package:flutter_gail/feature/pgis/domain/model/tlp_model.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class PGISHelper {

  static Future<ArcGISPoint?> startLocationDisplay({
    required ArcGISMapViewController mapViewController,
  }) async {
    final locationDisplay = mapViewController.locationDisplay;

    // Recenter map on user location
    locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.recenter;

    try {
      // MUST be awaited
      if (!locationDisplay.started) {
        locationDisplay.start();
      }

      // Check if location is already available
      final location = locationDisplay.location;
      if (location != null) {
        final point = location.position;
        if (point.x != 0 && point.y != 0) {
          return point;
        }
      }

      // Wait for first valid GPS fix
      final completer = Completer<ArcGISPoint?>();

      late final StreamSubscription sub;
      sub = locationDisplay.onLocationChanged.listen((loc) {
        final point = loc.position;
        if (point.x != 0 && point.y != 0) {
          completer.complete(point);
          sub.cancel();
        }
      });

      // Timeout safety
      Future.delayed(const Duration(seconds: 8), () {
        if (!completer.isCompleted) {
          completer.complete(null);
          sub.cancel();
        }
      });

      return completer.future;
    } catch (e) {
      debugPrint("Failed to start location display: $e");
      return null;
    }
  }


  static Future<ArcGISPoint> startCurrentLocation() async {
    final locationDataSource = SystemLocationDataSource();
    final completer = Completer<ArcGISPoint>();

    await locationDataSource.start();

    late final StreamSubscription subscription;

    subscription = locationDataSource.onLocationChanged.listen((location) {
      final pos = location.position;
      if (pos == null) return;

      // Reject invalid GPS fixes
      if (pos.x == 0 || pos.y == 0) return;

      final point = toWgs84(
        ArcGISPoint(
          x: pos.x,
          y: pos.y,
          spatialReference: pos.spatialReference,
        ),
      );

      if (!completer.isCompleted) {
        completer.complete(point);
      }

      // Clean up after first valid location
      subscription.cancel();
      locationDataSource.stop();
    });

    return completer.future;
  }


  static ArcGISPoint toWgs84(ArcGISPoint point) {
    if (point.spatialReference == SpatialReference.wgs84) {
      return point;
    }
    return GeometryEngine.project(
      point,
      outputSpatialReference:  SpatialReference.wgs84,
    ) as ArcGISPoint;
  }


 static ArcGISPoint createPoint({required double lat, required double lon}) {
    return ArcGISPoint(
      x: lon,
      y: lat,
      spatialReference: SpatialReference.wgs84,
    );
  }

  static void drawPoint({required ArcGISPoint point,required Color color, required GraphicsOverlay graphicsOverlay}) {
    graphicsOverlay.graphics.clear();
    final graphic = Graphic(
      geometry: point,
      symbol: SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: color,
        size: 12,
      ),
    );

    graphicsOverlay.graphics.add(graphic);
  }

  static Future<Geometry> drawBuffer({
    required ArcGISMapViewController mapController,
    required ArcGISPoint point,
    required double distanceMeters,
    required GraphicsOverlay graphicsOverlay,
  }) async {
    graphicsOverlay.graphics.clear();

    final Geometry bufferGeometry = GeometryEngine.bufferGeodetic(
      geometry: point,
      distance: distanceMeters,
      distanceUnit: LinearUnit(unitId: LinearUnitId.meters),
      curveType: GeodeticCurveType.geodesic,
      maxDeviation: double.nan,
    );

    graphicsOverlay.graphics.addAll([
      Graphic(
        geometry: bufferGeometry,
        symbol: SimpleFillSymbol(
          style: SimpleFillSymbolStyle.solid,
          color: Colors.blue.withOpacity(0.15),
          outline: SimpleLineSymbol(
            style: SimpleLineSymbolStyle.solid,
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
      Graphic(
        geometry: point,
        symbol: SimpleMarkerSymbol(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.purple,
          size: 15,
        ),
      ),
    ]);
    return bufferGeometry;
  }


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
      // 'where': "(UPPER(sectionName) LIKE '%${query.toUpperCase()}%' "
      //     "OR UPPER(engroutename) LIKE '%${query.toUpperCase()}%')",
      'where': '1=1',
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
       // 'where': "UPPER(ADMIN.PipelineLine.engroutename) LIKE '%${query.toUpperCase()}%'",
        'where': '1=1',
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
      String whereClause =
          "(UPPER(stationname) LIKE '%${query.toUpperCase()}%' "
          "OR UPPER(engroutename) LIKE '%${query.toUpperCase()}%')";

      if (pipelineNameOrCode != null && pipelineNameOrCode.isNotEmpty) {
        whereClause += " AND UPPER(engroutename) = '${pipelineNameOrCode.toUpperCase()}'";
      }
      final params = {
        //'where': whereClause,
        'where': '1=1',
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
      print("error: $e\n$stack");
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
       // 'where': whereClause,
        'where': '1=1',
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


  static Future<void> openGoogleMapsNavigation({
    required double sourceLat,
    required double sourceLng,
    required double destLat,
    required double destLng,
  }) async {
    final googleUrl =
        "https://www.google.com/maps/dir/?api=1"
        "&origin=$sourceLat,$sourceLng"
        "&destination=$destLat,$destLng"
        "&travelmode=driving&dir_action=navigate";

    final uri = Uri.parse(googleUrl);

    print("Google Maps URL -> $googleUrl");

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      throw Exception("❌ Could not open Google Maps");
    }
  }

  static showLoaderDialog(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Flexible(child: Text(message, style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<List<StructureBoundaryFeature>>
  structureBoundaryQuery({
    required BuildContext context,
    required String query,
    required Geometry bufferGeometry,
    required SpatialReference spatialReference,
  }) async {
    final params = <String, String>{
      'where': query.isNotEmpty
          ? "(UPPER(stationname) LIKE '%${query.toUpperCase()}%' "
          "OR UPPER(engroutename) LIKE '%${query.toUpperCase()}%')"
          : '1=1',

      'geometry': jsonEncode(bufferGeometry.toJson()),
      'geometryType': 'esriGeometryPolygon',
      'spatialRel': 'esriSpatialRelIntersects',

      'inSR': spatialReference.wkid.toString(),
      'outSR': spatialReference.wkid.toString(),

      'outFields':
      'OBJECTID,stationname,engroutename,continroutename,'
          'engm,continm,Area_SqM_Station,newType,newLevel',

      'returnGeometry': 'true',
      'f': 'json',
    };

    final queryString = Uri(queryParameters: params).query;

    final res = await ServerRequest.getDataGail(
      urlEndPoint: APIs.structureBoundaryQuery + queryString,
    );

    if (res == null || res['features'] == null) {
      return <StructureBoundaryFeature>[];
    }

    return (res['features'] as List<dynamic>)
        .map(
          (e) => StructureBoundaryFeature.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  static ArcGISMap buildMapWithBasemap(PGISBasemapType type) {
    switch (type) {
      case PGISBasemapType.streets:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);

      case PGISBasemapType.satellite:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISImagery);

      case PGISBasemapType.topo:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISTopographic);

      case PGISBasemapType.lightGray:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISLightGray);

      case PGISBasemapType.darkGray:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISDarkGray);

      default:
        return ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    }
  }

}