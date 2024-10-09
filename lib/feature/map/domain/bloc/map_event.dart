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

class MapRouteDirection extends MapEvent {
  final BuildContext context;
  const MapRouteDirection({required this.context});
  @override
  List<Object?> get props => [context];
}