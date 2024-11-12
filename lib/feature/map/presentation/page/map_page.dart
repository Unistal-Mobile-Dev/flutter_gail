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
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/page/add_marker_page.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/pdf_helper.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';

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
  final _locationHistoryLineOverlay = GraphicsOverlay();
  final _locationHistoryPointOverlay = GraphicsOverlay();


  @override
  void initState() {
    BlocProvider.of<MapBloc>(context)
        .add(MapPageLoadEvent(context: context));
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
    final identifyGraphicsOverlayResult =
    await _mapViewController.identifyGraphicsOverlay(
      _stopsGraphicsOverlay,
      screenPoint: localPosition,
      tolerance: 22,
    );

    if (identifyGraphicsOverlayResult.graphics.isEmpty) return;
    if (mounted) {
      for(var data in identifyGraphicsOverlayResult.graphics){
         print(data.attributes.toString());
      }
      final graphic = identifyGraphicsOverlayResult.graphics.first;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(graphic.attributes.toString()));
        },
      );
    }
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

          dataState.isEndPatrolling == true ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ) : const SizedBox.shrink(),

          dataState.isEndPatrolling == true ?
          _endPatrollingButton(dataSate: dataState)
              : const SizedBox.shrink(),

          dataState.isStartPatrolling == false &&
              dataState.isEndPatrolling == false ?
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ) : const SizedBox.shrink(),

          dataState.isStartPatrolling == false &&
              dataState.isEndPatrolling == false ?
         _navigationButton(dataState: dataState)
              : const SizedBox.shrink(),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _recentButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addMarkerButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addCrossingButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addIncidentButton(),
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
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          dataState.isNavigationBool == true
              ? "Reload Route"
              : 'Navigation',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.navigation, color: AppColor.themeSecondary,
          size: MediaQuery.of(context).size.width * 0.05,),
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

  Widget _recentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Re-centre',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.location_history, color: Colors.blueAccent,
          size: MediaQuery.of(context).size.width * 0.05,),
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
        icon: Icon(Icons.location_searching_sharp, color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          BlocProvider.of<AddMarkerBloc>(context).add(AddMarkerPageLoadEvent(context: context));
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
        icon: Icon(Icons.transgender_outlined, color: AppColor.themeColor,
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

  Widget _statusButton({required FetchMapPageDataState dataSate}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          dataSate.taskData.taskStatus == TaskStatus.notStarted ? AppString.start
          : dataSate.taskData.taskStatus == TaskStatus.started ? AppString.pause
          : dataSate.taskData.taskStatus == TaskStatus.pause ? AppString.start : AppString.completed,
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.task_outlined, color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {

          TaskStatus taskStatus =  TaskStatus.notStarted;
          if(dataSate.taskData.taskStatus == TaskStatus.notStarted){
            taskStatus =  TaskStatus.started;
          }
          else if(dataSate.taskData.taskStatus == TaskStatus.started) {
            taskStatus =  TaskStatus.pause;
          }
          else if(dataSate.taskData.taskStatus == TaskStatus.pause) {
            taskStatus =  TaskStatus.started;
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
    );
  }

  Widget _endPatrollingButton({required FetchMapPageDataState dataSate}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(AppString.completed,
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.task_outlined, color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          BlocProvider.of<MapBloc>(context).add(MapPageUpdateTaskEvent(
              context: context,
              taskStatus: TaskStatus.completed
          ));
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


  void onMapViewReady() async{
    _mapViewController.arcGISMap =
        ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    _mapViewController.graphicsOverlays.add(_routeGraphicsOverlay);
    _mapViewController.graphicsOverlays.add(_stopsGraphicsOverlay);
    final imageStart = await ArcGISImage.fromAsset(AppIcon.startLocationIcon);
    final routeStartPointMarker = PictureMarkerSymbol.withImage(imageStart)
      ..width = 20
      ..height = 20;

    final imageEnd = await ArcGISImage.fromAsset(AppIcon.endLocationIcon);
    final routeEndPointMarker = PictureMarkerSymbol.withImage(imageEnd)
      ..width = 20
      ..height = 20;

    List<PointsModel> pointsList =  BlocProvider.of<TaskBloc>(!context.mounted ? context : context).taskData.shapeData!.pointsList!;
    final startPoint1 = Viewpoint.withLatLongScale(
      latitude: pointsList[0].y,
      longitude: pointsList[0].x,
      scale: 2e4,
    );

    final endPoint1 = Viewpoint.withLatLongScale(
      latitude: pointsList[pointsList.length-1].y,
      longitude: pointsList[pointsList.length-1].x,
      scale: 2e4,
    );

    Map<String, dynamic> attributes1 = {"id" :1};
    Map<String, dynamic> attributes2 = {"id" :2};

    _stopsGraphicsOverlay.graphics.addAll([
      Graphic(geometry: startPoint1.targetGeometry, symbol: routeStartPointMarker, attributes: attributes1),
      Graphic(geometry: endPoint1.targetGeometry, symbol: routeEndPointMarker, attributes: attributes2),
    ]);
    _initPolyline();
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

    _mapViewController.locationDisplay.onLocationChanged.listen((onData) {
      print(onData.additionalSourceProperties);
      BlocProvider.of<MapBloc>(!context.mounted ? context : context).add(MapRouteLocationCheck(
          context: !context.mounted ? context : context,
          currentPoint: ArcGISPoint(
          x: onData.position.x,
          y: onData.position.y
      )));
    });
    _startLocationDataSource();
    setState(() {});
  }

  Future<void> _startLocationDataSource() async {
    // final routeLineJson =
    // await rootBundle.loadString('assets/SimulatedRoute.json');

    List<PointsModel> pointsList =  BlocProvider.of<TaskBloc>(context).taskData.shapeData!.pointsList!;
    List<List<dynamic>> addPath = [];

    final imageStart = await ArcGISImage.fromAsset(AppIcon.wmIcon);
    final routeStartPointMarker = PictureMarkerSymbol.withImage(imageStart)
      ..width = 20
      ..height = 20;
    for(var pointData in pointsList){
      addPath.add([pointData.x,pointData.y]);
/*      _stopsGraphicsOverlay.graphics.addAll([
        Graphic(geometry: ArcGISPoint(
          x: pointData.x,
          y:pointData.y,
          z: pointData.z,
          m: pointData.m,
          spatialReference: SpatialReference.wgs84,
        ), symbol: routeStartPointMarker)
      ]);*/
    }
    var json = {
      "paths": [addPath],
      "spatialReference": {
        "wkid": 4326
      }
    };
    final routeLine = Geometry.fromJsonString(jsonEncode(json).toString()) as Polyline;
    final routeLineSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.blue,
      width: 2.0,
    );

    final routeLineSymbol1 = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.red.withOpacity(0.2),
      width: 20.0,

    );

    final routeGraphic =
    Graphic(geometry: routeLine, symbol: routeLineSymbol,);
     _routeGraphicsOverlay.graphics.add(routeGraphic);

    final routeGraphic1 =
    Graphic(geometry: routeLine, symbol: routeLineSymbol1);
    _routeGraphicsOverlay.graphics.add(routeGraphic1);
    currentLocation();
    setState(() {});
  }

  void currentLocation() async {

    _mapViewController.locationDisplay.dataSource = _locationDataSource;
    _mapViewController.locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;

    // final imageEnd = await ArcGISImage.fromAsset(AppIcon.gpsMovedIcon);
    // final routeEndPointMarker = PictureMarkerSymbol.withImage(imageEnd)
    //   ..width = 35
    //   ..height = 35;
    //
    // _mapViewController.locationDisplay.courseSymbol = routeEndPointMarker;

    _statusSubscription = _locationDataSource.onStatusChanged.listen((status) {
      setState(() => _status = status);
    });

    setState(() => _status = _locationDataSource.status);

    _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
          setState(() => _autoPanMode = mode);
        });
    setState(() => _autoPanMode = _mapViewController.locationDisplay.autoPanMode);
    try {
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
    if(datState.directionList.isNotEmpty){
      List<ArcGISPoint> pointsList =  datState.directionList;
      List<List<dynamic>> addPath = [];
      for(var pointData in pointsList) {
        addPath.add([pointData.x, pointData.y]);
      }
      var json = {
        "paths": [addPath],
        "spatialReference": {
          "wkid": 4326
        }
      };
      final routeLine = Geometry.fromJsonString(jsonEncode(json).toString()) as Polyline;
      final routeLineSymbol = SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.green,
        width: 2.0,
      );
      final routeGraphic =
      Graphic(geometry: routeLine, symbol: routeLineSymbol);
      _routeGraphicsOverlay.graphics.add(routeGraphic);
    }
  }

}