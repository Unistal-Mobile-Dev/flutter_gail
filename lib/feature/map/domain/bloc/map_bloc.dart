import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/configuration_model.dart';
import 'package:flutter_gail/feature/map/domain/model/coordinates_model.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/domain/model/marker_point_model.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/task/viewTask/helper/task_helper.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';

part 'map_state.dart';

PointsModel lastPoint = PointsModel();

class MapBloc extends Bloc<MapEvent, MapState> {
  bool isLoader = false;
  List<MapModel> mapList = [];
  MapModel mapData = MapModel();
  List<ArcGISPoint> directionList = [];
  bool isNavigationBool = false;
  List<PointsModel> pointsList = [];
  ArcGISPoint startPoint = ArcGISPoint(x: 0.0, y: 0.0);
  ArcGISPoint endPoint = ArcGISPoint(x: 0.0, y: 0.0);
  bool isStartPatrolling = false;
  bool isEndPatrolling = false;
  TaskModel taskData = TaskModel();
  bool isTaskStatusChange = false;
  List<TaskModel> taskList = [];
  List<MarkerModel> markerList = [];
  List<List<PointsModel>> routes = [];
  List<RoutePointsModel> routePointsList = [];
  bool isArcGISStreets = false;
  int routeLength = 1;
  ConfigurationModel configurationData = ConfigurationModel();
  StreamSubscription<LatLng>? _positionStream;
  final MapHelper _mapHelper = MapHelper();
  LatLng? _lastLocation;
  List<LatLng> locationPath = [];
  final manager = BackgroundManager();

  MapBloc() : super(MapInitial()) {
    on<MapPageLoadEvent>(_pageLoadEvent);
    on<SelectMapArcGISStreets>(_selectMapType);
    on<MapRouteDirection>(_routeDirection);
    on<MapRouteLocationCheck>(_locationCheck);
    on<MapPageUpdateTaskEvent>(_updateTask);
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
    on<RestartTracking>(_onRestartTracking);
    on<NewLocationReceived>(_onNewLocationReceived);
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }

  _pageLoadEvent(MapPageLoadEvent event, emit) async {
    emit(MapPageLoadState());
    isLoader = false;
    isNavigationBool = false;
    isStartPatrolling = false;
    isEndPatrolling = false;
    isTaskStatusChange = false;
    isArcGISStreets = false;
    mapList = [];
    directionList = [];
    markerList = [];
    routes = [];
    routePointsList = [];
    routeLength = 1;
    locationPath = [];
    lastPoint = PointsModel();
    configurationData = ConfigurationModel();
    // Initialize in main()
    await manager.initializeService();

    // 🔹 Request permission before starting service
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // 🔹 Listen to background updates
    final service = FlutterBackgroundService();
    service.on('update').listen((data) {
      if (data != null) {
        String lastLocation =
            "📍 Lat: ${data['lat']} | Lng: ${data['lng']}\n🕒 ${data['timestamp']}";
      }
    });

    taskList = BlocProvider.of<TaskBloc>(event.context).searchTaskList;
    taskData = BlocProvider.of<TaskBloc>(event.context).taskData;

    var resConfiguration = await MapHelper.fetchConfiguration();
    if (resConfiguration != null) {
      configurationData = resConfiguration;
    }

    var routeRes = await MapHelper.fetchRoutes(
      routeId: taskData.patrollRouteId.toString(),
    );
    if (routeRes != null) {
      mapData = routeRes;
      mapData = routeRes;
      mapData.buffer =
      configurationData.buffer != null
          ? double.parse(configurationData.buffer.toString())
          : mapData.buffer;
      mapData.timeInterval =
      configurationData.timeInterval != null
          ? int.parse(configurationData.timeInterval.toString())
          : mapData.timeInterval;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("timeInterval", mapData.timeInterval.toString());

      if (mapData.data != null) {
        for (var data in mapData.data!) {
          List<PointsModel> list = [];
          final geometryData = data.geometry;
          if (geometryData != null) {
            list.addAll(
              geometryData.coordinates.map(
                    (coord) => PointsModel(
                  y: coord.latitude,
                  x: coord.longitude,
                  m: 0.0,
                  z: 0.0,
                ),
              ),
            );
            routeLength++;
          }
          routes.add(list);
        }
      }
    }
    //  pointsList =  taskData.shapeData!.pointsList!;
    if (pointsList.isNotEmpty) {
      startPoint = ArcGISPoint(x: pointsList[0].x, y: pointsList[0].y);
      endPoint = ArcGISPoint(
        x: pointsList[pointsList.length - 1].x,
        y: pointsList[pointsList.length - 1].y,
      );
    } else {
      startPoint = ArcGISPoint(x: 0.0, y: 0.0);
    }

    if (taskData.taskStatus == TaskStatus.started ||
        taskData.taskStatus == TaskStatus.resume ||
        taskData.taskStatus == TaskStatus.pause) {
      isStartPatrolling = true;
    } else {
      isStartPatrolling = false;
    }

    if (taskData.sectionCode.toString().isNotEmpty) {
      var markerRes = await MapHelper.fetchMarkerList(
        sectionCode: taskData.sectionCode.toString(),
      );
      if (markerRes != null) {
        markerList = markerRes;
      }
    }

    if (mapData.data != null) {
      for (var sectionData in mapData.data!) {
        var routePointRes = await MapHelper.fetchPointsDetails(
          sectionCode: sectionData.sectionCode,
        );
        if (routePointRes != null) {
          routePointsList.add(routePointRes);
        }
      }
    }

    var resMovingPath = await MapHelper.fetchMovingPath(
      taskId: taskData.taskId.toString(),
    );
    List<MarkerPointsModel> movingPathList = resMovingPath;
    if (movingPathList.isNotEmpty) {
      for (var data in movingPathList) {
        directionList.add(ArcGISPoint(x: data.gpsx, y: data.gpsy));
      }
    }

    if (taskData.taskStatus == TaskStatus.started ||
        taskData.taskStatus == TaskStatus.resume) {
      if( ! await manager.isRunning()){
         manager.startService();
      }
      add(
        StartTracking(!event.context.mounted ? event.context : event.context),
      );
    } else {
      add(StopTracking());
    }
    _eventComplete(emit);
  }


