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
  final ArcGISMapViewController controller;

  const SelectMapArcGISStreets({
    required this.isArcGISStreets,
    required this.controller,
  });

  @override
  List<Object?> get props => [
    isArcGISStreets,
    controller,
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
  final ArcGISMapViewController controller;
  final BuildContext ctx;
  const MapLayerEvent({required this.ctx, required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props =>[ctx, controller];
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




class StopNavigationEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const StopNavigationEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}


class TogglePipelineDeviceEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const TogglePipelineDeviceEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleStructureEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleStructureEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class TogglePipelineEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const TogglePipelineEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleContinuousEvent extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleContinuousEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleEngineeringEvent  extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleEngineeringEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleStructureBoundaryEvent  extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleStructureBoundaryEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleServiceEvent  extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleServiceEvent({required this.controller});
  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ToggleCadastralEvent  extends PgisEvent {
  final ArcGISMapViewController controller;
  const ToggleCadastralEvent({required this.controller,});
  @override
  // TODO: implement props
  List<Object?> get props => [controller,];
}

class ResetPipelineEvent extends PgisEvent {
  final ArcGISMapViewController controller;

  const ResetPipelineEvent({required this.controller});

  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ResetStationEvent extends PgisEvent {
  final ArcGISMapViewController controller;

  const ResetStationEvent({required this.controller});

  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}

class ResetTLPEvent extends PgisEvent {
  final ArcGISMapViewController controller;

 const ResetTLPEvent({required this.controller});

  @override
  // TODO: implement props
  List<Object?> get props => [controller];
}
