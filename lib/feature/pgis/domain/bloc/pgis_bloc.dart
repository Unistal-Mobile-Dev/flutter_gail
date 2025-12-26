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


  late ArcGISMap arcGISMapType;
  final Envelope indiaEnvelope = Envelope.fromXY(
    xMin: 68,
    yMin: 6,
    xMax: 98,
    yMax: 36,
    spatialReference: SpatialReference.wgs84,
  );

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

  final locationDataSource = SystemLocationDataSource();


  final GraphicsOverlay _graphicsOverlay = GraphicsOverlay();

  late RouteTask _routeTask;
  double distanceKm = 0.0;
  double travelTimeMin = 0.0;


  ArcGISPoint curPoint = PGISHelper.createPoint(lat: 0.0,lon:0.0);
  ArcGISPoint desPoint = PGISHelper.createPoint(lat: 0.0,lon:0.0);

  List<StructureBoundaryFeature> stationList = [];
  final List<FeatureLayer> featureLayerList = [];
  final Map<String, ArcGISMapImageSublayer> layerMap = {};
  ArcGISMapImageLayer? _cadastralMapImageLayer;
  final List<FeatureLayer> _cadastralFeatureLayers = [];

  GraphicsOverlay _pipelineOverlay = GraphicsOverlay();
  GraphicsOverlay _stationOverlay = GraphicsOverlay();
  GraphicsOverlay _tlpOverlay = GraphicsOverlay();
  GraphicsOverlay bufferOverlay = GraphicsOverlay();

  RouteTask? routeTask;
  RouteResult? routeResult;
  RouteTracker? routeTracker;

  PgisBloc() : super(PgisInitial()) {
    on<PgisPageLoadedEvent>(_pageLoad);
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
    on<ChangeBasemapEvent>(_onChangeBasemap);
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
    curPoint = PGISHelper.createPoint(lat: 0.0,lon:0.0);
    desPoint = PGISHelper.createPoint(lat: 0.0,lon:0.0);
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

  Future<void> _onIdentifyFeatures(
    IdentifyFeaturesAtTapEvent event,
    emit,
  ) async {
    PGISHelper.showLoaderDialog(event.context);
    _eventCompleted(emit);
    final attributeJsonList = <Map<String, dynamic>>[];

    //  try {
    for (final featureLayer in featureLayerList) {
      featureLayer.clearSelection();

      final identifyLayerResult = await event.controller.identifyLayer(
        featureLayer,
        screenPoint: event.offset,
        tolerance: 22,
        maximumResults: 1000,
      );

      final features =
          identifyLayerResult.geoElements.whereType<Feature>().toList();
      if (features.isNotEmpty) {
        for (final feature in features) {
          final table = feature.featureTable;
          for (final entry in feature.attributes.entries) {
            final fieldName = entry.key;
            final value = entry.value;
            String displayName = fieldName;
            String? fieldType;
            if (table != null) {
              final field =
                  table.fields
                      .where((f) => f.name == fieldName)
                      .cast<Field?>()
                      .firstOrNull;

              if (field != null) {
                fieldType = field.type.name;
                displayName = field.alias;
              }
            }
            attributeJsonList.add({
              "field": displayName,
              "value": value ?? "—",
              "type": fieldType ?? "unknown",
            });
          }
        }
      } else {
        final selectedResult = await featureLayer.getSelectedFeatures();
        final selectedFeatures = selectedResult.features();
        for (final feature in selectedFeatures) {
          featureLayer.unselectFeature(feature);
        }
      }
    }
    Navigator.pop(event.context);
    if (attributeJsonList.isNotEmpty) {
      showAttributeDialog(
        destination: event.offset,
        controller: event.controller,
        context: event.context,
        attributeJsonList: attributeJsonList,
      );
    }
    final mapPoint = event.controller.screenToLocation(screen: event.offset);
    desPoint = mapPoint!;
    if (desPoint.isEmpty) return;
    _graphicsOverlay.graphics.clear();

    PGISHelper.drawPoint(point: curPoint,color: Colors.green, graphicsOverlay: _graphicsOverlay);
    PGISHelper.drawPoint(point: desPoint,color: Colors.red,graphicsOverlay: _graphicsOverlay);
    await _solveRoute(controller: event.controller);

    final bufferGeometry = await PGISHelper.drawBuffer(
      point: desPoint,
      distanceMeters: 1000,
      mapController: event.controller,
      graphicsOverlay: bufferOverlay,
    );
    debugPrint('desPoint Location: ${desPoint.x}, ${desPoint.y}');

    final stations = await PGISHelper.structureBoundaryQuery(
      context: event.context,
      query: '',
      spatialReference: desPoint.spatialReference!,
      bufferGeometry: bufferGeometry,
    );

    if (stations.isNotEmpty) {
      stationList = stations;
      _eventCompleted(emit);
    }
   // PGISHelper.drawPoint(point: desPoint,color: Colors.purple, graphicsOverlay: bufferOverlay);
    bufferOverlay.graphics.add(
      Graphic(
        geometry: desPoint,
        symbol: SimpleMarkerSymbol(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.purple,
          size: 15,
        ),
      ),
    );
    final spatialRef = desPoint.spatialReference!;
    final markerSymbol = SimpleMarkerSymbol(
      style: SimpleMarkerSymbolStyle.circle,
      color: Colors.blue,
      size: 8,
    );

// Optional: clear only once if needed
// bufferOverlay.graphics.clear();

    for (final s in stations) {
      final point = ArcGISPoint(
        x: s.geometry.x,
        y: s.geometry.y,
        spatialReference: spatialRef,
      );
      bufferOverlay.graphics.add(
        Graphic(
          geometry: point,
          symbol: markerSymbol,
        ),
      );
    }

    await event.controller.setViewpointCenter(
      desPoint,
      scale: 25000,
    );

    // } catch (e) {
    //   Navigator.pop(event.context);
    //   debugPrint("Identify error: $e");
    // }
    _eventCompleted(emit);
  }

  // ---------------- DRAW POINT ----------------

  // ---------------- SOLVE ROUTE ----------------
  Future<void> _solveRoute({
    required ArcGISMapViewController controller,
  }) async {
    if (curPoint == null || desPoint == null) return;
    final params = await _routeTask.createDefaultParameters();

    params.setStops([Stop(curPoint), Stop(desPoint)]);

    params.returnRoutes = true;
    params.returnDirections = true;
    params.outputSpatialReference = SpatialReference.wgs84;

    final result = await _routeTask.solveRoute(params);
    if (result.routes.isEmpty) return;
    final route = result.routes.first;

    distanceKm = route.totalLength / 1000; // meters → km
    travelTimeMin = route.travelTime; // minutes
    _drawRoute(geometry: route.routeGeometry!, controller: controller);
  }

  // ---------------- DRAW ROUTE ----------------
  void _drawRoute({
    required Geometry geometry,
    required ArcGISMapViewController controller,
  }) {
    final routeGraphic = Graphic(
      geometry: geometry,
      symbol: SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.blue,
        width: 4,
      ),
    );

    _graphicsOverlay.graphics.add(routeGraphic);

    controller.setViewpoint(Viewpoint.fromTargetExtent(geometry));
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
                    final mapPoint = controller.screenToLocation(
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

  Future<void> _onStartNavigation(StartNavigationEvent event, emit) async {
    final controller = event.controller;
    final locationDisplay = controller.locationDisplay;
    if (!locationDisplay.started) {
      locationDisplay.start();
    }
    final location = locationDisplay.location;
    if (location == null || location.position.isEmpty) {
      debugPrint("Location fix not yet available");
      return;
    }

    curPoint = location.position;

    final destWgs84 = PGISHelper.toWgs84(event.destination);

    debugPrint(
      "NAV FROM ${curPoint.y}, ${curPoint.x} TO ${destWgs84.y}, ${destWgs84.x}",
    );

    await PGISHelper.openGoogleMapsNavigation(
      sourceLat: curPoint.y,
      sourceLng: curPoint.x,
      destLat: destWgs84.y,
      destLng: destWgs84.x,
    );

    _eventCompleted(emit);
  }

  Future<void> _enableUserLocation(ArcGISMapViewController controller) async {
    controller.locationDisplay.dataSource = locationDataSource;
    await locationDataSource.start();
  }

  _onMapReady(PGISMapReady event, emit) async {
    final controller = event.controller;
    arcGISMapType = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    controller.arcGISMap = arcGISMapType;

    controller.graphicsOverlays.add(_graphicsOverlay);
    _routeTask = RouteTask.withUri(Uri.parse(APIs.routeARCGIS));

    await _enableUserLocation(controller);
    await _addPipelineLayer(controller);
    // await _addCadastralLayer(controller);

    final ArcGISPoint currentPoint = await PGISHelper.startCurrentLocation();

    debugPrint('Current Location: ${currentPoint.y}, ${currentPoint.x}');
    curPoint = currentPoint;
    await controller.setViewpointGeometry(indiaEnvelope, paddingInDiPs: 50);

    bufferOverlay = GraphicsOverlay();
    event.controller.graphicsOverlays.add(bufferOverlay);
    _eventCompleted(emit);
  }

  ServiceFeatureTable? _pipelineTable;

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

  Future<void> _addCadastralLayer(ArcGISMapViewController controller) async {
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

          final featureLayer = FeatureLayer.withFeatureTable(
            serviceFeatureTable,
          );
          await featureLayer.load();
          _cadastralFeatureLayers.add(featureLayer);
        }
      }

      final viewpoint = await controller.getCurrentViewpoint(ViewpointType.centerAndScale);
      if (viewpoint != null) {
        controller.setViewpoint(viewpoint);
      }
      controller.arcGISMap!.operationalLayers.addAll(_cadastralFeatureLayers);
    } catch (e, s) {
      log('❌ Error loading cadastral layer', error: e, stackTrace: s);
    }
  }

  void _removeCadastralLayer(ArcGISMapViewController controller) {
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

  Future<void> _toggleCadastral(ToggleCadastralEvent event, emit) async {
    isCadastralCheck = !isCadastralCheck;
    if (isCadastralCheck) {
      await _addCadastralLayer(event.controller);
    } else {
      _removeCadastralLayer(event.controller);
    }
    _eventCompleted(emit);
  }

  Future<void> _onChangeBasemap(ChangeBasemapEvent event, emit) async {
    final controller = event.controller;
    final viewpoint = await controller.getCurrentViewpoint(ViewpointType.centerAndScale);

    controller.arcGISMap?.basemap = Basemap.withStyle(event.basemapStyle);
    if (viewpoint != null) {
       controller.setViewpoint(viewpoint);
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
        curPoint: curPoint,
        desPoint: desPoint,
        distanceKm: distanceKm,
        travelTimeMin: travelTimeMin,
      ),
    );
  }
}
