part of 'psp_monitoring_bloc.dart';

sealed class PspMonitoringState extends Equatable {
  const PspMonitoringState();
}

final class PspMonitoringInitial extends PspMonitoringState {
  @override
  List<Object> get props => [];
}

final class PspMonitoringPageLoadState extends PspMonitoringInitial {
  @override
  List<Object> get props => [];
}

final class FetchPspMonitoringDataState extends PspMonitoringInitial {
  /// Changes on every emit so the form always rebuilds
  final int updateCount;
  final bool isLoader;

  // Loaders
  final bool isMaintenanceBaseLoader;
  final bool isPipelineLoader;
  final bool isSectionLoader;
  final bool isTlpNumberLoader;
  final bool isTaskLoader;
  final bool isFieldLoader;

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

  final List<CpOptionModel> tlpNumberList;
  final CpOptionModel tlpNumberData;

  final List<CpOptionModel> tlpTypeList;
  final CpOptionModel tlpTypeData;

  final List<CpOptionModel> additionalTlpConnectionList;
  final CpOptionModel additionalTlpConnectionData;

  /// Dynamic fields from the `fields` API
  final List<PspFieldModel> fieldList;

  /// Input field (field_type 1) controllers by field slug
  final Map<String, TextEditingController> fieldControllers;

  /// Dropdown field (field_type 3) values by field slug
  final Map<String, CpOptionModel> fieldOptionValues;

  final TextEditingController taskController;
  final TextEditingController chainageController;
  final TextEditingController locationDetailsController;
  final TextEditingController magnesiumAnodeReadingController;
  final TextEditingController dateOfReadingController;
  final TextEditingController remarksController;

  FetchPspMonitoringDataState({
    required this.updateCount,
    required this.isLoader,
    required this.isMaintenanceBaseLoader,
    required this.isPipelineLoader,
    required this.isSectionLoader,
    required this.isTlpNumberLoader,
    required this.isTaskLoader,
    required this.isFieldLoader,
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
    required this.tlpNumberList,
    required this.tlpNumberData,
    required this.tlpTypeList,
    required this.tlpTypeData,
    required this.additionalTlpConnectionList,
    required this.additionalTlpConnectionData,
    required this.fieldList,
    required this.fieldControllers,
    required this.fieldOptionValues,
    required this.taskController,
    required this.chainageController,
    required this.locationDetailsController,
    required this.magnesiumAnodeReadingController,
    required this.dateOfReadingController,
    required this.remarksController,
  });

  @override
  List<Object> get props => [updateCount, isLoader];
}
