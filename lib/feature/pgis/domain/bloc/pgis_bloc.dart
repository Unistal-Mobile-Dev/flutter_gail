import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/domain/model/structure_boundary_point_model.dart';
import 'package:flutter_gail/feature/pgis/helper/pgis_helper.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/filter_widget.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/map_layer_widget.dart';
import 'package:permission_handler/permission_handler.dart';

part 'pgis_event.dart';

part 'pgis_state.dart';

class PgisBloc extends Bloc<PgisEvent, PgisState> {
  bool isPageLoader = false;
  bool isArcGISStreets = false;

  bool isPipelineDeviceCheck = true;
  bool isStructureCheck = true;
  bool isPipelineCheck = true;
  bool isContinuousCheck = true;
  bool isEngineeringCheck = true;
  bool isStructureBoundaryCheck = true;
  bool isServiceCheck = true;
  bool isCadastralCheck = false;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController pipelineCtrl = TextEditingController();
  TextEditingController sectionCtrl = TextEditingController();
  TextEditingController stationCtrl = TextEditingController();
  TextEditingController tlpCtrl = TextEditingController();

  AppPermissionStatus locationPermission = AppPermissionStatus.denied;
  ArcGISMap arcGISMapType = ArcGISMap.withBasemapStyle(
    BasemapStyle.arcGISStreets,
  );
  final locationDataSource = SystemLocationDataSource();

  final pipelineLayerUrl = 'server/rest/services/UPIMS/MobileApp/MapServer';

  final indiaEnvelope = Envelope.fromXY(
    xMin: 68.0,
    yMin: 6.0,
    xMax: 98.0,
    yMax: 36.0,
    spatialReference: SpatialReference(wkid: 4326),
  );

  List<Layer> layer = [];
  List<FeatureLayer> featureLayerList = [];
  List<StructureBoundaryFeature> stationList = [];

  GraphicsOverlay _pipelineOverlay = GraphicsOverlay();
  GraphicsOverlay _stationOverlay = GraphicsOverlay();
  GraphicsOverlay _tlpOverlay = GraphicsOverlay();
  GraphicsOverlay bufferOverlay = GraphicsOverlay();

  PgisBloc() : super(PgisInitial()) {
    on<PgisPageLoadedEvent>(_pageLoad);
    on<SelectMapArcGISStreets>(_selectMapType);
    on<PGISMapReady>(_onMapReady);
    on<IdentifyFeaturesAtTapEvent>(_onIdentifyFeatures);
    on<StartNavigationEvent>(_onStartNavigation);
    on<LocationEvent>(_location);
    on<SearchRoundedEvent>(_searchRounded);
    on<MapLayerEvent>(_mapLayer);
    on<SelectPipelineEngRouteEvent>(_selectEngRoute);
    on<SelectStationEvent>(_selectStation);
    on<SelectTLPEvent>(_selectTLP);
    on<StopNavigationEvent>(_onStopNavigation);
    on<TogglePipelineDeviceEvent>(_togglePipelineDevice);
    on<ToggleStructureEvent>(_toggleStructure);
    on<TogglePipelineEvent>(_togglePipeline);
    on<ToggleContinuousEvent>(_toggleContinuous);
    on<ToggleEngineeringEvent>(_toggleEngineering);
    on<ToggleStructureBoundaryEvent>(_toggleStructureBoundary);
    on<ToggleServiceEvent>(_toggleService);
    on<ToggleCadastralEvent>(_toggleCadastral);
    on<ResetPipelineEvent>(_resetPipeline);
    on<ResetStationEvent>(_resetStation);
    on<ResetTLPEvent>(_resetTLP);
  }

