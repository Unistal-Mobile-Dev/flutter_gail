import 'dart:async';
import 'dart:convert';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/helper/pgis_helper.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/filter_widget.dart';
import 'package:flutter_gail/utils/res/enums.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

part 'pgis_event.dart';
part 'pgis_state.dart';

class PgisBloc extends Bloc<PgisEvent, PgisState> {

  bool isPageLoader = false;
  bool isDetailsLoader = false;
  bool isArcGISStreets = false;
  bool isNavigating = false;
  bool isMuted = false;
  late FlutterTts ttsEngine;

  late FlutterTts flutterTts;
  late RouteTask routeTask;
  RouteResult? routeResult;
  RouteTracker? routeTracker;
  ArcGISPoint? destinationPoint;

  StreamSubscription<TrackingStatus>? trackingStatusSub;
  StreamSubscription<VoiceGuidance>? voiceGuidanceSub;

  TextEditingController textEditingController = TextEditingController();

  var locationPermission = AppPermissionStatus.denied;
  final map = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
  final locationDataSource = SystemLocationDataSource();

  //final pipelineLayerUrl = 'https://115.241.54.252/server/rest/services/gail_production/UPIMS15/MapServer';
  final pipelineLayerUrl =
      'https://192.168.40.250/server/rest/services/gail_production/MobApp/MapServer';

  final indiaEnvelope = Envelope.fromXY(
    xMin: 68.0,
    yMin: 6.0,
    xMax: 98.0,
    yMax: 36.0,
    spatialReference: SpatialReference(wkid: 4326),
  );

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List<dynamic> fromLocationList = [];
  List<dynamic> toLocationList = [];
  List<Layer> layer = [];
  List<FeatureLayer> featureLayerList = [];

  PgisBloc() : super(PgisInitial()) {
    on<PgisPageLoadedEvent>(_pageLoad);
    on<SelectMapArcGISStreets>(_selectMapType);
    on<PgisMapReady>(_onMapReady);
    on<IdentifyFeaturesAtTapEvent>(_onIdentifyFeatures);
    on<StartNavigationEvent>(_onStartNavigation);
    on<LocationEvent>(_location);
    on<SearchRoundedEvent>(_searchRounded);
    on<MuteVoiceGuidanceEvent>(_muteVoiceGuidance);
    on<SelectPipelineEngRouteEvent>(_selectEngRoute);
    on<SelectStationEvent>(_selectStation);
    on<SelectTLPEvent>(_selectTLP);
    on<TrackingStatusUpdatedEvent>(_onTrackingStatusUpdated);
    on<StopNavigationEvent>(_onStopNavigation);
    _initTts();
    _initRouteTask();
  }


