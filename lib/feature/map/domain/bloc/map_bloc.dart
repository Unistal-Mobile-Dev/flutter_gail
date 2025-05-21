import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/configuration_model.dart';
import 'package:flutter_gail/feature/map/domain/model/coordinates_model.dart';
import 'package:flutter_gail/feature/map/domain/model/google_route_model.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/task/viewTask/helper/task_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  bool isLoader = false;
  List<MapModel> mapList = [];
  MapModel mapData = MapModel();
  List<ArcGISPoint> directionList = [];
  bool isNavigationBool = false;
  List<PointsModel> pointsList = [];
  ArcGISPoint startPoint = ArcGISPoint(x: 0.0, y: 0.0);
  ArcGISPoint endPoint = ArcGISPoint(x: 0.0, y: 0.0);
  PointsModel lastPoint = PointsModel();
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

  MapBloc() : super(MapInitial()) {
    on<MapPageLoadEvent>(_pageLoadEvent);
    on<SelectMapArcGISStreets>(_selectMapType);
    on<MapRouteDirection>(_routeDirection);
    on<MapRouteLocationCheck>(_locationCheck);
    on<MapPageUpdateTaskEvent>(_updateTask);
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
    lastPoint = PointsModel();
    configurationData = ConfigurationModel();
    taskList = BlocProvider.of<TaskBloc>(event.context).searchTaskList;
    taskData = BlocProvider.of<TaskBloc>(event.context).taskData;

    var resConfiguration = await MapHelper.fetchConfiguration();
    if (resConfiguration != null) {
      configurationData = resConfiguration;
    }

    var routeRes = await MapHelper.fetchRoutes(
        routeId: taskData.patrollRouteId.toString());
    if (routeRes != null) {
      mapData = routeRes;
      mapData = routeRes;
      mapData.buffer = configurationData.buffer != null
          ? double.parse(configurationData.buffer.toString())
          : mapData.buffer;
      mapData.timeInterval = configurationData.timeInterval != null
          ? int.parse(configurationData.timeInterval.toString())
          : mapData.timeInterval;
      if (mapData.data != null) {
        for (var data in mapData.data!) {
          List<PointsModel> list = [];
          final geometryData = data.geometry;
          if (geometryData != null) {
            list.addAll(
              geometryData.coordinates.map((coord) => PointsModel(
                    y: coord.latitude,
                    x: coord.longitude,
                    m: 0.0,
                    z: 0.0,
                  )),
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
          y: pointsList[pointsList.length - 1].y);
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
          sectionCode: taskData.sectionCode.toString());
      if (markerRes != null) {
        markerList = markerRes;
      }
    }

    if (mapData.data != null) {
      for (var sectionData in mapData.data!) {
        var routePointRes = await MapHelper.fetchPointsDetails(
            sectionCode: sectionData.sectionCode);
        if (routePointRes != null) {
          routePointsList.add(routePointRes);
        }
      }
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
    DateTime dt2 = DateTime.parse(taskData.assignedDate.toString().isNotEmpty
        ? taskData.assignedDate.toString()
        : DateTime.now().toString());

    final List<TaskModel> tempList = taskList.where((data) {
      return data.taskStatus == TaskStatus.started &&
          taskData.subTaskId != data.subTaskId;
    }).toList();

    if (dt1.compareTo(dt2) < 0) {
      SnackBarErrorWidget(event.context)
          .show(message: "This task are future date");
      return;
    } else if (dt1.compareTo(dt2) > 0) {
      SnackBarErrorWidget(event.context)
          .show(message: "This task are Back date");
      return;
    } else if (tempList.isNotEmpty) {
      SnackBarErrorWidget(event.context).show(
          message:
              "Your already start another task.So please complete first old task then start.");
      return;
    }

    isLoader = true;
    isNavigationBool = true;
    directionList = [];
    _eventComplete(emit);

    var res = await MapHelper.fetchRoute(
        startPoint: event.startPoint, endPoint: event.endPoint);
    if (res != null) {
      directionList = res;
    }

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
      lastPoint = PointsModel(
        x: points.x,
        y: points.y,
      );
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
          currentLocation: points, routes: routes);
      isStartPatrolling = isBufferZone;
      isEndPatrolling = isBufferZone;
      _eventComplete(emit);
    }

    if (taskData.taskStatus == TaskStatus.started) {
      await MapHelper.locationSave(
          context: !context.mounted ? context : context,
          lastPoint: lastPoint,
          currentPoint: points,
          speed: speed,
          verticalAccuracy: verticalAccuracy,
          taskData: taskData);
    }

    lastPoint = PointsModel(
      x: points.x,
      y: points.y,
    );
  }

  _updateTask(MapPageUpdateTaskEvent event, emit) async {
    isLoader = true;
    TaskStatus taskStatus = event.taskStatus;
    _eventComplete(emit);

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime currentDate = formatter.parse(DateTime.now().toString());
    DateTime dt1 = DateTime.parse(currentDate.toString());
    DateTime dt2 = DateTime.parse(taskData.assignedDate.toString().isNotEmpty
        ? taskData.assignedDate.toString()
        : DateTime.now().toString());

    final List<TaskModel> tempList = taskList.where((data) {
      return data.taskStatus == TaskStatus.started &&
          taskData.subTaskId != data.subTaskId;
    }).toList();

    if (dt1.compareTo(dt2) < 0) {
      SnackBarErrorWidget(event.context)
          .show(message: "This task are future date");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (dt1.compareTo(dt2) > 0) {
      SnackBarErrorWidget(event.context)
          .show(message: "This task are Back date");
      isLoader = false;
      _eventComplete(emit);
      return;
    } else if (tempList.isNotEmpty) {
      SnackBarErrorWidget(event.context).show(
          message:
              "Your already start another task.So please complete first old task then start.");
      isLoader = false;
      _eventComplete(emit);
      return;
    }

    var res = await TaskHelper.updateTask(
        taskData: taskData,
        taskStatus: taskStatus == TaskStatus.started
            ? 1
            : taskStatus == TaskStatus.pause
                ? 2
                : taskStatus == TaskStatus.resume
                    ? 5
                    : taskStatus == TaskStatus.completed
                        ? 3
                        : 0,
        context: event.context,
        pointsCount: routeLength);
    if (res != null) {
      taskData.taskStatus = taskStatus;
      isTaskStatusChange = true;
      isStartPatrolling = true;
      isEndPatrolling = (taskStatus == TaskStatus.pause ||
              taskStatus == TaskStatus.started ||
              taskStatus == TaskStatus.resume)
          ? true
          : false;
      BlocProvider.of<TaskBloc>(
              !event.context.mounted ? event.context : event.context)
          .add(TaskPagRefreshDataEvent(
              context: !event.context.mounted ? event.context : event.context));
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<MapState> emit) {
    emit(FetchMapPageDataState(
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
        isArcGISStreets: isArcGISStreets));
  }
}