  _pageLoad(PgisPageLoadedEvent event, emit) async {
    emit(PgisPageLoadingState());
    isPageLoader = false;
    isArcGISStreets = false;
    isPipelineDeviceCheck = true;
    isStructureCheck = true;
    isPipelineCheck = true;
    isContinuousCheck = true;
    isEngineeringCheck = true;
    isStructureBoundaryCheck = true;
    isServiceCheck = true;
    isCadastralCheck = false;

    stationList = [];
    arcGISMapType = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    textEditingController = TextEditingController();
    _pipelineOverlay = GraphicsOverlay();
    _stationOverlay = GraphicsOverlay();
    _tlpOverlay = GraphicsOverlay();
    requestLocationPermissions();
    _eventCompleted(emit);
  }

  Future<void> requestLocationPermissions() async {
    final requestPermission = await Permission.location.request();
    if (requestPermission.isGranted) {
      locationPermission = AppPermissionStatus.granted;
    } else if (requestPermission.isPermanentlyDenied) {
      locationPermission = AppPermissionStatus.permanentlyDenied;
    } else {
      locationPermission = AppPermissionStatus.denied;
    }
  }

  _selectMapType(SelectMapArcGISStreets event, emit) async {
    isArcGISStreets = event.isArcGISStreets;

    final newMap = ArcGISMap.withBasemapStyle(
      isArcGISStreets ? BasemapStyle.arcGISImagery : BasemapStyle.arcGISStreets,
    );
    event.controller.arcGISMap = newMap;
    await newMap.load();
    await _addPipelineLayer(event.controller);
    await event.controller.setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 40,
    );
    _eventCompleted(emit);
  }

  Future<void> _location(LocationEvent event, emit) async {
    final controller = event.controller;
    controller.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.recenter;
    _eventCompleted(emit);
  }

  Future<void> _searchRounded(SearchRoundedEvent event, emit) async {
    showDialog(
      context: event.ctx,
      builder: (BuildContext context) {
        return FilterWidget(mapViewController: event.arcGISMapViewController);
      },
    );
    _eventCompleted(emit);
  }

  _mapLayer(MapLayerEvent event, emit) {
    showDialog(
      context: event.ctx,
      builder: (BuildContext context) {
        return MapLayerWidget(controller: event.controller);
      },
    );
    _eventCompleted(emit);
  }

  GraphicsOverlay planarBufferOverlay = GraphicsOverlay();
  GraphicsOverlay geodeticBufferOverlay = GraphicsOverlay();

  Future<void> _onIdentifyFeatures(IdentifyFeaturesAtTapEvent event, emit,) async {
    PGISHelper.showLoaderDialog(event.context);
    _eventCompleted(emit);

    final attributeJsonList = <Map<String, dynamic>>[];

    try {
      for (final featureLayer in featureLayerList) {
        featureLayer.clearSelection();

        final identifyLayerResult = await event.controller.identifyLayer(
          featureLayer,
          screenPoint: event.offset,
          tolerance: 22,
          maximumResults: 1000,
        );

        final features = identifyLayerResult.geoElements.whereType<Feature>().toList();
        for (final feature in features) {
          final table = feature.featureTable;
          for (final entry in feature.attributes.entries) {
            String displayName = entry.key;
            String? fieldType;

            if (table != null) {
              final field = table.fields.where((f) => f.name == entry.key).cast<Field?>().firstOrNull;

              if (field != null) {
                displayName = field.alias;
                fieldType = field.type.name;
              }
            }
            attributeJsonList.add({
              "field": displayName,
              "value": entry.value ?? "—",
              "type": fieldType ?? "unknown",
            });
          }
        }
      }
      if (!event.context.mounted) return;
      Navigator.pop(event.context);

      if (attributeJsonList.isNotEmpty) {
        if (!event.context.mounted) return;
        showAttributeDialog(
          destination: event.offset,
          controller: event.controller,
          context: event.context,
          attributeJsonList: attributeJsonList,
        );
      }

      final ArcGISPoint? tapPoint =  event.controller.screenToLocation(screen: event.offset);
      if (tapPoint == null) {
        if (!event.context.mounted) return;
        Navigator.pop(event.context);
        return;
      }

      final Geometry bufferGeometry = await PGISHelper.drawBuffer(
        mapController: event.controller,
        point: tapPoint,
        distanceMeters: 1000,
        graphicsOverlay: bufferOverlay,
      );
      if (!event.context.mounted) return;
      final stations = await PGISHelper.structureBoundaryQuery(
        context: event.context,
        query: '',
        spatialReference: tapPoint.spatialReference!,
        bufferGeometry: bufferGeometry,
      );

      for (final s in stations) {
        bufferOverlay.graphics.add(
          Graphic(
            geometry: ArcGISPoint(
              x: s.geometry.x,
              y: s.geometry.y,
              spatialReference: tapPoint.spatialReference,
            ),
            symbol: SimpleMarkerSymbol(
              style: SimpleMarkerSymbolStyle.circle,
              color: Colors.blue,
              size: 15,
            ),
          ),
        );
      }

      await event.controller.setViewpointCenter(tapPoint, scale: 1000);

      if (stations.isNotEmpty) {
        stationList = stations;
        _eventCompleted(emit);
      }
    } catch (e) {
      if (!event.context.mounted) return;
      Navigator.pop(event.context);
      debugPrint("Identify error: $e");
    }

    _eventCompleted(emit);
  }

  // Future<void> _onIdentifyFeatures(IdentifyFeaturesAtTapEvent event, emit,) async {
  //
  //   PGISHelper.showLoaderDialog(event.context);
  //   _eventCompleted(emit);
  //   final attributeJsonList = <Map<String, dynamic>>[];
  //   try {
  //     for (final featureLayer in featureLayerList) {
  //       featureLayer.clearSelection();
  //     //  await _findNearbyFromFeature(controller: event.controller, tapOffset: event.offset);
  //       final identifyLayerResult = await event.controller.identifyLayer(
  //         featureLayer,
  //         screenPoint: event.offset,
  //         tolerance: 22,
  //         maximumResults: 1000,
  //       );
  //
  //       final features = identifyLayerResult.geoElements.whereType<Feature>().toList();
  //
  //       if (features.isNotEmpty) {
  //         for (final feature in features) {
  //           final table = feature.featureTable;
  //           for (final entry in feature.attributes.entries) {
  //             final fieldName = entry.key;
  //             final value = entry.value;
  //             String displayName = fieldName;
  //             String? fieldType;
  //             if (table != null) {
  //               final field = table.fields.where((f) => f.name == fieldName).cast<Field?>().firstOrNull;
  //
  //               if (field != null) {
  //                 fieldType = field.type.name;
  //                 displayName = field.alias;
  //               }
  //             }
  //             attributeJsonList.add({
  //               "field": displayName,
  //               "value": value ?? "—",
  //               "type": fieldType ?? "unknown",
  //             });
  //           }
  //         }
  //       } else {
  //         final selectedResult = await featureLayer.getSelectedFeatures();
  //         final selectedFeatures = selectedResult.features();
  //         for (final feature in selectedFeatures) {
  //           featureLayer.unselectFeature(feature);
  //         }
  //       }
  //     }
  //     Navigator.pop(event.context);
  //     if (attributeJsonList.isNotEmpty) {
  //       showAttributeDialog(
  //         destination: event.offset,
  //         controller: event.controller,
  //         context: event.context,
  //         attributeJsonList: attributeJsonList,
  //       );
  //     }
  //   } catch (e) {
  //     Navigator.pop(event.context);
  //     debugPrint("Identify error: $e");
  //   }
  //   _eventCompleted(emit);
  // }

  Future<void> _onStartNavigation(StartNavigationEvent event, emit) async {
    final mapController = event.controller;

    final currentPos = mapController.locationDisplay.location?.position;
    if (currentPos == null) {
      if (kDebugMode) {
        print("❌ Current location not found!");
      }
      return;
    }

    final currentGeo = GeometryEngine.project(currentPos, outputSpatialReference: SpatialReference.wgs84,) as ArcGISPoint;

    double currentLat = currentGeo.y;
    double currentLng = currentGeo.x;

    final destGeo = GeometryEngine.project(event.destination, outputSpatialReference: SpatialReference.wgs84) as ArcGISPoint;

    final double destLat = destGeo.y;
    final double destLng = destGeo.x;

    await PGISHelper.openGoogleMapsNavigation(
      sourceLat: currentLat,
      sourceLng: currentLng,
      destLat: destLat,
      destLng: destLng,
    );

    _eventCompleted(emit);
  }

  void showAttributeDialog({
    required BuildContext context,
    required ArcGISMapViewController controller,
    required Offset destination,
    required List<Map<String, dynamic>> attributeJsonList,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do you want to navigate?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.navigation, color: Colors.white),
                  label: const Text(
                    "Navigator",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final mapPoint =  controller.screenToLocation(
                      screen: Offset(destination.dx, destination.dy),
                    );
                    if (mapPoint != null) {

                      Navigator.of(context).pop();
                      context.read<PgisBloc>().add(
                        StartNavigationEvent(
                          controller: controller,
                          destination: mapPoint,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'Feature Info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: attributeJsonList.length,
                    itemBuilder: (context, index) {
                      final item = attributeJsonList[index];
                      return ListTile(
                        dense: true,
                        title: Text(item["field"].toString()),
                        subtitle: Text("Value: ${item["value"]}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _enableUserLocation(ArcGISMapViewController controller) async {
    controller.locationDisplay.dataSource = locationDataSource;
    await locationDataSource.start();
  }

  _onMapReady(PGISMapReady event, emit) async {
    final controller = event.controller;
    controller.arcGISMap = arcGISMapType;
    await controller.setViewpointGeometry(indiaEnvelope, paddingInDiPs: 50);
    await _enableUserLocation(controller);
    await _addPipelineLayer(controller);
    // await _addCadastralLayer(controller);
  //  await initRoute();

    bufferOverlay = GraphicsOverlay();
    event.controller.graphicsOverlays.add(bufferOverlay);
    _eventCompleted(emit);
  }

  ServiceFeatureTable? _pipelineTable;

  Map<String, ArcGISMapImageSublayer> layerMap = {};
  final Map<String, ServiceFeatureTable> sublayerTables = {};

  Future<void> _addPipelineLayer(ArcGISMapViewController controller) async {
    final uri = Uri.parse(APIs.baseGailUrl + APIs.pipelineLayerUrl);

    final pipelineLayer = ArcGISMapImageLayer.withUri(uri);
    await pipelineLayer.load();

    controller.arcGISMap?.operationalLayers.add(pipelineLayer);

    for (final content in pipelineLayer.subLayerContents) {
      if (content is ArcGISMapImageSublayer) {
        await content.load();

        final id = content.id.toString();
        layerMap[id] = content;

        final sublayerUri = content.table?.uri;
        if (sublayerUri != null) {
          final table = ServiceFeatureTable.withUri(sublayerUri);
          final featureLayer = FeatureLayer.withFeatureTable(table);
          await featureLayer.load();
          featureLayerList.add(featureLayer);

          sublayerTables[id] = table;
          if (id == '8') {
            _pipelineTable = table;
            if (kDebugMode) {
              print("_pipelineTable88888888888888888--   $_pipelineTable");
            }
          }

          log('Sublayer $id ready → $sublayerUri');
        }
      }
    }
  }

  // Future<void> _addPipelineLayer(ArcGISMapViewController controller) async {
  //   String urlString = APIs.baseGailUrl + APIs.pipelineLayerUrl;
  //
  //   final uri = Uri.parse(urlString);
  //   log("url--->${uri}");
  //   final pipelineLayer = ArcGISMapImageLayer.withUri(uri);
  //
  //   await pipelineLayer.load();
  //   controller.arcGISMap?.operationalLayers.add(pipelineLayer);
  //
  //   layerMap.clear();
  //   for (final content in pipelineLayer.subLayerContents) {
  //     if (content is ArcGISMapImageSublayer) {
  //       final sublayerUri = content.table?.uri;
  //       await content.load();
  //       final id = content.id.toString();
  //       layerMap[id] = content;
  //       if (sublayerUri != null) {
  //         print('🆔 Sublayer URI: $sublayerUri');
  //         final serviceFeatureTable = ServiceFeatureTable.withUri(sublayerUri,);
  //         final featureLayer = FeatureLayer.withFeatureTable(serviceFeatureTable,);
  //         await featureLayer.load();
  //         featureLayerList.add(featureLayer);
  //       }
  //     }
  //   }
  //   print("All layers loaded → ${layerMap.keys.toList()}");
  // }

  // Future<void> _addCadastralLayer(ArcGISMapViewController controller) async {
  //     try {
  //   final urlString = APIs.baseGailUrl + APIs.cadastralLayerUrl;
  //   final uri = Uri.parse(urlString);
  //   log("url--->$uri");
  //   final pipelineLayer = ArcGISMapImageLayer.withUri(uri);
  //   await pipelineLayer.load();
  //   controller.arcGISMap!.operationalLayers.add(pipelineLayer);
  //   for (final content in pipelineLayer.subLayerContents) {
  //     if (content is ArcGISMapImageSublayer) {
  //       await content.load();
  //       final sublayerUri = content.table?.uri;
  //       if (sublayerUri != null) {
  //         if (kDebugMode) {
  //           print('🆔 Sublayer URI: $sublayerUri');
  //         }
  //         final serviceFeatureTable = ServiceFeatureTable.withUri(sublayerUri);
  //         final featureLayer = FeatureLayer.withFeatureTable(
  //           serviceFeatureTable,
  //         );
  //         await featureLayer.load();
  //         featureLayerList.add(featureLayer);
  //       }
  //     }
  //   }
  //   controller.arcGISMap!.operationalLayers.addAll(featureLayerList);
  //   await controller.setViewpointGeometry(indiaEnvelope, paddingInDiPs: 12);
  //   } catch (e) {
  //     print('❌ Error loading layer: $e');
  //   }
  // }

  ArcGISMapImageLayer? _cadastralMapImageLayer;
  final List<FeatureLayer> _cadastralFeatureLayers = [];

  Future<void> _addCadastralLayer(
      ArcGISMapViewController controller,
      ) async {
    if (_cadastralMapImageLayer != null) {
      return; // already added
    }

    try {
      final urlString = APIs.baseGailUrl + APIs.cadastralLayerUrl;
      final uri = Uri.parse(urlString);
      log("Cadastral URL ---> $uri");

      final mapImageLayer = ArcGISMapImageLayer.withUri(uri);
      await mapImageLayer.load();

      controller.arcGISMap!.operationalLayers.add(mapImageLayer);
      _cadastralMapImageLayer = mapImageLayer;

      for (final content in mapImageLayer.subLayerContents) {
        if (content is ArcGISMapImageSublayer) {
          await content.load();

          final sublayerUri = content.table?.uri;
          if (sublayerUri == null) continue;

          final serviceFeatureTable = ServiceFeatureTable.withUri(sublayerUri);

          final featureLayer = FeatureLayer.withFeatureTable(serviceFeatureTable);
          await featureLayer.load();
          _cadastralFeatureLayers.add(featureLayer);
        }
      }

      controller.arcGISMap!.operationalLayers.addAll(_cadastralFeatureLayers);

      await controller.setViewpointGeometry(
        indiaEnvelope,
        paddingInDiPs: 12,
      );
    } catch (e, s) {
      log('❌ Error loading cadastral layer', error: e, stackTrace: s);
    }
  }

  void _removeCadastralLayer(ArcGISMapViewController controller,) {
    if (_cadastralMapImageLayer == null) return;

    for (final layer in _cadastralFeatureLayers) {
      controller.arcGISMap!.operationalLayers.remove(layer);
    }
    controller.arcGISMap!.operationalLayers.remove(_cadastralMapImageLayer);
    _cadastralFeatureLayers.clear();
    _cadastralMapImageLayer = null;
  }


  // static Future<void> _addCadastralLayer(ArcGISMapViewController controller) async {
  //   String urlString = APIs.baseGailUrl + APIs.cadastralLayerUrl;
  //
  //   final uri = Uri.parse(urlString);
  //   log("url--->${uri}");
  //   final pipelineLayer = ArcGISMapImageLayer.withUri(uri);
  //
  //   await pipelineLayer.load();
  //   controller.arcGISMap?.operationalLayers.add(pipelineLayer);
  //
  //   layerMap.clear();
  //   for (final content in pipelineLayer.subLayerContents) {
  //     if (content is ArcGISMapImageSublayer) {
  //       await content.load();
  //
  //       final id = content.id.toString();
  //
  //       print("📌 Loaded Sublayer → ID: $id | Name: ${content.name}");
  //
  //       // Store real sublayer reference
  //       layerMap[id] = content;
  //     }
  //   }
  //
  //   print("🎉 All layers loaded → ${layerMap.keys.toList()}");
  // }

  void _setLayerVisibility(String key, bool visible) {
    final layer = layerMap[key];
    if (layer != null) {
      layer.isVisible = visible;
      if (kDebugMode) {
        print("🔄 Layer [$key] visibility → $visible");
      }
    } else {
      if (kDebugMode) {
        print("❌ Layer ID $key not found!");
      }
    }
  }

  final _origin = ArcGISPoint(x: -117.1490, y: 32.7353, spatialReference: SpatialReference.wgs84);
  final _destination = ArcGISPoint(x: -117.2266, y: 32.7630, spatialReference: SpatialReference.wgs84);

  late RouteResult _routeResult;

  Future<void> initRoute() async {
    try {
      final initialLocation = Stop(_origin);
      final nextDeliveryLocation = Stop(_destination);

      final routeTask = RouteTask.withUri(
        Uri.parse(
          'https://sampleserver7.arcgisonline.com/server/rest/services/NetworkAnalysis/SanDiego/NAServer/Route',
        ),
      );

      final routeParameters = await routeTask.createDefaultParameters();

      routeParameters.setStops([initialLocation, nextDeliveryLocation]);
      routeParameters.returnRoutes = true;
      routeParameters.returnStops = true;
      routeParameters.returnDirections = true;
      // routeParameters.findBestSequence = false;
      routeParameters.preserveFirstStop = true;
      // routeParameters.setOutSpatialReference(SpatialReference.wgs84);
      _routeResult = await routeTask.solveRoute(routeParameters);

      if (_routeResult.routes.isEmpty) return;
    } catch (e) {
      if (kDebugMode) {
        print("Route solving error: $e");
      }
    }
  }

  final _stops = <Stop>[];
  final _stopsGraphicsOverlay = GraphicsOverlay();

  Future<void> initStops() async {
    final routeStartCircleSymbol = SimpleMarkerSymbol(
      color: Colors.blue,
      size: 15,
    );
    final routeEndCircleSymbol = SimpleMarkerSymbol(
      color: Colors.blue,
      size: 15,
    );
    final routeStartNumberSymbol = TextSymbol(
      text: '1',
      color: Colors.white,
      size: 10,
    );
    final routeEndNumberSymbol = TextSymbol(
      text: '2',
      color: Colors.white,
      size: 10,
    );

    // Configure pre-defined start and end points for the route.
    final startPoint = ArcGISPoint(
      x: -13041171.537945,
      y: 3860988.271378,
      spatialReference: SpatialReference.webMercator,
    );

    final endPoint = ArcGISPoint(
      x: -13041693.562570,
      y: 3856006.859684,
      spatialReference: SpatialReference.webMercator,
    );

    final originStop = Stop(startPoint)..name = 'Origin';

    final destinationStop = Stop(endPoint)..name = 'Destination';

    _stops.add(originStop);
    _stops.add(destinationStop);

    _stopsGraphicsOverlay.graphics.addAll([
      Graphic(geometry: startPoint, symbol: routeStartCircleSymbol),
      Graphic(geometry: endPoint, symbol: routeEndCircleSymbol),
      Graphic(geometry: startPoint, symbol: routeStartNumberSymbol),
      Graphic(geometry: endPoint, symbol: routeEndNumberSymbol),
    ]);
  }

  _selectEngRoute(SelectPipelineEngRouteEvent event, emit) async {
    final polylineBuilder = PolylineBuilder(
      spatialReference: SpatialReference.wgs84,
    );
    var res = await PGISHelper.zoomToPipeLine(
      context: event.context,
      query: event.query,
    );
    if (res != null) {
      for (var point in res) {
        polylineBuilder.addPoint(
          ArcGISPoint(
            x: point[0],
            y: point[1],
            spatialReference: SpatialReference.wgs84,
          ),
        );
      }
      final polyline = polylineBuilder.toGeometry();

      final graphic = Graphic(
        geometry: polyline,
        symbol: SimpleLineSymbol(
          color: Colors.red,
          width: 3,
          style: SimpleLineSymbolStyle.solid,
        ),
      );

      _pipelineOverlay.graphics.add(graphic);
      event.controller.graphicsOverlays.clear();
      event.controller.graphicsOverlays.add(_pipelineOverlay);
      await event.controller.setViewpointGeometry(polyline, paddingInDiPs: 100);
    }
    _eventCompleted(emit);
  }

  _selectStation(SelectStationEvent event, emit) async {
    final polylineBuilder = PolylineBuilder(
      spatialReference: SpatialReference.wgs84,
    );
    var res = await PGISHelper.zoomToStation(
      context: event.context,
      query: event.query,
    );
    if (res != null) {
      final points = res['points'];
      if (kDebugMode) {
        print(
        "Points--------------------------------------------------$points",
      );
      }
      if (points != null && points is List) {
        for (var point in points) {
          polylineBuilder.addPoint(
            ArcGISPoint(
              x: point[0],
              y: point[1],
              spatialReference: SpatialReference.wgs84,
            ),
          );
        }
        final polygon = polylineBuilder.toGeometry();

        final fillSymbol = SimpleFillSymbol(
          style: SimpleFillSymbolStyle.solid,
          color: Colors.red.withValues(red: 0.3, green: 0.3),
          outline: SimpleLineSymbol(
            color: Colors.red,
            width: 2,
            style: SimpleLineSymbolStyle.solid,
          ),
        );

        final graphic = Graphic(geometry: polygon, symbol: fillSymbol);

        _stationOverlay.graphics.clear();
        _stationOverlay.graphics.add(graphic);

        await event.controller.setViewpointGeometry(
          polygon,
          paddingInDiPs: 100,
        );
      }
      _eventCompleted(emit);
    }
  }

  _selectTLP(SelectTLPEvent event, emit) async {
    var res = await PGISHelper.zoomToTLP(
      context: event.context,
      query: event.query,
    );
    if (res != null &&
        res['geometryType'] == 'point' &&
        res['attributes'] != null) {
      final double x = res['x'];
      final double y = res['y'];

      final attributes = res['attributes'] ?? {};
      final point = ArcGISPoint(
        x: x,
        y: y,
        spatialReference: SpatialReference.wgs84,
      );
      final markerSymbol = SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: Colors.red,
        size: 12,
      );

      final graphic = Graphic(geometry: point, symbol: markerSymbol);

      _tlpOverlay.graphics.add(graphic);
      event.controller.graphicsOverlays.add(_tlpOverlay);

      await event.controller.setViewpointCenter(point, scale: 5000);
      if (attributes != null) {
        if (!event.context.mounted) return;
        showModalBottomSheet(
          context: event.context,
          builder:
              (_) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TLP No: ${attributes['tlpno'] ?? ''}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("TLP Type: ${attributes['TLPType'] ?? ''}"),
                  ],
                ),
              ),
        );
      }
      _eventCompleted(emit);
    } else {
      if (kDebugMode) {
        print("❌ No point geometry returned for TLP");
      }
    }
  }

  _resetPipeline(ResetPipelineEvent event, emit) async {
    _pipelineOverlay.graphics.clear();
    event.controller.graphicsOverlays.remove(_pipelineOverlay);
    pipelineCtrl.clear();
    sectionCtrl.clear();
    tlpCtrl.clear();
    await event.controller.setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );
    _eventCompleted(emit);
  }

  _resetStation(ResetStationEvent event, emit) async {
    _stationOverlay.graphics.clear();
    event.controller.graphicsOverlays.remove(_stationOverlay);
    sectionCtrl.clear();
    await event.controller.setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );
    _eventCompleted(emit);
  }

  _resetTLP(ResetTLPEvent event, emit) async {
    _tlpOverlay.graphics.clear();
    event.controller.graphicsOverlays.remove(_tlpOverlay);
    tlpCtrl.clear();
    await event.controller.setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );
    _eventCompleted(emit);
  }

  _onStopNavigation(StopNavigationEvent event, emit) async {
    final mapController = event.controller;
    mapController.locationDisplay.autoPanMode = LocationDisplayAutoPanMode.off;
    // emit(state.copyWith(isNavigating: false, routeStatus: 'Destination reached.'));
    _eventCompleted(emit);
  }

  _togglePipelineDevice(TogglePipelineDeviceEvent event, emit) {
    isPipelineDeviceCheck = !isPipelineDeviceCheck;
    _setLayerVisibility("200", isPipelineDeviceCheck);
    _eventCompleted(emit);
  }

  _toggleStructure(ToggleStructureEvent event, emit) {
    isStructureCheck = !isStructureCheck;
    _setLayerVisibility("8", isStructureCheck);
    _eventCompleted(emit);
  }

  _togglePipeline(TogglePipelineEvent event, emit) {
    isPipelineCheck = !isPipelineCheck;
    _setLayerVisibility("210052", isPipelineCheck);
    _eventCompleted(emit);
  }

  _toggleContinuous(ToggleContinuousEvent event, emit) {
    isContinuousCheck = !isContinuousCheck;
    _setLayerVisibility("900017", isContinuousCheck);
    _eventCompleted(emit);
  }

  _toggleEngineering(ToggleEngineeringEvent event, emit) {
    isEngineeringCheck = !isEngineeringCheck;
    _setLayerVisibility("910", isEngineeringCheck);
    _eventCompleted(emit);
  }

  _toggleStructureBoundary(ToggleStructureBoundaryEvent event, emit) {
    isStructureBoundaryCheck = !isStructureBoundaryCheck;
    _setLayerVisibility("910", isStructureBoundaryCheck);
    _eventCompleted(emit);
  }

  _toggleService(ToggleServiceEvent event, emit) {
    isServiceCheck = !isServiceCheck;
    _setLayerVisibility("920", isServiceCheck);
    _eventCompleted(emit);
  }

  Future<void> _toggleCadastral(ToggleCadastralEvent event, emit,) async {
    isCadastralCheck = !isCadastralCheck;
    if (isCadastralCheck) {
      await _addCadastralLayer(event.controller);
    } else {
      _removeCadastralLayer(event.controller);
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<PgisState> emit) {
    emit(
      FetchPgisDataState(
        isPageLoader: isPageLoader,
        isArcGISStreets: isArcGISStreets,
        pipelineCtrl: pipelineCtrl,
        sectionCtrl: sectionCtrl,
        stationCtrl: stationCtrl,
        tlpCtrl: tlpCtrl,
        isContinuousCheck: isContinuousCheck,
        isEngineeringCheck: isEngineeringCheck,
        isPipelineCheck: isPipelineCheck,
        isServiceCheck: isServiceCheck,
        isStructureCheck: isStructureCheck,
        isStructureBoundaryCheck: isStructureBoundaryCheck,
        isPipelineDeviceCheck: isPipelineDeviceCheck,
        isCadastralCheck: isCadastralCheck,
        stationList: stationList,
      ),
    );
  }

}
