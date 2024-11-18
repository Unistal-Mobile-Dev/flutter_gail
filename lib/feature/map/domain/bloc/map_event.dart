part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();
}

class MapPageLoadEvent extends MapEvent {
  final BuildContext context;
  const MapPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class MapPageUpdateTaskEvent extends MapEvent {
  final BuildContext context;
  final TaskStatus taskStatus;
  const MapPageUpdateTaskEvent({required this.context, required this.taskStatus});
  @override
  List<Object?> get props => [context, taskStatus];
}

class MapRouteLocationCheck extends MapEvent {
  final BuildContext context;
  final ArcGISPoint currentPoint;
  final double speed;
  final double verticalAccuracy;

  const MapRouteLocationCheck({
    required this.context,
    required this.currentPoint,
    required this.speed,
    required this.verticalAccuracy,
  });

  @override
  List<Object?> get props => [
    context,
    currentPoint,
    speed,
    verticalAccuracy,
  ];
}

class MapRouteDirection extends MapEvent {
  final BuildContext context;
  final ArcGISPoint startPoint;
  final ArcGISPoint endPoint;
  final ArcGISPoint currentPoint;

  const MapRouteDirection({
    required this.context,
    required this.endPoint,
    required this.startPoint,
    required this.currentPoint
  });

  @override
  List<Object?> get props => [
    context,
    endPoint,
    startPoint,
    currentPoint,
  ];
}