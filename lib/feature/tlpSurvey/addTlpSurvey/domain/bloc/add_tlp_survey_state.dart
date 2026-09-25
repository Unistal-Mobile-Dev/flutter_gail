part of 'add_tlp_survey_bloc.dart';

sealed class AddTlpSurveyState extends Equatable {
  const AddTlpSurveyState();
}

final class AddTlpSurveyInitial extends AddTlpSurveyState {
  @override
  List<Object> get props => [];
}

final class AddTlpSurveyPageLoadState extends AddTlpSurveyState {
  @override
  List<Object?> get props => [];
}

final class FetchAddTlpSurveyDataState extends AddTlpSurveyState {
  final bool isLoader;
  final bool isQrDataLoaded;
  final bool isAutoFilling; // ✅ NEW: Track auto-fill progress

  final List<RegionTypeModel> regionList;
  final RegionTypeModel regionData;

  final List<MaintenanceTypeModel> maintenanceBaseList;
  final MaintenanceTypeModel maintenanceBaseData;

  final List<PipelineModel> pipelineList;
  final PipelineModel pipelineData;

  final List<SectionModel> sectionList;
  final SectionModel sectionData;

  final List<TlpTaskPeriodModel> tlpTaslPeriodList;
  final TlpTaskPeriodModel tlpTaskPeriodData;

  final List<TlpNumberModel> tlpNumberList;
  final TlpNumberModel tlpNumberData;

  final List<TlpTypeModel> tlpTypeLIst;
  final TlpTypeModel tlpTypeData;

  final List<TlpConnectionModel> tlpConnectionList;
  final TlpConnectionModel tlpConnectionData;

  final List<TlpConnectionModel> tlpConnection1List;
  final TlpConnectionModel tlpConnection1Data;

  final TextEditingController taskIdController;
  final TextEditingController chainageKMController;
  final TextEditingController locationDetaolController;
  final TextEditingController yearController;

  final TextEditingController sectionCodeController;

  final TextEditingController pspOnController;
  final TextEditingController pspOffController;

  final TextEditingController casingPspOnController;
  final TextEditingController casingPspOffController;

  final TextEditingController casingIntegrityController;

  final TextEditingController foreignPspOnController;
  final TextEditingController foreignPspOffController;

  final TextEditingController dcInterferenceController;

  final TextEditingController acPspVoltController;

  final TextEditingController acceptableAcPspVoltController;

  final TextEditingController soilResistivityController;

  final TextEditingController ijOnController;
  final TextEditingController ijOffController;

  final TextEditingController ijIntegrityController;

  final TextEditingController surgeDiverterConditionController;

  final TextEditingController couponDcCurrentDensityController;
  final TextEditingController couponAcCurrentDensityController;

  final TextEditingController couponOnController;
  final TextEditingController couponOffController;

  final TextEditingController calibrationController;
  final TextEditingController mvAcrossTerminalController;
  final TextEditingController testStationCurrentController;

  final TextEditingController cellConditionController;
  final TextEditingController groundingResistanceController;

  final TextEditingController dateOfReadingController;
  final TextEditingController remarksController;
  final TextEditingController acCurrentDischargeController;

  final TextEditingController remarks2Controller;

  final String allowedTLPType;
  final String allowedTLPCondition;

  const FetchAddTlpSurveyDataState({
    required this.isLoader,
    this.isQrDataLoaded = false,
    this.isAutoFilling = false, // ✅ ADD THIS
    required this.regionList,
    required this.regionData,
    required this.maintenanceBaseList,
    required this.maintenanceBaseData,
    required this.pipelineList,
    required this.pipelineData,
    required this.sectionList,
    required this.sectionData,
    required this.tlpTaslPeriodList,
    required this.tlpTaskPeriodData,
    required this.tlpNumberList,
    required this.tlpNumberData,
    required this.tlpTypeLIst,
    required this.tlpTypeData,
    required this.tlpConnectionList,
    required this.tlpConnectionData,
    required this.tlpConnection1List,
    required this.tlpConnection1Data,
    required this.taskIdController,
    required this.chainageKMController,
    required this.locationDetaolController,
    required this.yearController,
    required this.sectionCodeController,
    required this.pspOnController,
    required this.pspOffController,
    required this.casingPspOnController,
    required this.casingPspOffController,
    required this.casingIntegrityController,
    required this.foreignPspOnController,
    required this.foreignPspOffController,
    required this.dcInterferenceController,
    required this.acPspVoltController,
    required this.acceptableAcPspVoltController,
    required this.soilResistivityController,
    required this.ijOnController,
    required this.ijOffController,
    required this.ijIntegrityController,
    required this.surgeDiverterConditionController,
    required this.couponDcCurrentDensityController,
    required this.couponAcCurrentDensityController,
    required this.couponOnController,
    required this.couponOffController,
    required this.calibrationController,
    required this.mvAcrossTerminalController,
    required this.testStationCurrentController,
    required this.cellConditionController,
    required this.groundingResistanceController,
    required this.dateOfReadingController,
    required this.remarksController,
    required this.acCurrentDischargeController,
    required this.remarks2Controller,
    required this.allowedTLPType,
    required this.allowedTLPCondition,
  });

  @override
  List<Object?> get props => [
    isLoader,
    isQrDataLoaded,
    isAutoFilling, // ✅ ADD THIS
    regionList,
    regionData,
    maintenanceBaseList,
    maintenanceBaseData,
    pipelineList,
    pipelineData,
    sectionList,
    sectionData,
    tlpTaslPeriodList,
    tlpTaskPeriodData,
    tlpNumberList,
    tlpNumberData,
    tlpTypeLIst,
    tlpTypeData,
    tlpConnectionList,
    tlpConnectionData,
    tlpConnection1List,
    tlpConnection1Data,
    taskIdController,
    chainageKMController,
    locationDetaolController,
    yearController,
    sectionCodeController,
    pspOnController,
    pspOffController,
    casingPspOnController,
    casingPspOffController,
    casingIntegrityController,
    foreignPspOnController,
    foreignPspOffController,
    dcInterferenceController,
    acPspVoltController,
    acceptableAcPspVoltController,
    soilResistivityController,
    ijOnController,
    ijOffController,
    ijIntegrityController,
    surgeDiverterConditionController,
    couponDcCurrentDensityController,
    couponAcCurrentDensityController,
    couponOnController,
    couponOffController,
    calibrationController,
    mvAcrossTerminalController,
    testStationCurrentController,
    cellConditionController,
    groundingResistanceController,
    dateOfReadingController,
    remarksController,
    acCurrentDischargeController,
    remarks2Controller,
    allowedTLPType,
    allowedTLPCondition,
  ];
}