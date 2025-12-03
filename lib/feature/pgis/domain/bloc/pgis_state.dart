part of 'pgis_bloc.dart';

sealed class PgisState extends Equatable {
  const PgisState();
}

class PgisInitial extends PgisState {
  @override
  List<Object> get props => [];
}

class PgisPageLoadingState extends PgisState {
  @override
  List<Object> get props => [];
}

class PgisMapReadyState extends PgisState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchPgisDataState extends PgisState {
  final bool isPageLoader;
  final bool isDetailsLoader;
  final bool isArcGISStreets;
  final bool isNavigating;
  final bool isMuted;
  final String selectedLayerType;
  final TextEditingController fromController;
  final TextEditingController toController;
  final List<dynamic> fromLocationList;
  final List<dynamic> toLocationList;
  final TextEditingController pipelineCtrl;
  final TextEditingController sectionCtrl;
  final TextEditingController stationCtrl;
  final TextEditingController tlpCtrl;

  FetchPgisDataState({
    required this.isPageLoader,
    required this.isDetailsLoader,
    required this.isNavigating,
    required this.isMuted,
    required this.isArcGISStreets,
    required this.selectedLayerType,
    required this.fromController,
    required this.toController,
    required this.fromLocationList,
    required this.toLocationList,
    required this.pipelineCtrl,
    required this.sectionCtrl,
    required this.stationCtrl,
    required this.tlpCtrl,
  });
  @override
  List<Object> get props => [
    isPageLoader,
    isDetailsLoader,
    isNavigating,
    isMuted,
    isArcGISStreets,
    selectedLayerType,
    fromController,
    toController,
    fromLocationList,
    toLocationList,
    pipelineCtrl,
    sectionCtrl,
    stationCtrl,
    tlpCtrl,

  ];
}