  Future<void> _initRouteTask() async {
    routeTask = await RouteTask.withUri(
      Uri.parse(
        'https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World',
      ),
    );
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.setPitch(1.3);

    if (!kIsWeb && Platform.isIOS) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }
  }

  _pageLoad(PgisPageLoadedEvent event, emit) async {
    emit(PgisPageLoadingState());
    isPageLoader = false;
    isDetailsLoader = false;
    isArcGISStreets = false;
    isNavigating = false;
    isMuted = false;
    fromController.text = "";
    toController.text = "";
    fromLocationList = [];
    toLocationList = [];
    textEditingController = TextEditingController();
    ttsEngine = FlutterTts()..setSpeechRate(0.5);
    initAudioCategory();
    initFlutterTts(context: event.context);
    requestLocationPermissions();
    _eventCompleted(emit);
  }

  Future<void> initFlutterTts({required BuildContext context}) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(locale);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.setPitch(1.3);
    if (!kIsWeb && Platform.isIOS) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }
  }

  Future<void> initAudioCategory() async {
    await ttsEngine.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    ], IosTextToSpeechAudioMode.voicePrompt);
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

  _selectMapType(SelectMapArcGISStreets event, emit) {
    isArcGISStreets = event.isArcGISStreets;
    _eventCompleted(emit);
  }

  Future<void> _location(LocationEvent event, emit) async {
    final controller = event.controller;
    controller.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.recenter;
    isNavigating
        ? controller.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.navigation
        : controller.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.recenter;
    _eventCompleted(emit);
  }

  TextEditingController pipelineCtrl = TextEditingController();
  TextEditingController sectionCtrl = TextEditingController();
  TextEditingController stationCtrl = TextEditingController();
  TextEditingController tlpCtrl = TextEditingController();

  Future<void> _searchRounded(SearchRoundedEvent event, emit) async {
    showDialog(
      context: event.ctx,
      builder: (BuildContext context) {
        return FilterWidget(mapViewController: event.arcGISMapViewController);
      },
    );

    _eventCompleted(emit);
  }

  Future<void> onSearchSubmitted({
    required String value,
    required ArcGISMapViewController controller,
    required BuildContext context,
  }) async {
    final List<Map<String, dynamic>> attributeJsonList = [];
    try {
      final searchText = value.trim();
      for (final featureLayer in featureLayerList) {
        featureLayer.clearSelection();

        // Query all features (or apply light filtering if needed)
        final queryParameters =
        QueryParameters()
          ..whereClause =
              "1=1"; // Fetch all (or use bounding box for efficiency)

        final queryResult = await featureLayer.featureTable!.queryFeatures(
          queryParameters,
        );
        final features = queryResult.features().toList();

        for (final feature in features) {
          final attributes = feature.attributes;

          // Check if any value matches the search
          final matchFound = attributes.entries.any((entry) {
            final fieldValue = entry.value;
            print("fieldValuefieldValue-->${fieldValue}");
            return fieldValue != null &&
                fieldValue.toString().toLowerCase().contains(
                  searchText.toLowerCase(),
                );
          });

          if (!matchFound) continue;

          featureLayer.selectFeature(feature);
          final table = feature.featureTable;

          for (final entry in attributes.entries) {
            final fieldName = entry.key;
            final fieldValue = entry.value;

            String? fieldType;
            if (table != null) {
              try {
                final field = table.fields.firstWhere(
                      (f) => f.name == fieldName,
                );
                fieldType = field.type.name;
              } catch (_) {
                fieldType = "unknown";
              }
            }

            final isMatched =
                fieldValue != null &&
                    fieldValue.toString().toLowerCase().contains(
                      searchText.toLowerCase(),
                    );
            print("isMatched-isMatched->${isMatched}");
            attributeJsonList.add({
              "field": fieldName,
              "value": fieldValue?.toString() ?? "—",
              "type": fieldType ?? "unknown",
              "matched": isMatched,
            });
          }
          // log("isMatched-------------------------");
          // log(attributeJsonList);
          // Zoom to the feature's geometry
          final geometry = feature.geometry;
          if (geometry != null) {
            if (geometry is Paint) {}

            await controller.setViewpointGeometry(
              geometry.extent,
              paddingInDiPs: 30,
            );
          }
        }
      }

      if (attributeJsonList.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No features found')));
      } else {
        debugPrint("🔍 Found results: ${jsonEncode(attributeJsonList)}");
      }
    } catch (e) {
      debugPrint("❌ Search error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error during search')));
    }
  }

  _muteVoiceGuidance(MuteVoiceGuidanceEvent event, emit) async {
    if (isMuted) {
      await ttsEngine.setVolume(1);
      isMuted = false;
      _eventCompleted(emit);
    } else {
      await ttsEngine.setVolume(0);
      isMuted = true;
      _eventCompleted(emit);
    }
  }

  Future<void> _onIdentifyFeatures(
      IdentifyFeaturesAtTapEvent event,
      emit,
      ) async {
    showLoaderDialog(event.context);
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
    } catch (e) {
      Navigator.pop(event.context);
      debugPrint("Identify error: $e");
    }
    _eventCompleted(emit);
  }

  Future<void> _onStartNavigation(StartNavigationEvent event, emit) async {
    destinationPoint = event.destination;
    final mapController = event.controller;

    final currentPos = mapController.locationDisplay.location?.position;
    if (currentPos == null) return;

    final currentLocation = ArcGISPoint(
      x: currentPos.x,
      y: currentPos.y,
      spatialReference: SpatialReference.wgs84,
    );

    final routeParameters =
    await routeTask.createDefaultParameters()
      ..returnDirections = true
      ..returnStops = true
      ..returnRoutes = true
      ..outputSpatialReference = SpatialReference.wgs84;

    routeParameters.setStops([
      Stop(currentLocation)..name = "Current Location",
      Stop(destinationPoint!)..name = "Destination",
    ]);

    routeResult = await routeTask.solveRoute(routeParameters);

    if (mapController.graphicsOverlays.isEmpty) {
      mapController.graphicsOverlays.add(GraphicsOverlay());
    }
    mapController.graphicsOverlays.first.graphics.clear();

    // Draw initial route polyline
    final routeGeometry = routeResult!.routes.first.routeGeometry;
    final routeSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.blue,
      width: 4,
    );
    final routeGraphic = Graphic(geometry: routeGeometry, symbol: routeSymbol);
    mapController.graphicsOverlays.first.graphics.add(routeGraphic);

    // Initialize tracker
    routeTracker = RouteTracker.create(
      routeResult: routeResult!,
      routeIndex: 0,
      skipCoincidentStops: true,
    )!;

    // Voice guidance
    voiceGuidanceSub = routeTracker?.onNewVoiceGuidance.listen((vg) {
      if (vg.text.isNotEmpty) {
        routeTracker?.setSpeechEngineReady(() => false);
        flutterTts.speak(vg.text).then((_) {
          routeTracker?.setSpeechEngineReady(() => true);
        });
      }
    });

    // Tracking status listener
    trackingStatusSub = routeTracker!.onTrackingStatusChanged.listen((status) {
      // Update UI, remaining distance, ETA, etc.
      add(
        TrackingStatusUpdatedEvent(status: status, controller: mapController),
      );
    });

    // 🔑 LIVE GPS tracking feed into RouteTracker
    mapController.locationDisplay.onLocationChanged.listen((location) {
      routeTracker?.trackLocation(location);
    });

    mapController.locationDisplay.autoPanMode =
        LocationDisplayAutoPanMode.navigation;
    mapController.locationDisplay.start();

    _eventCompleted(emit);
  }


  void showLoaderDialog(BuildContext context, {String message = "Loading..."}) {
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
                Text("Do you want to navigate?", style: TextStyle(fontWeight: FontWeight.bold),),
                ElevatedButton.icon(
                  icon: const Icon(Icons.navigation, color: Colors.white),
                  label: const Text("Navigator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColor.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final mapPoint = await controller.screenToLocation(
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
                    physics:ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _onMapReady(PgisMapReady event, emit) async {
    final controller = event.controller;
    controller.arcGISMap = map;
    await controller.setViewpointGeometry(indiaEnvelope, paddingInDiPs: 50);
    await _enableUserLocation(controller);
    await _addPipelineLayer(controller);
    //  await initStops();
    await initRoute();
    _eventCompleted(emit);
  }

  Future<void> _enableUserLocation(ArcGISMapViewController controller) async {
    controller.locationDisplay.dataSource = locationDataSource;
    await locationDataSource.start();
  }

  Future<void> _addPipelineLayer(ArcGISMapViewController controller) async {
    try {
      final uri = Uri.parse(pipelineLayerUrl);
      final pipelineLayer = ArcGISMapImageLayer.withUri(uri);
      await pipelineLayer.load();
      map.operationalLayers.add(pipelineLayer);
      for (final content in pipelineLayer.subLayerContents) {
        if (content is ArcGISMapImageSublayer) {
          await content.load();
          final sublayerUri = content.table?.uri;
          if (sublayerUri != null) {
            print('🆔 Sublayer URI: $sublayerUri');
            final serviceFeatureTable = ServiceFeatureTable.withUri(
              sublayerUri,
            );
            final featureLayer = FeatureLayer.withFeatureTable(
              serviceFeatureTable,
            );
            await featureLayer.load();
            final lineSymbol = SimpleLineSymbol(
              style: SimpleLineSymbolStyle.solid,
              color: Colors.yellow.shade800,
              width: 2.5,
            );
            featureLayer.renderer = SimpleRenderer(symbol: lineSymbol);
            featureLayerList.add(featureLayer);
          }
        }
      }
      map.operationalLayers.addAll(featureLayerList);
      await controller.setViewpointGeometry(indiaEnvelope, paddingInDiPs: 12);
    } catch (e) {
      print('❌ Error loading layer: $e');
    }
  }

  final _origin = ArcGISPoint(
    x: -117.1490,
    y: 32.7353,
    spatialReference: SpatialReference.wgs84,
  );

  final _destination = ArcGISPoint(
    x: -117.2266,
    y: 32.7630,
    spatialReference: SpatialReference.wgs84,
  );

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
      routeParameters.findBestSequence = false;
      routeParameters.preserveFirstStop = true;
      // routeParameters.setOutSpatialReference(SpatialReference.wgs84);

      _routeResult = await routeTask.solveRoute(routeParameters);

      if (_routeResult.routes.isEmpty) return;
    } catch (e) {
      print("Route solving error: $e");
    }
  }

  String formatDistance(ArcGISRoute route) {
    return (route.totalLength * 0.00062137).toStringAsFixed(2);
  }

  String formatTime(double time) {
    final int hour = time ~/ 60;
    final int minutes = (time % 60).round();
    return '$hour hr $minutes m';
  }

  final _stops = <Stop>[];
  final _stopsGraphicsOverlay = GraphicsOverlay();

  Future<void> initStops() async {
    // Create symbols to use for the start and end stops of the route.
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

    // Add the start and end points to the stops graphics overlay.
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

      final graphicsOverlay = GraphicsOverlay();
      graphicsOverlay.graphics.add(graphic);

      event.controller.graphicsOverlays.clear();
      event.controller.graphicsOverlays.add(graphicsOverlay);
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
      print(
        "Points--------------------------------------------------${points}",
      );
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

        final graphicsOverlay = GraphicsOverlay();
        graphicsOverlay.graphics.clear();
        graphicsOverlay.graphics.add(graphic);

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

      print("📍 Selected TLP Details: $attributes");

      final point = ArcGISPoint(
        x: x,
        y: y,
        spatialReference: SpatialReference.wgs84,
      );

      // Marker symbol for TLP
      final markerSymbol = SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: Colors.red,
        size: 12,
      );

      final graphic = Graphic(geometry: point, symbol: markerSymbol);

      final graphicsOverlay = GraphicsOverlay();
      graphicsOverlay.graphics.add(graphic);
      event.controller.graphicsOverlays.add(graphicsOverlay);

      // Zoom to the point
      await event.controller.setViewpointCenter(point, scale: 5000);
      if (attributes != null) {
        // Optional: Show bottom sheet or dialog with details
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
      print("❌ No point geometry returned for TLP");
    }
  }

  _onTrackingStatusUpdated(TrackingStatusUpdatedEvent event, emit) async {
    final mapController = event.controller;
    final status = event.status;
    final distText = status.routeProgress.remainingDistance.displayText;
    final unit =
        status.routeProgress.remainingDistance.displayTextUnits.abbreviation;
    final timeText = PGISHelper.formatDuration(
      (status.routeProgress.remainingTime * 60).toInt(),
    );

    var nextDir = '';
    final dirList = status.routeResult.routes.first.directionManeuvers;
    final nextIndex = status.currentManeuverIndex + 1;
    if (nextIndex < dirList.length) {
      nextDir = dirList[nextIndex].directionText;
    }

    _eventCompleted(emit);

    if (status.destinationStatus == DestinationStatus.reached) {
      add(StopNavigationEvent(controller: mapController));
    }
  }

  _onStopNavigation(StopNavigationEvent event, emit) async {
    final mapController = event.controller;
    await flutterTts.stop();
    mapController.locationDisplay.autoPanMode = LocationDisplayAutoPanMode.off;
    // emit(state.copyWith(isNavigating: false, routeStatus: 'Destination reached.'));
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<PgisState> emit) {
    emit(
      FetchPgisDataState(
        isPageLoader: isPageLoader,
        isDetailsLoader: isDetailsLoader,
        isNavigating: isNavigating,
        isMuted: isMuted,
        isArcGISStreets: isArcGISStreets,
        fromController: fromController,
        toController: toController,
        fromLocationList: fromLocationList,
        toLocationList: toLocationList,
        pipelineCtrl: pipelineCtrl,
        sectionCtrl: sectionCtrl,
        stationCtrl: stationCtrl,
        tlpCtrl: tlpCtrl,
      ),
    );
  }
}
