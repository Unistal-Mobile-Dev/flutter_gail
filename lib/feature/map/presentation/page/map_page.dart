import 'dart:convert';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/presentation/page/add_incident_page.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/presentation/widget/sample_state_support.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addCrossing/presentation/page/add_crossing_page.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';
import 'package:flutter_gail/feature/task/addEncroachment/presentation/page/encroachment_page.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/page/add_marker_page.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/feature/task/deviation/presentation/page/deviation_page.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonWidgets/message_box_pop_button_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/message_box_two_button_pop.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SampleStateSupport {

  final _mapViewController = ArcGISMapView.createController();
  final _locationDataSource = SystemLocationDataSource();
  StreamSubscription? _statusSubscription;
  var _status = LocationDataSourceStatus.stopped;
  StreamSubscription? _autoPanModeSubscription;
  var _autoPanMode = LocationDisplayAutoPanMode.recenter;
  var _ready = false;

  final _stopsGraphicsOverlay = GraphicsOverlay();
  final _routeGraphicsOverlay = GraphicsOverlay();
  final _routePathGraphicsOverlay = GraphicsOverlay();
  final _locationHistoryLineOverlay = GraphicsOverlay();
  final _locationHistoryPointOverlay = GraphicsOverlay();

  bool isFirstLocation =  false;


  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    _locationDataSource.stop();
    _statusSubscription?.cancel();
    _autoPanModeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if(state is FetchMapPageDataState){
                direction(datState: state);
                return SafeArea(
                  top: false,
                  child: Stack(
                    children: [
                      ArcGISMapView(
                        controllerProvider: () => _mapViewController,
                        onMapViewReady: onMapViewReady,
                        onTap: onTap,
                      ),
                      _mapViewType(dataState: state),
                      _actionButtons(dataState: state),
                    ],
                  ),
                );
              } else {
                return const Center(child: CenterLoaderWidget());
              }
            })
    );
  }

  void onTap(Offset localPosition) async {

    TaskStatus taskStatus =  BlocProvider.of<MapBloc>(!context.mounted ? context : context).taskData.taskStatus!;
    if(taskStatus != TaskStatus.started){
      var res =  await showDialog(
        context: !context.mounted ? context : context,
        builder: (context) {
          return MessageBoxPopButtonWidget(
            title: "Alert",
            message: "You task not started",
            onPressed: () => Navigator.pop(context, false),
          );
        },
      );
      if(res == false){
        return;
      }
    }

    final identifyGraphicsOverlayResult =
    await _mapViewController.identifyGraphicsOverlay(
      _stopsGraphicsOverlay,
      screenPoint: localPosition,
      tolerance: 22,
    );

    final graphic = identifyGraphicsOverlayResult.graphics.first;
    Map<String, dynamic> jsonValue = graphic.attributes;
    if(jsonValue['markername'] != null)
    {

      var res =  await showDialog(
        context: !context.mounted ? context : context,
        builder: (context) {
          return MessageBoxTwoButtonPopWidget(
            message: "You want update the ${jsonValue['markerName']}?",
            okButtonText: "Update",
            onPressed: () => Navigator.pop(context, true),
          );
        },
      );
      if(res == true){
        BlocProvider.of<AddMarkerBloc>(!context.mounted ? context : context)
            .add(AddMarkerPageLoadEvent(context: !context.mounted ? context : context, data: jsonValue));
        Navigator.push(
          !context.mounted ? context : context,
          FadeRoute(
              page: const AddMarkerPage()),
        );
      }
    }
  }

  Widget _mapViewType({required FetchMapPageDataState dataState})   {
    return Positioned(
      top: 50,
      right: 10,
      child: Card(
        shape: const CircleBorder(), // <-- Makes it circular
        elevation: 2,
        clipBehavior: Clip.antiAlias, // Ensures content is clipped to the circle
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<MapBloc>(context).add(
              SelectMapArcGISStreets(
                isArcGISStreets: dataState.isArcGISStreets ? false : true,
              ),
            );
            _mapViewController.arcGISMap = ArcGISMap.withBasemapStyle(
              dataState.isArcGISStreets
                  ? BasemapStyle.arcGISStreets
                  : BasemapStyle.arcGISImagery,
            );
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              dataState.isArcGISStreets
                  ? AppIcon.arcGISStreetsIcon
                  : AppIcon.arcGISImageryIcon,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

  }

  Widget _actionButtons({required FetchMapPageDataState dataState}){
    return Positioned(
      top: 50,
      left: 10,
      child: dataState.isLoader == false ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _backButton(),

          dataState.isStartPatrolling == true ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ) : const SizedBox.shrink(),

          dataState.isStartPatrolling == true ?
          _statusButton(dataSate: dataState)
              : const SizedBox.shrink(),

          dataState.taskData.taskStatus != TaskStatus.notStarted
              && dataState.taskData.taskStatus != TaskStatus.completed ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ) : const SizedBox.shrink(),

          dataState.taskData.taskStatus != TaskStatus.notStarted
              && dataState.taskData.taskStatus != TaskStatus.completed ?
          _endPatrollingButton(dataSate: dataState)
              : const SizedBox.shrink(),

          dataState.isStartPatrolling == false &&
              dataState.isEndPatrolling == false ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ) : const SizedBox.shrink(),

          //  dataState.isStartPatrolling == false &&
          //      dataState.isEndPatrolling == false ?
          // _navigationButton(dataState: dataState)
          //      : const SizedBox.shrink(),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _recentButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          _addMarkerButton()
              : const SizedBox.shrink(),
          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ): const SizedBox.shrink(),

          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          _addCrossingButton() : const SizedBox.shrink(),
          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ): const SizedBox.shrink(),

          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          _addIncidentButton() : const SizedBox.shrink(),
          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ): const SizedBox.shrink(),

          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          _addEncroachmentButton(): const SizedBox.shrink(),

          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ): const SizedBox.shrink(),

          dataState.taskData.taskStatus == TaskStatus.started
              || dataState.taskData.taskStatus == TaskStatus.resume ?
          _addDeviationButton() : const SizedBox.shrink(),
        ],
      ) : const DottedLoaderWidget(),
    );
  }

  Widget _backButton() {
    return IconButton(onPressed: () {
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_ios,
      color: AppColor.black,)
    );
  }

  Widget _navigationButton({required FetchMapPageDataState dataState}) {
    return  SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          dataState.isNavigationBool == true
              ? "Reload Route"
              : 'Navigation',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Image.asset(AppIcon.mapIcon, height: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          _mapViewController.locationDisplay.autoPanMode =
              LocationDisplayAutoPanMode.navigation;
          _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
            // setState(() => _autoPanMode = mode);
          });
          List<PointsModel> pointsList = dataState.taskData.shapeData!.pointsList!;
          ArcGISPoint point = _mapViewController.locationDisplay.location!.position;
          if(pointsList.isNotEmpty){
            BlocProvider.of<MapBloc>(context).add(MapRouteDirection(context: context,
                startPoint:  ArcGISPoint(
                    x: pointsList[0].x,
                    y: pointsList[0].y
                ),
                endPoint: ArcGISPoint(
                    x: pointsList[pointsList.length - 1].x,
                    y: pointsList[pointsList.length - 1].y
                ),
                currentPoint: point)
            );
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  void navigation({required Offset localPosition}) async {
    final controller = await _mapViewController; // Your ArcGISMapViewController
    final ArcGISPoint? mapPoint = await controller.screenToLocation(screen: localPosition);

    if (mapPoint != null) {
      // Project to WGS84 (lat/lng) if needed
      final Geometry projected = GeometryEngine.project(
        mapPoint,
        outputSpatialReference: SpatialReference.wgs84,
      );
      if (projected is ArcGISPoint) {
        double latitude = projected.y;
        double longitude = projected.x;

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        _mapViewController.locationDisplay.autoPanMode =
            LocationDisplayAutoPanMode.navigation;
        _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
          // setState(() => _autoPanMode = mode);
        });
        ArcGISPoint point = _mapViewController.locationDisplay.location!.position;
        BlocProvider.of<MapBloc>(context).add(MapRouteDirection(context: context,
            startPoint:  ArcGISPoint(
                x: point.x,
                y: point.y
            ),
            endPoint: ArcGISPoint(
              x: longitude,
              y: latitude,
            ),
            currentPoint: point)
        );
      } else {
        print("Projection failed. Not a MapPoint.");
      }
    } else {
      print("Tap location could not be converted.");
    }
  }

  Future<void> getLatLngFromOffset(Offset localPosition) async {
    final controller = await _mapViewController; // Your ArcGISMapViewController
    final ArcGISPoint? mapPoint = await controller.screenToLocation(screen: localPosition);

    if (mapPoint != null) {
      // Project to WGS84 (lat/lng) if needed
      final Geometry projected = GeometryEngine.project(
        mapPoint,
        outputSpatialReference: SpatialReference.wgs84,
      );
      if (projected is ArcGISPoint) {
        double latitude = projected.y;
        double longitude = projected.x;

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        _mapViewController.locationDisplay.autoPanMode =
            LocationDisplayAutoPanMode.navigation;
        _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
          // setState(() => _autoPanMode = mode);
        });
        ArcGISPoint point = _mapViewController.locationDisplay.location!.position;
        BlocProvider.of<MapBloc>(context).add(MapRouteDirection(context: context,
            startPoint:  ArcGISPoint(
                x: point.x,
                y: point.y
            ),
            endPoint: ArcGISPoint(
              x: mapPoint.x,
              y: mapPoint.y,
            ),
            currentPoint: point)
        );

      } else {
        print("Projection failed. Not a MapPoint.");
      }
    } else {
      print("Tap location could not be converted.");
    }
  }

  Widget _recentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Re-centre',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Image.asset(AppIcon.gpsIcon, height: MediaQuery.of(context).size.width * 0.05,), // MediaQuery.of(context).size.width * 0.05,
        onPressed: () {
          currentLocation();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addMarkerButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Marker',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.location_searching_sharp, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          BlocProvider.of<AddMarkerBloc>(context).add(AddMarkerPageLoadEvent(context: context, data: ""));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddMarkerPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addCrossingButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Crossing',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.transgender_outlined, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          BlocProvider.of<AddCrossingBloc>(context)
              .add(AddCrossingPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddCrossingPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addIncidentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Add Incident',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.gpp_maybe_sharp, color: AppColor.cardBlue,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () async {
          BlocProvider.of<AddIncidentBloc>(context).add(AddIncidentPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddIncidentPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addEncroachmentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Add Structures',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.fence_rounded, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () async {
          BlocProvider.of<EncroachmentBloc>(context).add(PageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const EncroachmentPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addDeviationButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Add Deviation',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.developer_board, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () async {
          BlocProvider.of<DeviationBloc>(context).add(DeviationPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const DeviationPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _statusButton({required FetchMapPageDataState dataSate}) {
    return dataSate.taskData.taskStatus  != TaskStatus.completed
        ? SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          dataSate.taskData.taskStatus == TaskStatus.notStarted ? AppString.start
              : dataSate.taskData.taskStatus == TaskStatus.started ? AppString.pause
              : dataSate.taskData.taskStatus == TaskStatus.pause ? AppString.resume
              : dataSate.taskData.taskStatus == TaskStatus.resume ? AppString.pause : AppString.completed,
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.task_outlined, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {

          TaskStatus taskStatus =  TaskStatus.notStarted;
          if(dataSate.taskData.taskStatus == TaskStatus.notStarted){
            _mapViewController.locationDisplay.start();
            taskStatus =  TaskStatus.started;
          }
          else if(dataSate.taskData.taskStatus == TaskStatus.started) {
            _mapViewController.locationDisplay.stop();
            taskStatus =  TaskStatus.pause;
          }
          else if(dataSate.taskData.taskStatus == TaskStatus.pause) {
            _mapViewController.locationDisplay.start();
            taskStatus =  TaskStatus.resume;
          }
          else if(dataSate.taskData.taskStatus == TaskStatus.resume) {
            _mapViewController.locationDisplay.stop();
            taskStatus =  TaskStatus.pause;
          }
          BlocProvider.of<MapBloc>(context).add(MapPageUpdateTaskEvent(
              context: context,
              taskStatus: taskStatus
          ));
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    ) : const SizedBox.shrink();
  }

  Widget _endPatrollingButton({required FetchMapPageDataState dataSate}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(AppString.end,
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.task_outlined, color: EnvironmentConfig.of(context)!.primaryTheme,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () async {
          var res =  await showDialog(
            context: !context.mounted ? context : context,
            builder: (context) {
              return MessageBoxTwoButtonPopWidget(
                message: "Are you sure you want to end this task?",
                okButtonText: "End Task",
                onPressed: () => Navigator.pop(context, true),
              );
            },
          );
          if(res == true){
            _mapViewController.locationDisplay.stop();
            BlocProvider.of<MapBloc>(context).add(MapPageUpdateTaskEvent(
                context: context,
                taskStatus: TaskStatus.completed
            ));
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }


  void onMapViewReady() async {
    _mapViewController.arcGISMap =
        ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    // Add graphics overlays
    _mapViewController.graphicsOverlays.addAll([
      _routeGraphicsOverlay,
      _stopsGraphicsOverlay,
      _routePathGraphicsOverlay,
    ]);

    // Load marker images once
    final bpIcon = await ArcGISImage.fromAsset(AppIcon.bpIcon);
    final kmIcon = await ArcGISImage.fromAsset(AppIcon.kmIcon);
    final wmIcon = await ArcGISImage.fromAsset(AppIcon.wmIcon);
    final tlpIcon = await ArcGISImage.fromAsset(AppIcon.tlpIcon);

    final bpIconMarker = PictureMarkerSymbol.withImage(bpIcon);
    final kmIconMarker = PictureMarkerSymbol.withImage(kmIcon);
    final wmIconMarker = PictureMarkerSymbol.withImage(wmIcon);
    final tlpIconMarker = PictureMarkerSymbol.withImage(tlpIcon);

    // Add graphics for route points
    final routePointsList = BlocProvider.of<MapBloc>(context).routePointsList;

    for (var routePointsData in routePointsList) {
      for (var markerData in routePointsData.markerList) {
        final point = Viewpoint.withLatLongScale(
          latitude: markerData.gpsy!,
          longitude: markerData.gpsx!,
          scale: 2e4,
        ).targetGeometry;

        final attributes = {
          "markername": markerData.markerName,
          "markernumber": markerData.markerNumber.toString(),
          "markertype": markerData.markerType.toString(),
          "gpsx": markerData.gpsx,
          "gpsy": markerData.gpsy,
        };

        // Choose marker based on type
        PictureMarkerSymbol symbol;
        switch (markerData.markerType.toString()) {
          case "1":
            symbol = bpIconMarker;
            break;
          case "3":
          case "12":
            symbol = kmIconMarker;
            break;
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
          case "10":
          case "11":
          case "13":
          case "14":
          case "15":
            symbol = wmIconMarker;
            break;
          default:
            symbol = bpIconMarker;
        }

        _stopsGraphicsOverlay.graphics.add(
          Graphic(geometry: point, symbol: symbol, attributes: attributes),
        );
      }

      // Add TLP markers
      for (var tlpData in routePointsData.tlpList) {
        final point = Viewpoint.withLatLongScale(
          latitude: tlpData.gpsy!,
          longitude: tlpData.gpsx!,
          scale: 2e4,
        ).targetGeometry;

        final attributes = {
          "markername": "TLP",
          "markernumber": tlpData.id.toString(),
          "markertype": "17",
          "gpsx": tlpData.gpsx,
          "gpsy": tlpData.gpsy,
        };

        _stopsGraphicsOverlay.graphics.add(
          Graphic(geometry: point, symbol: tlpIconMarker, attributes: attributes),
        );
      }
    }

    // Adjust marker sizes based on zoom level dynamically
    _mapViewController.onViewpointChanged.listen((_) async {
      final currentViewpoint = await _mapViewController.getCurrentViewpoint(
          ViewpointType.centerAndScale);

      if (currentViewpoint != null) {
        final scale = currentViewpoint.targetScale;

        double markerSize;
        if (scale < 5000) {
          markerSize = 35; // zoomed in
        } else if (scale < 20000) {
          markerSize = 25;
        } else {
          markerSize = 15; // zoomed out
        }

        for (var graphic in _stopsGraphicsOverlay.graphics) {
          if (graphic.symbol is PictureMarkerSymbol) {
            (graphic.symbol as PictureMarkerSymbol)
              ..width = markerSize
              ..height = markerSize;
          }
        }

        // _stopsGraphicsOverlay.refresh(); // redraw symbols
      }
    });

    _initPolyline(); // draw route lines & buffers
  }


  Future<void> _initPolyline() async {

    _locationHistoryLineOverlay.renderer = SimpleRenderer(
      symbol: SimpleLineSymbol(
        color: Colors.red[100]!,
        width: 2.0,
      ),
    );
    _locationHistoryPointOverlay.renderer = SimpleRenderer(
      symbol: SimpleMarkerSymbol(
        color: Colors.red,
        size: 10.0,
      ),
    );

    _mapViewController.graphicsOverlays.addAll([
      _locationHistoryLineOverlay,
      _locationHistoryPointOverlay,
    ]);

    DateTime _lastLocationUpdate = DateTime.now();
    List<List<PointsModel>> routes =  BlocProvider.of<MapBloc>(context).routes;

    final mapData = BlocProvider.of<MapBloc>(context).mapData;
    final double buffer = (mapData.buffer is num)
        ? mapData.buffer.toDouble()
        : double.tryParse(mapData.buffer.toString()) ?? 0.0;

    final int timeInterval = (mapData.timeInterval is int)
        ? mapData.timeInterval
        : int.tryParse(mapData.timeInterval.toString()) ?? 5;

    _lastLocationUpdate = DateTime.now().subtract(Duration(seconds: timeInterval));

    print("==========================location");

    _mapViewController.locationDisplay.onLocationChanged.listen((onData) {
      final now = DateTime.now();
      if (mounted && now.difference(_lastLocationUpdate).inSeconds >= timeInterval) {
        _lastLocationUpdate = now;
        context.read<MapBloc>().add(
          MapRouteLocationCheck(
            context: context,
            currentPoint: ArcGISPoint(
              x: onData.position.x,
              y: onData.position.y,
            ),
            verticalAccuracy: onData.verticalAccuracy,
            speed: onData.speed,
          ),
        );
      }
    });

    for(var routeData in routes){
      _startLocationDataSource(pointsLists: routeData, buffer: buffer);
    }
    setState(() {});
  }

  Future<void> _startLocationDataSource({
    required List<PointsModel> pointsLists,
    required double buffer, // here buffer = 100.0 (meters)
  }) async {
    List<List<dynamic>> addPath = [];

    for (var pointData in pointsLists) {
      addPath.add([pointData.x, pointData.y]);
    }

    var json = {
      "paths": [addPath],
      "spatialReference": {"wkid": 4326}
    };

    // Create route line
    final routeLine =
    Geometry.fromJsonString(jsonEncode(json).toString()) as Polyline;

    // Normal line symbol
    final routeLineSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.blue,
      width: 2.0,
    );

    // Add line to overlay
    final routeGraphic = Graphic(geometry: routeLine, symbol: routeLineSymbol);
    _routeGraphicsOverlay.graphics.add(routeGraphic);

    final linearUnitMeters = LinearUnit(unitId: LinearUnitId.meters);

    // ✅ Create a buffer polygon (100 m both sides)
    final bufferPolygon = GeometryEngine.bufferGeodetic(
      geometry: routeLine,
      distance: buffer, // e.g. 100.0
      distanceUnit: linearUnitMeters,
      maxDeviation: double.nan,
      curveType: GeodeticCurveType.geodesic,
    );

    // Fill symbol for buffer
    final bufferSymbol = SimpleFillSymbol(
      style: SimpleFillSymbolStyle.solid,
      color: Colors.red.withOpacity(0.2),
      outline: SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.red,
        width: 1.0,
      ),
    );

    final bufferGraphic = Graphic(geometry: bufferPolygon, symbol: bufferSymbol);
    _routeGraphicsOverlay.graphics.add(bufferGraphic);

    // Start location tracking
    currentLocation();
    setState(() {});
  }


  Future<void> currentLocation() async {
    final locationDisplay = _mapViewController.locationDisplay;
    locationDisplay.dataSource = _locationDataSource;

    // 🔹 Use navigation mode (map rotates with heading + stays centered)
    locationDisplay.autoPanMode = LocationDisplayAutoPanMode.navigation;

    // Custom marker for current location
    final imageEnd = await ArcGISImage.fromAsset(AppIcon.personLocation);
    final personSymbol = PictureMarkerSymbol.withImage(imageEnd)
      ..width = 35
      ..height = 35;

    locationDisplay.courseSymbol = personSymbol;
    locationDisplay.defaultSymbol = personSymbol;

    // Optional: separate heading arrow symbol
    final headingImage = await ArcGISImage.fromAsset(AppIcon.gpsIcon);
    final headingSymbol = PictureMarkerSymbol.withImage(headingImage)
      ..width = 30
      ..height = 30;
    locationDisplay.headingSymbol = headingSymbol;

    // Listen to status
    _statusSubscription = _locationDataSource.onStatusChanged.listen((status) {
      setState(() => _status = status);
    });
    setState(() => _status = _locationDataSource.status);

    _autoPanModeSubscription =
        locationDisplay.onAutoPanModeChanged.listen((mode) {
          setState(() => _autoPanMode = mode);
        });
    setState(() => _autoPanMode = locationDisplay.autoPanMode);

    try {
      // ✅ Start the locationDisplay itself (not only the datasource)
      await _locationDataSource.start();
    } on ArcGISException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text(e.message)),
        );
      }
    }

    setState(() => _ready = true);
  }



  void direction({required FetchMapPageDataState datState}) async {
    _routePathGraphicsOverlay.graphics.clear();

    if (datState.directionList.isEmpty) return;

    List<ArcGISPoint> pointsList = datState.directionList;

    // 🔹 Build Polyline from path
    List<List<dynamic>> addPath =
    pointsList.map((point) => [point.x, point.y]).toList();

    var json = {
      "paths": [addPath],
      "spatialReference": {"wkid": 4326}
    };

    final routeLine =
    Geometry.fromJsonString(jsonEncode(json)) as Polyline;

    final routeLineSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.green,
      width: 3.0,
    );

    final routeGraphic =
    Graphic(geometry: routeLine, symbol: routeLineSymbol);

    _routePathGraphicsOverlay.graphics.add(routeGraphic);
  }


}