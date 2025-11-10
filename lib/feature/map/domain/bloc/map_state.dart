part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();
}

final class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

final class MapPageLoadState extends MapInitial {}

final class FetchMapPageDataState extends MapInitial {
  final bool isLoader;
  final bool isStartPatrolling;
  final bool isEndPatrolling;
  final bool isNavigationBool;
  final bool isTaskStatusChange;
  final List<MapModel> mapList;
  final List<ArcGISPoint> directionList;
  final TaskModel taskData;
  final List<MarkerModel> markerList;
  final List<List<PointsModel>> routes;
  final bool isArcGISStreets;
  final List<LatLng> locationPath;
  final List<RoutePointsModel> routePointsList;

  FetchMapPageDataState({
   required this.isLoader,
   required this.isStartPatrolling,
   required this.isEndPatrolling,
   required this.isNavigationBool,
   required this.isTaskStatusChange,
   required this.mapList,
   required this.directionList,
   required this.taskData,
   required this.markerList,
   required this.routes,
   required this.isArcGISStreets,
   required this.locationPath,
   required this.routePointsList,
  });

  @override
  List<Object> get props => [
    isLoader,
    isStartPatrolling,
    isEndPatrolling,
    isNavigationBool,
    isTaskStatusChange,
    mapList,
    directionList,
    taskData,
    markerList,
    routes,
    isArcGISStreets,
    locationPath,
    routePointsList,
  ];

}


