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
  final LatLng currentPoint;
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

class SelectMapArcGISStreets extends MapEvent {
  final bool isArcGISStreets;
  const SelectMapArcGISStreets({required this.isArcGISStreets});

  @override
  List<Object?> get props => [
    isArcGISStreets
  ];
}

class StartTracking extends MapEvent {
  final BuildContext context;

  const StartTracking(this.context);

  @override
  List<Object?> get props => [context];
}

class StopTracking extends MapEvent {
  @override
  List<Object?> get props => [];
}

class RestartTracking extends MapEvent {
  final BuildContext context;
  const RestartTracking(this.context);
  @override
  List<Object?> get props => [context];
}

class NewLocationReceived extends MapEvent {
  final LatLng location;

  const NewLocationReceived(this.location);

  @override
  List<Object?> get props => [location];
}
