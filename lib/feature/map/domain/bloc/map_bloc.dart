import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/task/viewTask/helper/task_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  bool isLoader =  false;
  List<MapModel> mapList  = [];
  MapModel mapData =  MapModel();
  List<ArcGISPoint> directionList = [];
  bool isNavigationBool =  false;
  List<PointsModel> pointsList = [];
  ArcGISPoint startPoint = ArcGISPoint(x: 0.0, y: 0.0);
  ArcGISPoint endPoint = ArcGISPoint(x: 0.0, y: 0.0);
  PointsModel lastPoint =  PointsModel();
  bool isStartPatrolling =  false;
  bool isEndPatrolling =  false;
  TaskModel taskData = TaskModel();
  bool isTaskStatusChange =  false;

  MapBloc() : super(MapInitial()) {
    on<MapPageLoadEvent>(_pageLoadEvent);
    on<MapRouteDirection>(_routeDirection);
    on<MapRouteLocationCheck>(_locationCheck);
    on<MapPageUpdateTaskEvent>(_updateTask);
  }

  _pageLoadEvent(MapPageLoadEvent event, emit) async {
    emit(MapPageLoadState());
    isLoader = false;
    isNavigationBool =  false;
    isStartPatrolling =  false;
    isEndPatrolling =  false;
    isTaskStatusChange =  false;
    mapList = [];
    directionList = [];
    lastPoint =  PointsModel();
     taskData = BlocProvider.of<TaskBloc>(event.context).taskData;
     pointsList =  taskData.shapeData!.pointsList!;
    if(pointsList.isNotEmpty){
      startPoint = ArcGISPoint(x: pointsList[0].x, y: pointsList[0].y);
      endPoint = ArcGISPoint(x: pointsList[pointsList.length-1].x, y: pointsList[pointsList.length-1].y);
    } else {
      startPoint = ArcGISPoint(x: 0.0, y: 0.0);
    }

    if(taskData.taskStatus == TaskStatus.started
         || taskData.taskStatus == TaskStatus.pause) {
      isStartPatrolling =  true;
    } else {
      isStartPatrolling =  false;
    }

    _eventComplete(emit);
  }

  _routeDirection(MapRouteDirection event, emit) async {
    isLoader =  true;
    isNavigationBool =  true;
    directionList = [];
    _eventComplete(emit);

    var res =  await MapHelper.fetchRouteDirection(
        startPoint: event.startPoint,
        endPoint: event.endPoint,
        currentPoint: event.currentPoint);
    if(res != null){
      directionList =  res;
    }
    isLoader =  false;
    isNavigationBool =  directionList.isNotEmpty ? true : false;
    _eventComplete(emit);
  }

  _locationCheck(MapRouteLocationCheck event, emit) async {
    ArcGISPoint points =  event.currentPoint;

    if(taskData.taskStatus == TaskStatus.started
        || taskData.taskStatus == TaskStatus.pause) {
      isStartPatrolling =  true;
    } else {
      isStartPatrolling =  false;
    }

    if(isStartPatrolling == false){
      double calculateDistance = MapHelper.calculateDistance(
          startPoint.y, startPoint.x, points.y, points.x) * 1000;
      if(calculateDistance < 80){
        isStartPatrolling = true;
        _eventComplete(emit);
      } else {
        isStartPatrolling = false;
        _eventComplete(emit);
      }
    }

    if(isStartPatrolling == true && isEndPatrolling == false) {
      double calculateDistance = MapHelper.calculateDistance(
          endPoint.y, endPoint.x, points.y, points.x) * 1000;
      if(calculateDistance < 80){
        isEndPatrolling = true;
        _eventComplete(emit);
      } else {
        isEndPatrolling = false;
        _eventComplete(emit);
      }
    }

    if(taskData.taskStatus == TaskStatus.started){
      lastPoint =  PointsModel(
        x: points.x,
        y: points.y,
      );
      await MapHelper.locationSave(lastPoint: lastPoint, currentPoint: points);
    }
  }

  _updateTask(MapPageUpdateTaskEvent event, emit) async {
    isLoader =  true;
    TaskStatus taskStatus = event.taskStatus;
    _eventComplete(emit);
    var res =  await TaskHelper.updateTask(
        taskData: taskData,
        taskStatus: taskStatus == TaskStatus.started ? 1
            : taskStatus == TaskStatus.pause ? 2
            : taskStatus == TaskStatus.completed ? 3 : 0,
        context: event.context);
    if(res != null){
      taskData.taskStatus =  taskStatus;
      isTaskStatusChange =  true;
    }
    isLoader =  false;
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
    ));
  }

}