  _selectMapType(SelectMapArcGISStreets event, emit) {
    isArcGISStreets = event.isArcGISStreets;
    _eventComplete(emit);
  }

  _routeDirection(MapRouteDirection event, emit) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime currentDate = formatter.parse(DateTime.now().toString());
    DateTime dt1 = DateTime.parse(currentDate.toString());
    DateTime dt2 = DateTime.parse(
      taskData.assignedDate.toString().isNotEmpty
          ? taskData.assignedDate.toString()
          : DateTime.now().toString(),
    );

    final List<TaskModel> tempList =
    taskList.where((data) {
      return data.taskStatus == TaskStatus.started &&
          taskData.subTaskId != data.subTaskId;
    }).toList();

    if (dt1.compareTo(dt2) < 0) {
      SnackBarErrorWidget(
        event.context,
      ).show(message: "This task are future date");
      return;
    } else if (dt1.compareTo(dt2) > 0) {
      SnackBarErrorWidget(
        event.context,
      ).show(message: "This task are Back date");
      return;
    } else if (tempList.isNotEmpty) {
      SnackBarErrorWidget(event.context).show(
        message:
        "Your already start another task.So please complete first old task then start.",
      );
      return;
    }

    isLoader = true;
    isNavigationBool = true;
    directionList = [];
    _eventComplete(emit);

    var res = await MapHelper.fetchRoute(
      startPoint: event.startPoint,
      endPoint: event.endPoint,
    );
    directionList = res;

