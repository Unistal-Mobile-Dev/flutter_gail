part of 'pgis_bloc.dart';

sealed class PgisEvent extends Equatable {
  const PgisEvent();
}

class PgisPageLoadedEvent extends PgisEvent {
  final BuildContext context;
  const PgisPageLoadedEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}

class PGISMapReady extends PgisEvent {
  final ArcGISMapViewController controller;
  const PGISMapReady(this.controller);

  @override
  List<Object?> get props => [controller];
}

class SelectMapArcGISStreets extends PgisEvent {
  final bool isArcGISStreets;
  const SelectMapArcGISStreets({required this.isArcGISStreets});

  @override
  List<Object?> get props => [
    isArcGISStreets
  ];
}
class IdentifyFeaturesAtTapEvent extends PgisEvent {
  final BuildContext context;
  final ArcGISMapViewController controller;
  final Offset offset;

  const IdentifyFeaturesAtTapEvent({
    required this.context,
    required this.controller,
    required this.offset,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [context,controller,offset];
}

class StartNavigationEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  final ArcGISPoint destination;

  const StartNavigationEvent({
    required this.controller,
    required this.destination,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [PgisEvent,destination];
}

class LocationEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const LocationEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props =>[controller];
}

class SearchRoundedEvent extends PgisEvent {
  final BuildContext ctx;
  final ArcGISMapViewController arcGISMapViewController;
  const SearchRoundedEvent({required this.ctx, required this.arcGISMapViewController});
  @override
  // TODO: implement props
  List<Object?> get props =>[ctx,arcGISMapViewController];
}

class MapLayerEvent extends PgisEvent {
  final BuildContext ctx;
  const MapLayerEvent({required this.ctx,});
  @override
  // TODO: implement props
  List<Object?> get props =>[ctx];
}


class SelectPipelineEngRouteEvent extends PgisEvent {
  final String query;
  final BuildContext context;
  final ArcGISMapViewController controller;
  const SelectPipelineEngRouteEvent({required this.query, required this.context, required this.controller});
  @override
  List<Object?> get props => [query, context, controller];
}

class SelectStationEvent extends PgisEvent {
  final String query;
  final BuildContext context;
  final ArcGISMapViewController controller;
  const SelectStationEvent({required this.query, required this.context, required this.controller});
  @override
  List<Object?> get props => [query, context, controller];
}

class SelectTLPEvent extends PgisEvent {
  final String query;
  final BuildContext context;
  final ArcGISMapViewController controller;
  const SelectTLPEvent({required this.query, required this.context, required this.controller});
  @override
  List<Object?> get props => [query, context, controller];
}


class TrackingStatusUpdatedEvent extends PgisEvent {
  final TrackingStatus status;
  final ArcGISMapViewController controller;
  const TrackingStatusUpdatedEvent({required this.status, required this.controller});

  @override
  // TODO: implement props
  List<Object?> get props => [status, controller];
}

class StopNavigationEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const StopNavigationEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}


class SelectLayerTypeEvent extends PgisEvent {
  final String selectedLayerValue;
 const SelectLayerTypeEvent(this.selectedLayerValue);

  @override
  List<Object?> get props => [selectedLayerValue];
}