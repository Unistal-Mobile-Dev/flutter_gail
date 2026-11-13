part of 'cp_unit_monitoring_bloc.dart';

sealed class CpUnitMonitoringState extends Equatable {
  const CpUnitMonitoringState();
}

final class CpUnitMonitoringInitial extends CpUnitMonitoringState {
  @override
  List<Object> get props => [];
}

final class CpUnitMonitoringPageLoadState extends CpUnitMonitoringInitial {
  @override
  List<Object> get props => [];
}

final class FetchCpUnitMonitoringDataState extends CpUnitMonitoringInitial {
  /// Changes on every emit so the form always rebuilds
  final int updateCount;
  final bool isLoader;

  // Dropdown loaders
  final bool isMaintenanceBaseLoader;
  final bool isPipelineLoader;
  final bool isSectionLoader;
  final bool isRectifierLoader;
  final bool isTaskIdLoader;

  final List<CpOptionModel> regionList;
  final CpOptionModel regionData;

  final List<CpOptionModel> maintenanceBaseList;
  final CpOptionModel maintenanceBaseData;

  final List<CpOptionModel> pipelineList;
  final CpOptionModel pipelineData;

  final List<CpOptionModel> sectionList;
  final CpOptionModel sectionData;

  final List<CpOptionModel> yearList;
  final CpOptionModel yearData;

  final List<CpOptionModel> monthList;
  final CpOptionModel monthData;

  final List<CpOptionModel> rectifierList;
  final CpOptionModel rectifierData;

  final List<CpOptionModel> operatingModeList;
  final CpOptionModel operatingModeData;

  final List<CpOptionModel> onOffStatusList;
  final CpOptionModel onOffStatusData;

  final List<CpOptionModel> rectifierHealthList;
  final CpOptionModel rectifierHealthData;

  final TextEditingController taskIdController;
  final TextEditingController chainageController;
  final TextEditingController inspectedByController;
  final TextEditingController inspectionDateController;
  final TextEditingController pspController;
  final TextEditingController acVoltageInController;
  final TextEditingController acCurrentInController;
  final TextEditingController dcCurrentOutController;
  final TextEditingController targetInternalPspController;
  final TextEditingController pspReferenceCell1Controller;
  final TextEditingController pspReferenceCell2Controller;
  final TextEditingController pspReferenceCell3Controller;
  final TextEditingController controllingReferenceCellController;
  final TextEditingController pspNearestController;
  final TextEditingController powerAvailabilityController;
  final TextEditingController remarksController;

  FetchCpUnitMonitoringDataState({
    required this.updateCount,
    required this.isLoader,
    required this.isMaintenanceBaseLoader,
    required this.isPipelineLoader,
    required this.isSectionLoader,
    required this.isRectifierLoader,
    required this.isTaskIdLoader,
    required this.regionList,
    required this.regionData,
    required this.maintenanceBaseList,
    required this.maintenanceBaseData,
    required this.pipelineList,
    required this.pipelineData,
    required this.sectionList,
    required this.sectionData,
    required this.yearList,
    required this.yearData,
    required this.monthList,
    required this.monthData,
    required this.rectifierList,
    required this.rectifierData,
    required this.operatingModeList,
    required this.operatingModeData,
    required this.onOffStatusList,
    required this.onOffStatusData,
    required this.rectifierHealthList,
    required this.rectifierHealthData,
    required this.taskIdController,
    required this.chainageController,
    required this.inspectedByController,
    required this.inspectionDateController,
    required this.pspController,
    required this.acVoltageInController,
    required this.acCurrentInController,
    required this.dcCurrentOutController,
    required this.targetInternalPspController,
    required this.pspReferenceCell1Controller,
    required this.pspReferenceCell2Controller,
    required this.pspReferenceCell3Controller,
    required this.controllingReferenceCellController,
    required this.pspNearestController,
    required this.powerAvailabilityController,
    required this.remarksController,
  });

  @override
  List<Object> get props => [updateCount, isLoader];
}
