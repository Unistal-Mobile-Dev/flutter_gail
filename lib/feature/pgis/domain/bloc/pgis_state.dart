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
  final bool isArcGISStreets;
  final bool isPipelineDeviceCheck;
  final bool isStructureCheck;
  final bool isPipelineCheck;
  final bool isContinuousCheck;
  final bool isEngineeringCheck;
  final bool isStructureBoundaryCheck;
  final bool isServiceCheck;
  final bool isCadastralCheck;
  final TextEditingController pipelineCtrl;
  final TextEditingController sectionCtrl;
  final TextEditingController stationCtrl;
  final TextEditingController tlpCtrl;
  final List<StructureBoundaryFeature> stationList;
  final ArcGISPoint curPoint;
  final ArcGISPoint desPoint;
  final double distanceKm;
  final double travelTimeMin;

  const FetchPgisDataState({
    required this.isPageLoader,
    required this.isPipelineDeviceCheck,
    required this.isStructureCheck,
    required this.isPipelineCheck,
    required this.isContinuousCheck,
    required this.isEngineeringCheck,
    required this.isStructureBoundaryCheck,
    required this.isServiceCheck,
    required this.isCadastralCheck,

    required this.isArcGISStreets,
    required this.pipelineCtrl,
    required this.sectionCtrl,
    required this.stationCtrl,
    required this.tlpCtrl,
    required this.stationList,
    required this.curPoint,
    required this.desPoint,
    required this.distanceKm,
    required this.travelTimeMin,

  });
  @override
  List<Object> get props => [
    isPageLoader,
    isPipelineDeviceCheck,
    isStructureCheck,
    isPipelineCheck,
    isContinuousCheck,
    isEngineeringCheck,
    isStructureBoundaryCheck,
    isServiceCheck,
    isCadastralCheck,
    isArcGISStreets,
    pipelineCtrl,
    sectionCtrl,
    stationCtrl,
    tlpCtrl,
    stationList,
    curPoint,
    desPoint,
    distanceKm,
    travelTimeMin,

  ];
}