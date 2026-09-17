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
    await requestLocationPermissions();
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

  // ==========================================================
  // LOCATION EVENT
  // ==========================================================

  Future<void> _location(
      LocationEvent event,
      Emitter<PgisState> emit,
      ) async {
    final controller = event.controller;

    controller.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.recenter;

    _eventCompleted(emit);
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  Future<void> _searchRounded(
      SearchRoundedEvent event,
      Emitter<PgisState> emit,
      ) async {
    showDialog(
      context: event.ctx,
      builder: (BuildContext context) {
        return FilterWidget(
          mapViewController: event.arcGISMapViewController,
        );
      },
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // MAP LAYER
  // ==========================================================

  _mapLayer(
      MapLayerEvent event,
      Emitter<PgisState> emit,
      ) {
    showDialog(
      context: event.ctx,
      builder: (BuildContext context) {
        return MapLayerWidget(
          controller: event.controller,
        );
      },
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // IDENTIFY FEATURES
  // ==========================================================

  Future<void> _onIdentifyFeatures(
      IdentifyFeaturesAtTapEvent event,
      Emitter<PgisState> emit,
      ) async {
    PGISHelper.showLoaderDialog(event.context);

    _eventCompleted(emit);

    final attributeJsonList = <Map<String, dynamic>>[];

    try {
      // ------------------------------------------------------
      // Identify features
      // ------------------------------------------------------

      for (final featureLayer in featureLayerList) {
        featureLayer.clearSelection();

        final identifyLayerResult =
        await event.controller.identifyLayer(
          featureLayer,
          screenPoint: event.offset,
          tolerance: 22,
          maximumResults: 1000,
        );

        final features = identifyLayerResult.geoElements
            .whereType<Feature>()
            .toList();

        if (features.isNotEmpty) {
          for (final feature in features) {
            final table = feature.featureTable;

            for (final entry in feature.attributes.entries) {
              final fieldName = entry.key;
              final value = entry.value;

              String displayName = fieldName;
              String? fieldType;

              if (table != null) {
                final field = table.fields
                    .where(
                      (f) => f.name == fieldName,
                )
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
          final selectedResult =
          await featureLayer.getSelectedFeatures();

          final selectedFeatures =
          selectedResult.features();

          for (final feature in selectedFeatures) {
            featureLayer.unselectFeature(feature);
          }
        }
      }

      // ------------------------------------------------------
      // Close loader
      // ------------------------------------------------------

      if (event.context.mounted) {
        Navigator.pop(event.context);
      }

      // ------------------------------------------------------
      // Show feature information
      // ------------------------------------------------------

      if (attributeJsonList.isNotEmpty) {
        showAttributeDialog(
          destination: event.offset,
          controller: event.controller,
          context: event.context,
          attributeJsonList: attributeJsonList,
        );
      }

      // ------------------------------------------------------
      // Get clicked map point
      // ------------------------------------------------------

      final mapPoint = event.controller.screenToLocation(
        screen: event.offset,
      );

      if (mapPoint == null || mapPoint.isEmpty) {
        debugPrint(
          '❌ Unable to convert screen point to map location',
        );

        _eventCompleted(emit);
        return;
      }

      debugPrint(
        '📍 CLICKED MAP POINT: '
            'x=${mapPoint.x}, '
            'y=${mapPoint.y}, '
            'wkid=${mapPoint.spatialReference?.wkid}',
      );

      // ------------------------------------------------------
      // Convert destination to WGS84
      // ------------------------------------------------------

      desPoint = PGISHelper.toWgs84(mapPoint);

      debugPrint(
        '🌍 DESTINATION WGS84: '
            'lat=${desPoint.y}, '
            'lng=${desPoint.x}, '
            'wkid=${desPoint.spatialReference?.wkid}',
      );

      // ------------------------------------------------------
      // Validate destination
      // ------------------------------------------------------

      if (!_isValidRoutePoint(desPoint)) {
        debugPrint(
          '❌ Invalid destination point: '
              'x=${desPoint.x}, '
              'y=${desPoint.y}',
        );

        _eventCompleted(emit);
        return;
      }

      // ------------------------------------------------------
      // Clear previous route graphics
      // ------------------------------------------------------

      _graphicsOverlay.graphics.clear();

      // Current location marker
      if (_isValidRoutePoint(curPoint)) {
        PGISHelper.drawPoint(
          point: curPoint,
          color: Colors.green,
          graphicsOverlay: _graphicsOverlay,
        );
      }

      // Destination marker
      PGISHelper.drawPoint(
        point: desPoint,
        color: Colors.red,
        graphicsOverlay: _graphicsOverlay,
      );

      // ------------------------------------------------------
      // Solve route
      // ------------------------------------------------------

      await _solveRoute(
        controller: event.controller,
      );

      // ------------------------------------------------------
      // Draw destination buffer
      // ------------------------------------------------------

      final bufferGeometry = await PGISHelper.drawBuffer(
        point: desPoint,
        distanceMeters: 1000,
        mapController: event.controller,
        graphicsOverlay: bufferOverlay,
      );

      debugPrint(
        '📍 Destination Location: '
            '${desPoint.x}, ${desPoint.y}',
      );

      // ------------------------------------------------------
      // Structure query
      // ------------------------------------------------------

      final stations = await PGISHelper.structureBoundaryQuery(
        context: event.context,
        query: '',
        spatialReference:
        desPoint.spatialReference!,
        bufferGeometry: bufferGeometry,
      );

      if (stations.isNotEmpty) {
        stationList = stations;
        _eventCompleted(emit);
      }

      // ------------------------------------------------------
      // Destination marker
      // ------------------------------------------------------

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

      // ------------------------------------------------------
      // Station markers
      // ------------------------------------------------------

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

      // ------------------------------------------------------
      // Move map
      // ------------------------------------------------------

      await event.controller.setViewpointCenter(
        desPoint,
        scale: 25000,
      );
    } catch (e, stackTrace) {
      if (event.context.mounted) {
        Navigator.of(event.context).maybePop();
      }

      debugPrint(
        '❌ Identify feature error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // ROUTE POINT VALIDATION
  // ==========================================================

  bool _isValidRoutePoint(ArcGISPoint? point) {
    if (point == null || point.isEmpty) {
      return false;
    }

    final x = point.x;
    final y = point.y;

    if (x.isNaN || x.isInfinite) {
      return false;
    }

    if (y.isNaN || y.isInfinite) {
      return false;
    }

    // WGS84:
    // x = longitude
    // y = latitude

    if (x < -180 || x > 180) {
      return false;
    }

    if (y < -90 || y > 90) {
      return false;
    }

    // Reject 0,0
    if (x == 0 && y == 0) {
      return false;
    }

    return true;
  }

  // ==========================================================
  // SOLVE ROUTE
  // ==========================================================

  Future<void> _solveRoute({
    required ArcGISMapViewController controller,
  }) async {
    try {
      // ------------------------------------------------------
      // Validate current location
      // ------------------------------------------------------

      if (!_isValidRoutePoint(curPoint)) {
        debugPrint(
          '❌ Invalid current location: '
              'x=${curPoint.x}, '
              'y=${curPoint.y}',
        );

        return;
      }

      // ------------------------------------------------------
      // Validate destination
      // ------------------------------------------------------

      if (!_isValidRoutePoint(desPoint)) {
        debugPrint(
          '❌ Invalid destination location: '
              'x=${desPoint.x}, '
              'y=${desPoint.y}',
        );

        return;
      }

      debugPrint(
        '📍 CURRENT POINT: '
            'lat=${curPoint.y}, '
            'lng=${curPoint.x}, '
            'wkid=${curPoint.spatialReference?.wkid}',
      );

      debugPrint(
        '📍 DESTINATION POINT: '
            'lat=${desPoint.y}, '
            'lng=${desPoint.x}, '
            'wkid=${desPoint.spatialReference?.wkid}',
      );

      // ------------------------------------------------------
      // Convert start point to WGS84
      // ------------------------------------------------------

      final startWgs84 = PGISHelper.toWgs84(
        curPoint,
      );

      // ------------------------------------------------------
      // Convert destination to WGS84
      // ------------------------------------------------------

      final destinationWgs84 = PGISHelper.toWgs84(
        desPoint,
      );

      debugPrint(
        '🌍 START WGS84: '
            'lat=${startWgs84.y}, '
            'lng=${startWgs84.x}, '
            'wkid=${startWgs84.spatialReference?.wkid}',
      );

      debugPrint(
        '🌍 DESTINATION WGS84: '
            'lat=${destinationWgs84.y}, '
            'lng=${destinationWgs84.x}, '
            'wkid=${destinationWgs84.spatialReference?.wkid}',
      );

      // ------------------------------------------------------
      // Validate converted start
      // ------------------------------------------------------

      if (!_isValidRoutePoint(startWgs84)) {
        debugPrint(
          '❌ Start WGS84 point is invalid',
        );

        return;
      }

      // ------------------------------------------------------
      // Validate converted destination
      // ------------------------------------------------------

      if (!_isValidRoutePoint(destinationWgs84)) {
        debugPrint(
          '❌ Destination WGS84 point is invalid',
        );

        return;
      }

      // ------------------------------------------------------
      // Route task
      // ------------------------------------------------------

      debugPrint(
        '🛣️ ROUTE SERVICE: ${APIs.routeARCGIS}',
      );

      // ------------------------------------------------------
      // Create route parameters
      // ------------------------------------------------------

      final params =
      await _routeTask.createDefaultParameters();

      // ------------------------------------------------------
      // Create stops
      // ------------------------------------------------------

      final startStop = Stop(
        startWgs84,
      );

      final destinationStop = Stop(
        destinationWgs84,
      );

      // ------------------------------------------------------
      // Add stops
      // ------------------------------------------------------

      params.setStops([
        startStop,
        destinationStop,
      ]);

      params.returnRoutes = true;
      params.returnDirections = true;
      params.outputSpatialReference =
          SpatialReference.wgs84;

      debugPrint(
        '🚗 ROUTE STOPS CREATED',
      );

      debugPrint(
        '🟢 STOP 1: '
            'lat=${startWgs84.y}, '
            'lng=${startWgs84.x}',
      );

      debugPrint(
        '🔴 STOP 2: '
            'lat=${destinationWgs84.y}, '
            'lng=${destinationWgs84.x}',
      );

      // ------------------------------------------------------
      // Solve
      // ------------------------------------------------------

      debugPrint(
        '🚗 Solving ArcGIS route...',
      );

      final result =
      await _routeTask.solveRoute(params);

      routeResult = result;

      // ------------------------------------------------------
      // Check result
      // ------------------------------------------------------

      if (result.routes.isEmpty) {
        debugPrint(
          '❌ ArcGIS returned no routes',
        );

        return;
      }

      final route = result.routes.first;

      // ------------------------------------------------------
      // Distance
      // ------------------------------------------------------

      distanceKm =
          route.totalLength / 1000;

      // ------------------------------------------------------
      // Travel time
      // ------------------------------------------------------

      travelTimeMin =
          route.travelTime;

      debugPrint(
        '✅ ROUTE FOUND',
      );

      debugPrint(
        '📏 Distance: '
            '${distanceKm.toStringAsFixed(2)} KM',
      );

      debugPrint(
        '⏱ Travel Time: '
            '${travelTimeMin.toStringAsFixed(2)} minutes',
      );

      // ------------------------------------------------------
      // Route geometry
      // ------------------------------------------------------

      final routeGeometry =
          route.routeGeometry;

      if (routeGeometry == null ||
          routeGeometry.isEmpty) {
        debugPrint(
          '❌ Route geometry is empty',
        );

        return;
      }

      // ------------------------------------------------------
      // Draw route
      // ------------------------------------------------------

      _drawRoute(
        geometry: routeGeometry,
        controller: controller,
      );
    } on ArcGISException catch (
    e, stackTrace) {
    debugPrint(
    '❌ ArcGIS Route Exception: $e',
    );

    debugPrintStack(
    stackTrace: stackTrace,
    );
    } catch (e, stackTrace) {
    debugPrint('❌ Route Exception: $e',
    );

    debugPrintStack(
    stackTrace: stackTrace,
    );
    }
  }

  // ==========================================================
  // DRAW ROUTE
  // ==========================================================

  void _drawRoute({
    required Geometry geometry,
    required ArcGISMapViewController controller,
  }) {
    try {
      final routeGraphic = Graphic(
        geometry: geometry,
        symbol: SimpleLineSymbol(
          style: SimpleLineSymbolStyle.solid,
          color: Colors.blue,
          width: 4,
        ),
      );

      _graphicsOverlay.graphics.add(
        routeGraphic,
      );

      controller.setViewpoint(
        Viewpoint.fromTargetExtent(
          geometry,
        ),
      );
    } catch (e) {
      debugPrint(
        '❌ Draw route error: $e',
      );
    }
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Do you want to navigate?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColor.themeColor,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final mapPoint =
                    controller.screenToLocation(
                      screen: Offset(
                        destination.dx,
                        destination.dy,
                      ),
                    );

                    if (mapPoint != null &&
                        !mapPoint.isEmpty) {
                      Navigator.of(context).pop();

                      context
                          .read<PgisBloc>()
                          .add(
                        StartNavigationEvent(
                          controller:
                          controller,
                          destination:
                          mapPoint,
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
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // START NAVIGATION
  // ==========================================================

  Future<void> _onStartNavigation(
      StartNavigationEvent event,
      Emitter<PgisState> emit,
      ) async {
    try {
      final controller =
          event.controller;

      final locationDisplay =
          controller.locationDisplay;

      if (!locationDisplay.started) {
        locationDisplay.start();
      }

      final location =
          locationDisplay.location;

      if (location == null ||
          location.position.isEmpty) {
        debugPrint(
          '❌ Location fix not yet available',
        );

        return;
      }

      // ------------------------------------------------------
      // Current location WGS84
      // ------------------------------------------------------

      final currentWgs84 =
      PGISHelper.toWgs84(
        location.position,
      );

      // ------------------------------------------------------
      // Destination WGS84
      // ------------------------------------------------------

      final destinationWgs84 =
      PGISHelper.toWgs84(
        event.destination,
      );

      // ------------------------------------------------------
      // Validate
      // ------------------------------------------------------

      if (!_isValidRoutePoint(
        currentWgs84,
      )) {
        debugPrint(
          '❌ Invalid current navigation location',
        );

        return;
      }

      if (!_isValidRoutePoint(
        destinationWgs84,
      )) {
        debugPrint(
          '❌ Invalid destination navigation location',
        );

        return;
      }

      curPoint = currentWgs84;
      desPoint = destinationWgs84;

      debugPrint(
        '🧭 NAVIGATION',
      );

      debugPrint(
        'FROM: '
            'lat=${currentWgs84.y}, '
            'lng=${currentWgs84.x}',
      );

      debugPrint(
        'TO: '
            'lat=${destinationWgs84.y}, '
            'lng=${destinationWgs84.x}',
      );

      // ------------------------------------------------------
      // Open Google Maps
      // ------------------------------------------------------

      await PGISHelper.openGoogleMapsNavigation(
        sourceLat: currentWgs84.y,
        sourceLng: currentWgs84.x,
        destLat: destinationWgs84.y,
        destLng: destinationWgs84.x,
      );

      _eventCompleted(emit);
    } catch (
    e,
    stackTrace
    ) {
      debugPrint(
        '❌ Navigation error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================================
  // ENABLE LOCATION
  // ==========================================================

  Future<void> _enableUserLocation(
      ArcGISMapViewController controller,
      ) async {
    controller.locationDisplay.dataSource =
        locationDataSource;

    await locationDataSource.start();
  }

  // ==========================================================
  // MAP READY
  // ==========================================================

  Future<void> _onMapReady(
      PGISMapReady event,
      Emitter<PgisState> emit,
      ) async {
    try {
      final controller =
          event.controller;

      arcGISMapType =
          ArcGISMap.withBasemapStyle(
            BasemapStyle.arcGISStreets,
          );

      controller.arcGISMap =
          arcGISMapType;

      // ------------------------------------------------------
      // Graphics overlay
      // ------------------------------------------------------

      controller.graphicsOverlays.add(
        _graphicsOverlay,
      );

      // ------------------------------------------------------
      // Route task
      // ------------------------------------------------------

      final routeUri =
      Uri.parse(APIs.routeARCGIS);

      debugPrint(
        '🛣️ ROUTE SERVICE: $routeUri',
      );

      _routeTask =
          RouteTask.withUri(
            routeUri,
          );

      // ------------------------------------------------------
      // Location
      // ------------------------------------------------------

      await _enableUserLocation(
        controller,
      );

      // ------------------------------------------------------
      // Get current location
      // ------------------------------------------------------

      try {
        final currentPoint =
        await PGISHelper.startCurrentLocation();

        final currentWgs84 =
        PGISHelper.toWgs84(
          currentPoint,
        );

        debugPrint(
          '📍 CURRENT LOCATION WGS84: '
              'lat=${currentWgs84.y}, '
              'lng=${currentWgs84.x}, '
              'wkid=${currentWgs84.spatialReference?.wkid}',
        );

        if (_isValidRoutePoint(
          currentWgs84,
        )) {
          curPoint =
              currentWgs84;
        } else {
          debugPrint(
            '❌ Current location is invalid',
          );
        }
      } catch (
      e,
      stackTrace
      ) {
        debugPrint(
          '❌ Current location error: $e',
        );

        debugPrintStack(
          stackTrace: stackTrace,
        );
      }

      // ------------------------------------------------------
      // India envelope
      // ------------------------------------------------------

      await controller.setViewpointGeometry(
        indiaEnvelope,
        paddingInDiPs: 50,
      );

      // ------------------------------------------------------
      // Buffer overlay
      // ------------------------------------------------------

      bufferOverlay =
          GraphicsOverlay();

      event.controller.graphicsOverlays.add(
        bufferOverlay,
      );

      // ------------------------------------------------------
      // Pipeline
      // ------------------------------------------------------

      await _addPipelineLayer(
        controller,
      );
    } catch (
    e,
    stackTrace
    ) {
      debugPrint(
        '❌ Map ready error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // PIPELINE LAYER
  // ==========================================================

  ServiceFeatureTable? _pipelineTable;

  final Map<String, ServiceFeatureTable>
  sublayerTables = {};

  Future<void> _addPipelineLayer(
      ArcGISMapViewController controller,
      ) async {
    try {
      final uri = Uri.parse(
        APIs.baseGailUrl +
            APIs.pipelineLayerUrl,
      );

      final pipelineLayer =
      ArcGISMapImageLayer.withUri(
        uri,
      );

      await pipelineLayer.load();

      controller.arcGISMap?.operationalLayers
          .add(
        pipelineLayer,
      );

      for (final content
      in pipelineLayer.subLayerContents) {
        if (content
        is ArcGISMapImageSublayer) {
          await content.load();

          final id =
          content.id.toString();

          layerMap[id] =
              content;

          final sublayerUri =
              content.table?.uri;

          if (sublayerUri != null) {
            final table =
            ServiceFeatureTable.withUri(
              sublayerUri,
            );

            final featureLayer =
            FeatureLayer.withFeatureTable(
              table,
            );

            await featureLayer.load();

            featureLayerList.add(
              featureLayer,
            );

            sublayerTables[id] =
                table;

            if (id == '8') {
              _pipelineTable =
                  table;

              if (kDebugMode) {
                print(
                  "_pipelineTable "
                      "$_pipelineTable",
                );
              }
            }

            log(
              'Sublayer $id ready → '
                  '$sublayerUri',
            );
          }
        }
      }
    } catch (
    e,
    stackTrace
    ) {
      log(
        '❌ Pipeline layer error',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================================
  // CADASTRAL LAYER
  // ==========================================================

  Future<void> _addCadastralLayer(
      ArcGISMapViewController controller,
      ) async {
    if (_cadastralMapImageLayer != null) {
      return;
    }

    try {
      final urlString =
          APIs.baseGailUrl +
              APIs.cadastralLayerUrl;

      final uri =
      Uri.parse(urlString);

      log(
        "Cadastral URL ---> $uri",
      );

      final mapImageLayer =
      ArcGISMapImageLayer.withUri(
        uri,
      );

      await mapImageLayer.load();

      controller.arcGISMap!
          .operationalLayers
          .add(
        mapImageLayer,
      );

      _cadastralMapImageLayer =
          mapImageLayer;

      for (final content
      in mapImageLayer.subLayerContents) {
        if (content
        is ArcGISMapImageSublayer) {
          await content.load();

          final sublayerUri =
              content.table?.uri;

          if (sublayerUri == null) {
            continue;
          }

          final serviceFeatureTable =
          ServiceFeatureTable.withUri(
            sublayerUri,
          );

          final featureLayer =
          FeatureLayer.withFeatureTable(
            serviceFeatureTable,
          );

          await featureLayer.load();

          _cadastralFeatureLayers.add(
            featureLayer,
          );
        }
      }

      final viewpoint =
      await controller
          .getCurrentViewpoint(
        ViewpointType.centerAndScale,
      );

      if (viewpoint != null) {
        controller.setViewpoint(
          viewpoint,
        );
      }

      controller.arcGISMap!
          .operationalLayers
          .addAll(
        _cadastralFeatureLayers,
      );
    } catch (
    e,
    stackTrace
    ) {
      log(
        '❌ Error loading cadastral layer',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================================
  // REMOVE CADASTRAL
  // ==========================================================

  void _removeCadastralLayer(
      ArcGISMapViewController controller,
      ) {
    if (_cadastralMapImageLayer ==
        null) {
      return;
    }

    for (final layer
    in _cadastralFeatureLayers) {
      controller.arcGISMap!
          .operationalLayers
          .remove(layer);
    }

    controller.arcGISMap!
        .operationalLayers
        .remove(
      _cadastralMapImageLayer,
    );

    _cadastralFeatureLayers.clear();

    _cadastralMapImageLayer =
    null;
  }

  // ==========================================================
  // ENGINEERING ROUTE
  // ==========================================================

  _selectEngRoute(
      SelectPipelineEngRouteEvent event,
      Emitter<PgisState> emit,
      ) async {
    try {
      final polylineBuilder =
      PolylineBuilder(
        spatialReference:
        SpatialReference.wgs84,
      );

      final res =
      await PGISHelper.zoomToPipeLine(
        context: event.context,
        query: event.query,
      );

      if (res != null) {
        for (final point in res) {
          polylineBuilder.addPoint(
            ArcGISPoint(
              x: point[0],
              y: point[1],
              spatialReference:
              SpatialReference.wgs84,
            ),
          );
        }

        final polyline =
        polylineBuilder.toGeometry();

        final graphic = Graphic(
          geometry: polyline,
          symbol: SimpleLineSymbol(
            color: Colors.red,
            width: 3,
            style:
            SimpleLineSymbolStyle.solid,
          ),
        );

        _pipelineOverlay.graphics
            .add(graphic);

        event.controller
            .graphicsOverlays
            .clear();

        event.controller
            .graphicsOverlays
            .add(
          _pipelineOverlay,
        );

        await event.controller
            .setViewpointGeometry(
          polyline,
          paddingInDiPs: 100,
        );
      }
    } catch (e) {
      debugPrint(
        '❌ Select engineering route error: $e',
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // SELECT STATION
  // ==========================================================

  _selectStation(
      SelectStationEvent event,
      Emitter<PgisState> emit,
      ) async {
    try {
      final polylineBuilder =
      PolylineBuilder(
        spatialReference:
        SpatialReference.wgs84,
      );

      final res =
      await PGISHelper.zoomToStation(
        context: event.context,
        query: event.query,
      );

      if (res != null) {
        final points =
        res['points'];

        if (kDebugMode) {
          print(
            "Points --> $points",
          );
        }

        if (points != null &&
            points is List) {
          for (final point in points) {
            polylineBuilder.addPoint(
              ArcGISPoint(
                x: point[0],
                y: point[1],
                spatialReference:
                SpatialReference.wgs84,
              ),
            );
          }

          final polygon =
          polylineBuilder
              .toGeometry();

          final fillSymbol =
          SimpleFillSymbol(
            style:
            SimpleFillSymbolStyle.solid,
            color: Colors.red.withValues(
              red: 0.3,
              green: 0.3,
            ),
            outline:
            SimpleLineSymbol(
              color: Colors.red,
              width: 2,
              style:
              SimpleLineSymbolStyle
                  .solid,
            ),
          );

          final graphic = Graphic(
            geometry: polygon,
            symbol: fillSymbol,
          );

          _stationOverlay
              .graphics
              .clear();

          _stationOverlay
              .graphics
              .add(
            graphic,
          );

          await event.controller
              .setViewpointGeometry(
            polygon,
            paddingInDiPs: 100,
          );
        }
      }
    } catch (e) {
      debugPrint(
        '❌ Select station error: $e',
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // SELECT TLP
  // ==========================================================

  _selectTLP(
      SelectTLPEvent event,
      Emitter<PgisState> emit,
      ) async {
    try {
      final res =
      await PGISHelper.zoomToTLP(
        context: event.context,
        query: event.query,
      );

      if (res != null &&
          res['geometryType'] ==
              'point' &&
          res['attributes'] != null) {
        final double x =
        res['x'];

        final double y =
        res['y'];

        final attributes =
            res['attributes'] ?? {};

        final point = ArcGISPoint(
          x: x,
          y: y,
          spatialReference:
          SpatialReference.wgs84,
        );

        final markerSymbol =
        SimpleMarkerSymbol(
          style:
          SimpleMarkerSymbolStyle
              .circle,
          color: Colors.red,
          size: 12,
        );

        final graphic = Graphic(
          geometry: point,
          symbol: markerSymbol,
        );

        _tlpOverlay.graphics.add(
          graphic,
        );

        event.controller
            .graphicsOverlays
            .add(
          _tlpOverlay,
        );

        await event.controller
            .setViewpointCenter(
          point,
          scale: 5000,
        );

        if (event.context.mounted) {
          showModalBottomSheet(
            context: event.context,
            builder: (_) => Padding(
              padding:
              const EdgeInsets.all(
                16,
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    "TLP No: "
                        "${attributes['tlpno'] ?? ''}",
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  Text(
                    "TLP Type: "
                        "${attributes['TLPType'] ?? ''}",
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        debugPrint(
          "❌ No point geometry "
              "returned for TLP",
        );
      }
    } catch (e) {
      debugPrint(
        '❌ Select TLP error: $e',
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // RESET PIPELINE
  // ==========================================================

  _resetPipeline(
      ResetPipelineEvent event,
      Emitter<PgisState> emit,
      ) async {
    _pipelineOverlay.graphics.clear();

    event.controller
        .graphicsOverlays
        .remove(
      _pipelineOverlay,
    );

    pipelineCtrl.clear();
    sectionCtrl.clear();
    tlpCtrl.clear();

    await event.controller
        .setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // RESET STATION
  // ==========================================================

  _resetStation(
      ResetStationEvent event,
      Emitter<PgisState> emit,
      ) async {
    _stationOverlay.graphics.clear();

    event.controller
        .graphicsOverlays
        .remove(
      _stationOverlay,
    );

    sectionCtrl.clear();

    await event.controller
        .setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // RESET TLP
  // ==========================================================

  _resetTLP(
      ResetTLPEvent event,
      Emitter<PgisState> emit,
      ) async {
    _tlpOverlay.graphics.clear();

    event.controller
        .graphicsOverlays
        .remove(
      _tlpOverlay,
    );

    tlpCtrl.clear();

    await event.controller
        .setViewpointGeometry(
      indiaEnvelope,
      paddingInDiPs: 50,
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // STOP NAVIGATION
  // ==========================================================

  _onStopNavigation(
      StopNavigationEvent event,
      Emitter<PgisState> emit,
      ) async {
    final mapController =
        event.controller;

    mapController.locationDisplay
        .autoPanMode =
        LocationDisplayAutoPanMode.off;

    _eventCompleted(emit);
  }

  // ==========================================================
  // TOGGLES
  // ==========================================================

  _togglePipelineDevice(
      TogglePipelineDeviceEvent event,
      Emitter<PgisState> emit,
      ) {
    isPipelineDeviceCheck =
    !isPipelineDeviceCheck;

    _setLayerVisibility(
      "200",
      isPipelineDeviceCheck,
    );

    _eventCompleted(emit);
  }

  _toggleStructure(
      ToggleStructureEvent event,
      Emitter<PgisState> emit,
      ) {
    isStructureCheck =
    !isStructureCheck;

    _setLayerVisibility(
      "8",
      isStructureCheck,
    );

    _eventCompleted(emit);
  }

  _togglePipeline(
      TogglePipelineEvent event,
      Emitter<PgisState> emit,
      ) {
    isPipelineCheck =
    !isPipelineCheck;

    _setLayerVisibility(
      "210052",
      isPipelineCheck,
    );

    _eventCompleted(emit);
  }

  _toggleContinuous(
      ToggleContinuousEvent event,
      Emitter<PgisState> emit,
      ) {
    isContinuousCheck =
    !isContinuousCheck;

    _setLayerVisibility(
      "900017",
      isContinuousCheck,
    );

    _eventCompleted(emit);
  }

  _toggleEngineering(
      ToggleEngineeringEvent event,
      Emitter<PgisState> emit,
      ) {
    isEngineeringCheck =
    !isEngineeringCheck;

    _setLayerVisibility(
      "910",
      isEngineeringCheck,
    );

    _eventCompleted(emit);
  }

  _toggleStructureBoundary(
      ToggleStructureBoundaryEvent event,
      Emitter<PgisState> emit,
      ) {
    isStructureBoundaryCheck =
    !isStructureBoundaryCheck;

    _setLayerVisibility(
      "910",
      isStructureBoundaryCheck,
    );

    _eventCompleted(emit);
  }

  _toggleService(
      ToggleServiceEvent event,
      Emitter<PgisState> emit,
      ) {
    isServiceCheck =
    !isServiceCheck;

    _setLayerVisibility(
      "920",
      isServiceCheck,
    );

    _eventCompleted(emit);
  }

  // ==========================================================
  // CADASTRAL TOGGLE
  // ==========================================================

  Future<void> _toggleCadastral(
      ToggleCadastralEvent event,
      Emitter<PgisState> emit,
      ) async {
    isCadastralCheck =
    !isCadastralCheck;

    if (isCadastralCheck) {
      await _addCadastralLayer(
        event.controller,
      );
    } else {
      _removeCadastralLayer(
        event.controller,
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // CHANGE BASEMAP
  // ==========================================================

  Future<void> _onChangeBasemap(
      ChangeBasemapEvent event,
      Emitter<PgisState> emit,
      ) async {
    final controller =
        event.controller;

    final viewpoint =
    await controller
        .getCurrentViewpoint(
      ViewpointType.centerAndScale,
    );

    controller.arcGISMap?.basemap =
        Basemap.withStyle(
          event.basemapStyle,
        );

    if (viewpoint != null) {
      controller.setViewpoint(
        viewpoint,
      );
    }

    _eventCompleted(emit);
  }

  // ==========================================================
  // LAYER VISIBILITY
  // ==========================================================

  void _setLayerVisibility(
      String key,
      bool visible,
      ) {
    final layer =
    layerMap[key];

    if (layer != null) {
      layer.isVisible =
          visible;

      if (kDebugMode) {
        print(
          "🔄 Layer [$key] visibility "
              "→ $visible",
        );
      }
    } else {
      if (kDebugMode) {
        print(
          "❌ Layer ID $key not found!",
        );
      }
    }
  }

  // ==========================================================
  // STATE
  // ==========================================================

  void _eventCompleted(
      Emitter<PgisState> emit,
      ) {
    emit(
      FetchPgisDataState(
        isPageLoader:
        isPageLoader,
        isArcGISStreets:
        isArcGISStreets,
        pipelineCtrl:
        pipelineCtrl,
        sectionCtrl:
        sectionCtrl,
        stationCtrl:
        stationCtrl,
        tlpCtrl:
        tlpCtrl,
        isContinuousCheck:
        isContinuousCheck,
        isEngineeringCheck:
        isEngineeringCheck,
        isPipelineCheck:
        isPipelineCheck,
        isServiceCheck:
        isServiceCheck,
        isStructureCheck:
        isStructureCheck,
        isStructureBoundaryCheck:
        isStructureBoundaryCheck,
        isPipelineDeviceCheck:
        isPipelineDeviceCheck,
        isCadastralCheck:
        isCadastralCheck,
        stationList:
        stationList,
        curPoint:
        curPoint,
        desPoint:
        desPoint,
        distanceKm:
        distanceKm,
        travelTimeMin:
        travelTimeMin,
      ),
    );
  }
}