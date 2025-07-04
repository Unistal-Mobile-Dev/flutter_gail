part of 'add_tlp_survey_bloc.dart';

sealed class AddTlpSurveyState extends Equatable {
  const AddTlpSurveyState();
}

final class AddTlpSurveyInitial extends AddTlpSurveyState {
  @override
  List<Object> get props => [];
}


final class AddTlpSurveyPageLoadState extends AddTlpSurveyInitial {
  @override
  List<Object> get props => [];
}


final class FetchAddTlpSurveyDataState extends AddTlpSurveyInitial {
  final bool isLoader;
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

  final TextEditingController taskIdController;
  final TextEditingController chainageKMController;
  final TextEditingController locationDetaolController;
  final TextEditingController yearController;

  // PSP Reading (-mV)
  final TextEditingController pspOnController;
  final TextEditingController pspOffController;

  // Casing PSP (-mV)
  final TextEditingController casingPspOnController;
  final TextEditingController casingPspOffController;

  // Integrity of Casing & Carrier Pipe
  final TextEditingController casingIntegrityController;

  // Foreign Pipeline PSP (-mV)
  final TextEditingController foreignPspOnController;
  final TextEditingController foreignPspOffController;

  // AC PSP (At HT Crossing/Parallel) Volts
  final TextEditingController acPspVoltController;

  // IJ Reading (Un-protected Side) (-mV)
  final TextEditingController ijOnController;
  final TextEditingController ijOffController;

  // Integrity of IJ
  final TextEditingController ijIntegrityController;

  // Condition of Surge Diverter
  final TextEditingController surgeDiverterConditionController;

  // PSP Polarisation Coupon (-mV)
  final TextEditingController couponOnController;
  final TextEditingController couponOffController;

  // Current Measurement
  final TextEditingController calibrationController;
  final TextEditingController mvAcrossTerminalController;
  final TextEditingController testStationCurrentController;

  // Polarisation Cell
  final TextEditingController cellConditionController;
  final TextEditingController groundingResistanceController;

  // Other
  final TextEditingController dateOfReadingController;
  final TextEditingController remarksController;
  final TextEditingController acCurrentDischargeController;

  final String allowedTLPType;
  final String allowedTLPCondition;

  FetchAddTlpSurveyDataState({
    required this.isLoader,
    required this.sectionData,
    required this.maintenanceBaseData,
    required this.pipelineData,
    required this.regionData,
    required this.sectionList,
    required this.pipelineList,
    required this.maintenanceBaseList,
    required this.regionList,
    required this.tlpConnectionData,
    required this.tlpConnectionList,
    required this.tlpNumberData,
    required this.tlpNumberList,
    required this.tlpTaskPeriodData,
    required this.tlpTaslPeriodList,
    required this.tlpTypeData,
    required this.tlpTypeLIst,
    required this.pspOnController,
    required this.pspOffController,
    required this.casingPspOnController,
    required this.casingPspOffController,
    required this.casingIntegrityController,
    required this.foreignPspOnController,
    required this.foreignPspOffController,
    required this.acPspVoltController,
    required this.ijOnController,
    required this.ijOffController,
    required this.ijIntegrityController,
    required this.surgeDiverterConditionController,
    required this.couponOnController,
    required this.couponOffController,
    required this.calibrationController,
    required this.mvAcrossTerminalController,
    required this.testStationCurrentController,
    required this.cellConditionController,
    required this.groundingResistanceController,
    required this.dateOfReadingController,
    required this.remarksController,
    required this.taskIdController,
    required this.chainageKMController,
    required this.locationDetaolController,
    required this.yearController,
    required this.allowedTLPType,
    required this.allowedTLPCondition,
    required this.acCurrentDischargeController,
  });

  @override
  List<Object> get props => [
    isLoader,
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
    pspOnController,
    pspOffController,
    casingPspOnController,
    casingPspOffController,
    casingIntegrityController,
    foreignPspOnController,
    foreignPspOffController,
    acPspVoltController,
    ijOnController,
    ijOffController,
    ijIntegrityController,
    surgeDiverterConditionController,
    couponOnController,
    couponOffController,
    calibrationController,
    mvAcrossTerminalController,
    testStationCurrentController,
    cellConditionController,
    groundingResistanceController,
    dateOfReadingController,
    remarksController,
    taskIdController,
    chainageKMController,
    locationDetaolController,
    yearController,
    allowedTLPType,
    allowedTLPCondition,
    acCurrentDischargeController,
  ];
}