    isLoader = false;
    isNavigationBool = directionList.isNotEmpty ? true : false;
    _eventComplete(emit);
  }

  _locationCheck(MapRouteLocationCheck event, emit) async {
    BuildContext context = event.context;
    ArcGISPoint points = event.currentPoint;
    double speed = event.speed;
    double verticalAccuracy = event.verticalAccuracy;
    if (lastPoint.y == null) {
      lastPoint = PointsModel(x: points.x, y: points.y);
    }

    if (taskData.taskStatus == TaskStatus.started ||
        taskData.taskStatus == TaskStatus.resume ||
        taskData.taskStatus == TaskStatus.pause) {
      isStartPatrolling = true;
      isEndPatrolling = true;
    } else {
      isStartPatrolling = false;
      isEndPatrolling = false;
    }

    if (isStartPatrolling == false) {
      bool isBufferZone = await MapHelper.getNearestLocation(
        currentLocation: points,
        routes: routes,
      );
      isStartPatrolling = isBufferZone;
      isEndPatrolling = isBufferZone;
      _eventComplete(emit);
    }

    if (taskData.taskStatus == TaskStatus.started ||
        taskData.taskStatus == TaskStatus.resume) {
      // await MapHelper.locationSave(
      //   context: !context.mounted ? context : context,
      //   lastPoint: lastPoint,
      //   speed: speed,
      //   verticalAccuracy: verticalAccuracy,
      //   taskData: taskData,
      // );
    }

    lastPoint = PointsModel(x: points.x, y: points.y);
  }

  _updateTask(MapPageUpdateTaskEvent event, emit) async {
    isLoader = true;
    TaskStatus taskStatus = event.taskStatus;
    _eventComplete(emit);

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime currentDate = formatter.parse(DateTime.now().toString());
    DateTime dt1 = DateTime.parse(currentDate.toString());
    DateTime dt2 = DateTime.parse(
      taskData.assignedDate.toString().isNotEmpty
          ? taskData.assignedDate.toString()
          : DateTime.now().toString(),
    );

    final List<TaskModel> tempList =
    taskList.where((data) {
      return data.taskStatus == TaskStatus.started &&
          taskData.subTaskId != data.subTaskId;
    }).toList();

    if (dt1.compareTo(dt2) < 0) {
      SnackBarErrorWidget(
        event.context,
      ).show(message: "This task are future date");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (dt1.compareTo(dt2) > 0) {
      SnackBarErrorWidget(
        event.context,
      ).show(message: "This task are Back date");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (tempList.isNotEmpty) {
      SnackBarErrorWidget(event.context).show(
        message:
        "Your already start another task.So please complete first old task then start.",
      );
      isLoader = false;
      _eventComplete(emit);
      return;
    }

    if (taskData.taskStatus == TaskStatus.started ||
        taskData.taskStatus == TaskStatus.resume) {
      add(
        StartTracking(!event.context.mounted ? event.context : event.context),
      );
    } else {
      add(StopTracking());
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("taskStatus", "0");
    await prefs.setString("taskId", taskData.taskId.toString());
    await prefs.setString("subTaskId", taskData.subTaskId.toString());

    if (taskStatus == TaskStatus.started) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("taskStatus", "1");
      if( ! await manager.isRunning()){
        manager.startService();
      }

    }
    else if (taskStatus == TaskStatus.pause) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("taskStatus", "2");
      if(await manager.isRunning()){
         manager.stopService();
      }
    }
    else if (taskStatus == TaskStatus.resume) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("taskStatus", "5");
      if( ! await manager.isRunning()){
        manager.startService();
      }
    }
    else if (taskStatus == TaskStatus.completed) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("taskStatus", "3");
      if(await manager.isRunning()){
        manager.stopService();
      }
    }

    var res = await TaskHelper.updateTask(
      taskData: taskData,
      taskStatus:
      taskStatus == TaskStatus.started
          ? 1
          : taskStatus == TaskStatus.pause
          ? 2
          : taskStatus == TaskStatus.resume
          ? 5
          : taskStatus == TaskStatus.completed
          ? 3
          : 0,
      context: event.context,
      pointsCount: routeLength,
    );
    if (res != null) {
      taskData.taskStatus = taskStatus;
      isTaskStatusChange = true;
      isStartPatrolling = true;
      isEndPatrolling =
      (taskStatus == TaskStatus.pause ||
          taskStatus == TaskStatus.started ||
          taskStatus == TaskStatus.resume)
          ? true
          : false;
      BlocProvider.of<TaskBloc>(
        !event.context.mounted ? event.context : event.context,
      ).add(
        TaskPagRefreshDataEvent(
          context: !event.context.mounted ? event.context : event.context,
        ),
      );
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _onStartTracking(StartTracking event, emit) {
    _positionStream?.cancel();
    _positionStream = _mapHelper.getLocationStream(event.context).listen((
      location,
    ) {
      add(NewLocationReceived(location));
    });
  }

  _onStopTracking(StopTracking event, emit) {
    _positionStream?.cancel();
    _positionStream = null;
  }

  _onRestartTracking(RestartTracking event, emit) {
    add(StartTracking(event.context));
  }

  void _onNewLocationReceived(NewLocationReceived event, emit) {
    final LatLng location = event.location;

    // ignore if same as last location
    if (_lastLocation != null &&
        _lastLocation!.latitude == location.latitude &&
        _lastLocation!.longitude == location.longitude) {
      return;
    }
    _lastLocation = location;

    directionList.add(ArcGISPoint(x: location.longitude, y: location.latitude));
    print("Lat : ${location.latitude}");
    print("Long : ${location.longitude}");
    // MapHelper.locationSave();
    _eventComplete(emit);
  }

  _eventComplete(Emitter<MapState> emit) {
    emit(
      FetchMapPageDataState(
        isLoader: isLoader,
        isNavigationBool: isNavigationBool,
        isEndPatrolling: isEndPatrolling,
        isTaskStatusChange: isTaskStatusChange,
        mapList: mapList,
        directionList: directionList,
        taskData: taskData,
        isStartPatrolling: isStartPatrolling,
        markerList: markerList,
        routes: routes,
        locationPath: locationPath,
        isArcGISStreets: isArcGISStreets,
        routePointsList: routePointsList,
      ),
    );
  }
}
