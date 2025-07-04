import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/maintenance_base_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/maintenance_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/section_model.dart';
import 'package:flutter_gail/feature/task/createTask/helper/create_task_helper.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_connection_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_number_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_task_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_task_period_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_type_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/helper/add_tlp_survey_helper.dart';

part 'add_tlp_survey_event.dart';

part 'add_tlp_survey_state.dart';

class AddTlpSurveyBloc extends Bloc<AddTlpSurveyEvent, AddTlpSurveyState> {
  bool isLoader = false;

  List<RegionTypeModel> regionList = [];
  RegionTypeModel regionData = RegionTypeModel();

  List<MaintenanceTypeModel> maintenanceBaseList = [];
  MaintenanceTypeModel maintenanceBaseData = MaintenanceTypeModel();

  List<PipelineModel> pipelineList = [];
  PipelineModel pipelineData = PipelineModel();

  List<SectionModel> sectionList = [];
  SectionModel sectionData = SectionModel();

  List<TlpTaskPeriodModel> tlpTaslPeriodList = [];
  TlpTaskPeriodModel tlpTaskPeriodData = TlpTaskPeriodModel();

  List<TlpNumberModel> tlpNumberList = [];
  TlpNumberModel tlpNumberData = TlpNumberModel();

  List<TlpTypeModel> tlpTypeLIst = [];
  TlpTypeModel tlpTypeData = TlpTypeModel();

  List<TlpConnectionModel> tlpConnectionList = [];
  TlpConnectionModel tlpConnectionData = TlpConnectionModel();

  TextEditingController taskIdController = TextEditingController();
  TextEditingController chainageKMController = TextEditingController();
  TextEditingController locationDetaolController = TextEditingController();
  TextEditingController yearController = TextEditingController();

// PSP Reading (-mV)
  TextEditingController pspOnController = TextEditingController();
  TextEditingController pspOffController = TextEditingController();

// Casing PSP (-mV)
  TextEditingController casingPspOnController = TextEditingController();
  TextEditingController casingPspOffController = TextEditingController();

// Integrity of Casing & Carrier Pipe
  TextEditingController casingIntegrityController = TextEditingController();

// Foreign Pipeline PSP (-mV)
  TextEditingController foreignPspOnController = TextEditingController();
  TextEditingController foreignPspOffController = TextEditingController();

// AC PSP (At HT Crossing/Parallel) Volts
  TextEditingController acPspVoltController = TextEditingController();

// IJ Reading (Un-protected Side) (-mV)
  TextEditingController ijOnController = TextEditingController();
  TextEditingController ijOffController = TextEditingController();

// Integrity of IJ
  TextEditingController ijIntegrityController = TextEditingController();

// Condition of Surge Diverter
  TextEditingController surgeDiverterConditionController =
  TextEditingController();

// PSP Polarisation Coupon (-mV)
  TextEditingController couponOnController = TextEditingController();
  TextEditingController couponOffController = TextEditingController();

// Current Measurement
  TextEditingController calibrationController = TextEditingController();
  TextEditingController mvAcrossTerminalController = TextEditingController();
  TextEditingController testStationCurrentController = TextEditingController();

// Polarisation Cell
  TextEditingController cellConditionController = TextEditingController();
  TextEditingController groundingResistanceController = TextEditingController();

// Other
  TextEditingController dateOfReadingController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController acCurrentDischargeController = TextEditingController();

  TlpTaskModel tlpTaskData = TlpTaskModel();

  String allowedTLPType = "";
  String allowedTLPCondition = "";

  AddTlpSurveyBloc() : super(AddTlpSurveyInitial()) {
    on<AddTlpSurveyPageLoadEvent>(_pageLoad);
    on<SelectRegionEvent>(_selectRegion);
    on<SelectMaintenanceBaseEvent>(_selectMaintenanceBase);
    on<SelectPipelineEvent>(_selectPipeline);
    on<SelectSectionEvent>(_selectSection);
    on<SelectTlpTaskPeriodEvent>(_selectTlpTaskPeriod);
    on<SelectTlpNumberEvent>(_selectTlpNumber);
    on<SelectTlpTypeEvent>(_selectTlpType);
    on<SelectTlpConnectionEvent>(_selectTlpConnection);
    on<SelectYearEvent>(_selectYear);
    on<SelectDateReadingEvent>(_selectDateReading);
    on<SubmitTlpEvent>(_submit);
  }

  _pageLoad(AddTlpSurveyPageLoadEvent event, emit) async {
    emit(AddTlpSurveyPageLoadState());

    // Region
    regionList = [];
    regionData = RegionTypeModel();

    // Maintenance Base
    maintenanceBaseList = [];
    maintenanceBaseData = MaintenanceTypeModel();

    // Pipeline
    pipelineList = [];
    pipelineData = PipelineModel();

    // Section
    sectionList = [];
    sectionData = SectionModel();

    // Task Period
    tlpTaslPeriodList = [];
    tlpTaskPeriodData = TlpTaskPeriodModel();

    // TLP Number
    tlpNumberList = [];
    tlpNumberData = TlpNumberModel();

    // TLP Type
    tlpTypeLIst = [];
    tlpTypeData = TlpTypeModel();

    // TLP Connection
    tlpConnectionList = [];
    tlpConnectionData = TlpConnectionModel();

    taskIdController = TextEditingController();
    chainageKMController = TextEditingController();
    locationDetaolController = TextEditingController();
    yearController = TextEditingController();

    // PSP Reading (-mV)
    pspOnController = TextEditingController();
    pspOffController = TextEditingController();

    // Casing PSP (-mV)
    casingPspOnController = TextEditingController();
    casingPspOffController = TextEditingController();

    // Integrity of Casing & Carrier Pipe
    casingIntegrityController = TextEditingController();

    // Foreign Pipeline PSP (-mV)
    foreignPspOnController = TextEditingController();
    foreignPspOffController = TextEditingController();

    // AC PSP (At HT Crossing/Parallel) Volts
    acPspVoltController = TextEditingController();

    // IJ Reading (Un-protected Side) (-mV)
    ijOnController = TextEditingController();
    ijOffController = TextEditingController();

    // Integrity of IJ
    ijIntegrityController = TextEditingController();

    // Condition of Surge Diverter
    surgeDiverterConditionController = TextEditingController();

    // PSP Polarisation Coupon (-mV)
    couponOnController = TextEditingController();
    couponOffController = TextEditingController();

    // Current Measurement
    calibrationController = TextEditingController();
    mvAcrossTerminalController = TextEditingController();
    testStationCurrentController = TextEditingController();

    // Polarisation Cell
    cellConditionController = TextEditingController();
    groundingResistanceController = TextEditingController();

    // Other
    dateOfReadingController = TextEditingController();
    remarksController = TextEditingController();
    acCurrentDischargeController = TextEditingController();

    var resRegion = await AddTLPSurveyHelper.fetchArea();
    if (resRegion != null) {
      regionList = resRegion;
    }

    tlpTaslPeriodList = TlpTaskPeriodModel().getData(DateTime
        .now()
        .year);

    tlpTypeLIst = TlpTypeModel().getData();
    tlpTaskData = TlpTaskModel();
    allowedTLPType = "A";
    allowedTLPCondition = "A";
    _eventCompleted(emit);
  }

  void _selectRegion(SelectRegionEvent event, emit) async {
    regionData = event.regionData;
    maintenanceBaseList = [];
    maintenanceBaseData = MaintenanceTypeModel();
    pipelineData = PipelineModel();
    sectionData = SectionModel();
    pipelineList = [];
    sectionList = [];
    _eventCompleted(emit);
    var res = await AddTLPSurveyHelper.fetchMaintenance(regionData: regionData);
    if (res != null) {
      maintenanceBaseList = res;
    }
    _eventCompleted(emit);
  }

  void _selectMaintenanceBase(SelectMaintenanceBaseEvent event, emit) async {
    maintenanceBaseData = event.maintenanceBaseData;
    pipelineList = [];
    sectionList = [];
    pipelineData = PipelineModel();
    sectionData = SectionModel();
    _eventCompleted(emit);
    var res = await AddTLPSurveyHelper.fetchPipeline(
        regionData: regionData, maintenanceTypeData: maintenanceBaseData);
    if (res != null) {
      pipelineList = res;
    }
    _eventCompleted(emit);
  }

  void _selectPipeline(SelectPipelineEvent event, emit) async {
    pipelineData = event.pipelineData;
    sectionList = [];
    sectionData = SectionModel();
    _eventCompleted(emit);
    var res = await AddTLPSurveyHelper.fetchSection(
        regionData: regionData,
        maintenanceTypeData: maintenanceBaseData,
        pipelineData: pipelineData);
    if (res != null) {
      sectionList = res;
    }
    _eventCompleted(emit);
  }

  void _selectSection(SelectSectionEvent event, emit) {
    sectionData = event.sectionData;
    _eventCompleted(emit);
  }

  void _selectTlpTaskPeriod(SelectTlpTaskPeriodEvent event, emit) async {
    tlpTaskPeriodData = event.tlpTaskPeriodData;
    tlpTaskData = TlpTaskModel();
    taskIdController = TextEditingController();
    tlpNumberList = [];
    tlpNumberData = TlpNumberModel();
    chainageKMController = TextEditingController();
    locationDetaolController = TextEditingController();
    _eventCompleted(emit);
    var res = await AddTLPSurveyHelper.fetchTaskData(
        startDate: tlpTaskPeriodData.startDate.toString(),
        endDate: tlpTaskPeriodData.endData.toString(),
        sectionData: sectionData);
    if (res != null) {
      List<TlpTaskModel> list = res;
      if (list.isNotEmpty) {
        tlpTaskData = list[0];
        tlpNumberList = tlpTaskData.tlpNumberList!;
        taskIdController.text = tlpTaskData.currentTaskId.toString();
        taskIdController.text = tlpTaskData.currentTaskId.toString();
      }
    }
    _eventCompleted(emit);
  }

  void _selectTlpNumber(SelectTlpNumberEvent event, emit) {
    tlpNumberData = event.tlpNumberData;
    chainageKMController.text = tlpNumberData.engm.toString();
    locationDetaolController.text =
        tlpNumberData.locationDescription.toString();
    _eventCompleted(emit);
  }

  void _selectTlpType(SelectTlpTypeEvent event, emit) {
    tlpTypeData = event.tlpTypeData;
    tlpConnectionData = TlpConnectionModel();
    allowedTLPType = tlpTypeData.name.toString();
    if (allowedTLPType == "A" ||
        allowedTLPType == "E" ||
        allowedTLPType == "F" ||
        allowedTLPType == "I" ||
        allowedTLPType == "J" ||
        allowedTLPType == "L" && allowedTLPType == "M" &&
            allowedTLPType == "N" ||
        allowedTLPType == "O" ||
        allowedTLPType == "Q") {
      tlpConnectionList = TlpConnectionModel().getShortData();
    } else {
      tlpConnectionList = TlpConnectionModel().getFullData();
    }

    // PSP Reading (-mV)
    pspOnController = TextEditingController();
    pspOffController = TextEditingController();

    // Casing PSP (-mV)
    casingPspOnController = TextEditingController();
    casingPspOffController = TextEditingController();

    // Integrity of Casing & Carrier Pipe
    casingIntegrityController = TextEditingController();

    // Foreign Pipeline PSP (-mV)
    foreignPspOnController = TextEditingController();
    foreignPspOffController = TextEditingController();

    // AC PSP (At HT Crossing/Parallel) Volts
    acPspVoltController = TextEditingController();

    // IJ Reading (Un-protected Side) (-mV)
    ijOnController = TextEditingController();
    ijOffController = TextEditingController();

    // Integrity of IJ
    ijIntegrityController = TextEditingController();

    // Condition of Surge Diverter
    surgeDiverterConditionController = TextEditingController();

    // PSP Polarisation Coupon (-mV)
    couponOnController = TextEditingController();
    couponOffController = TextEditingController();

    // Current Measurement
    calibrationController = TextEditingController();
    mvAcrossTerminalController = TextEditingController();
    testStationCurrentController = TextEditingController();

    // Polarisation Cell
    cellConditionController = TextEditingController();
    groundingResistanceController = TextEditingController();

    // Other
    dateOfReadingController = TextEditingController();
    remarksController = TextEditingController();
    acCurrentDischargeController = TextEditingController();

    _eventCompleted(emit);
  }

  void _selectTlpConnection(SelectTlpConnectionEvent event, emit) {
    tlpConnectionData = event.tlpConnectionData;
    allowedTLPCondition = tlpConnectionData.name.toString();

    // PSP Reading (-mV)
    pspOnController = TextEditingController();
    pspOffController = TextEditingController();

    // Casing PSP (-mV)
    casingPspOnController = TextEditingController();
    casingPspOffController = TextEditingController();

    // Integrity of Casing & Carrier Pipe
    casingIntegrityController = TextEditingController();

    // Foreign Pipeline PSP (-mV)
    foreignPspOnController = TextEditingController();
    foreignPspOffController = TextEditingController();

    // AC PSP (At HT Crossing/Parallel) Volts
    acPspVoltController = TextEditingController();

    // IJ Reading (Un-protected Side) (-mV)
    ijOnController = TextEditingController();
    ijOffController = TextEditingController();

    // Integrity of IJ
    ijIntegrityController = TextEditingController();

    // Condition of Surge Diverter
    surgeDiverterConditionController = TextEditingController();

    // PSP Polarisation Coupon (-mV)
    couponOnController = TextEditingController();
    couponOffController = TextEditingController();

    // Current Measurement
    calibrationController = TextEditingController();
    mvAcrossTerminalController = TextEditingController();
    testStationCurrentController = TextEditingController();

    // Polarisation Cell
    cellConditionController = TextEditingController();
    groundingResistanceController = TextEditingController();

    // Other
    dateOfReadingController = TextEditingController();
    remarksController = TextEditingController();
    acCurrentDischargeController = TextEditingController();
    _eventCompleted(emit);
  }

  void _selectYear(SelectYearEvent event, emit) async {
    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime
          .now()
          .year + 10),
      helpText: "Select Year",
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      // Set only the year as text
      yearController.text = selectedDate.year.toString();
      tlpTaskPeriodData = TlpTaskPeriodModel();
      tlpTaslPeriodList = TlpTaskPeriodModel().getData(selectedDate.year);
      _eventCompleted(emit);
    }
  }

  void _selectDateReading(SelectDateReadingEvent event, emit) async {
    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10),
      helpText: "Select Date of Reading",
    );

    if (selectedDate != null) {
      // Format for backend submission (yyyy-MM-dd)
      final DateFormat apiFormat = DateFormat('yyyy-MM-dd');
      final formattedApiDate = apiFormat.format(selectedDate);

      // Format for display (dd-MM-yyyy)
      final DateFormat displayFormat = DateFormat('dd-MM-yyyy');
      final formattedDisplayDate = displayFormat.format(selectedDate);

      // Assign to controller
      dateOfReadingController.text = formattedApiDate;
      _eventCompleted(emit);
    }

  }

  void _submit(SubmitTlpEvent event, emit) async{
    BuildContext context = event.context;
    isLoader =  true;
    _eventCompleted(emit);
    var textFiledValidation = await AddTLPSurveyHelper.textFieldValidation(
        context: context,
        regionData: regionData,
        maintenanceBaseData: maintenanceBaseData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        tlpTaskPeriodData: tlpTaskPeriodData,
        tlpNumberData: tlpNumberData,
        tlpTypeData: tlpTypeData,
        tlpConnectionData: tlpConnectionData,
        pspOnController: pspOnController,
        pspOffController: pspOffController,
        casingPspOnController: casingPspOnController,
        casingPspOffController: casingPspOffController,
        casingIntegrityController: casingIntegrityController,
        foreignPspOnController: foreignPspOnController,
        foreignPspOffController: foreignPspOffController,
        acPspVoltController: acPspVoltController,
        ijOnController: ijOnController,
        ijOffController: ijOffController,
        ijIntegrityController: ijIntegrityController,
        surgeDiverterConditionController: surgeDiverterConditionController,
        couponOnController: couponOnController,
        couponOffController: couponOffController,
        calibrationController: calibrationController,
        mvAcrossTerminalController: mvAcrossTerminalController,
        testStationCurrentController: testStationCurrentController,
        cellConditionController: cellConditionController,
        groundingResistanceController: groundingResistanceController,
        dateOfReadingController: dateOfReadingController,
        remarksController: remarksController,
        allowedTLPType: allowedTLPType,
        acCurrentDischargeController: acCurrentDischargeController,
        allowedTLPCondition: allowedTLPCondition);

    if(textFiledValidation == false){
      isLoader =  false;
      _eventCompleted(emit);
    }

    var res = await AddTLPSurveyHelper.submit(
        context: !context.mounted ? context : context,
        regionData: regionData,
        maintenanceBaseData: maintenanceBaseData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        tlpTaskPeriodData: tlpTaskPeriodData,
        tlpNumberData: tlpNumberData,
        tlpTypeData: tlpTypeData,
        tlpConnectionData: tlpConnectionData,
        pspOnController: pspOnController,
        pspOffController: pspOffController,
        casingPspOnController: casingPspOnController,
        casingPspOffController: casingPspOffController,
        casingIntegrityController: casingIntegrityController,
        foreignPspOnController: foreignPspOnController,
        foreignPspOffController: foreignPspOffController,
        acPspVoltController: acPspVoltController,
        ijOnController: ijOnController,
        ijOffController: ijOffController,
        ijIntegrityController: ijIntegrityController,
        surgeDiverterConditionController: surgeDiverterConditionController,
        couponOnController: couponOnController,
        couponOffController: couponOffController,
        calibrationController: calibrationController,
        mvAcrossTerminalController: mvAcrossTerminalController,
        testStationCurrentController: testStationCurrentController,
        cellConditionController: cellConditionController,
        groundingResistanceController: groundingResistanceController,
        dateOfReadingController: dateOfReadingController,
        remarksController: remarksController,
        allowedTLPType: allowedTLPType,
        taskIdController: taskIdController,
        acCurrentDischargeController: acCurrentDischargeController,
        allowedTLPCondition: allowedTLPCondition);
    if(res != null){
      // Region
      regionList = [];
      regionData = RegionTypeModel();

      // Maintenance Base
      maintenanceBaseList = [];
      maintenanceBaseData = MaintenanceTypeModel();

      // Pipeline
      pipelineList = [];
      pipelineData = PipelineModel();

      // Section
      sectionList = [];
      sectionData = SectionModel();

      // Task Period
      tlpTaslPeriodList = [];
      tlpTaskPeriodData = TlpTaskPeriodModel();

      // TLP Number
      tlpNumberList = [];
      tlpNumberData = TlpNumberModel();

      // TLP Type
      tlpTypeLIst = [];
      tlpTypeData = TlpTypeModel();

      // TLP Connection
      tlpConnectionList = [];
      tlpConnectionData = TlpConnectionModel();

      taskIdController = TextEditingController();
      chainageKMController = TextEditingController();
      locationDetaolController = TextEditingController();
      yearController = TextEditingController();

      // PSP Reading (-mV)
      pspOnController = TextEditingController();
      pspOffController = TextEditingController();

      // Casing PSP (-mV)
      casingPspOnController = TextEditingController();
      casingPspOffController = TextEditingController();

      // Integrity of Casing & Carrier Pipe
      casingIntegrityController = TextEditingController();

      // Foreign Pipeline PSP (-mV)
      foreignPspOnController = TextEditingController();
      foreignPspOffController = TextEditingController();

      // AC PSP (At HT Crossing/Parallel) Volts
      acPspVoltController = TextEditingController();

      // IJ Reading (Un-protected Side) (-mV)
      ijOnController = TextEditingController();
      ijOffController = TextEditingController();

      // Integrity of IJ
      ijIntegrityController = TextEditingController();

      // Condition of Surge Diverter
      surgeDiverterConditionController = TextEditingController();

      // PSP Polarisation Coupon (-mV)
      couponOnController = TextEditingController();
      couponOffController = TextEditingController();

      // Current Measurement
      calibrationController = TextEditingController();
      mvAcrossTerminalController = TextEditingController();
      testStationCurrentController = TextEditingController();

      // Polarisation Cell
      cellConditionController = TextEditingController();
      groundingResistanceController = TextEditingController();

      // Other
      dateOfReadingController = TextEditingController();
      remarksController = TextEditingController();
      acCurrentDischargeController = TextEditingController();

      var resRegion = await AddTLPSurveyHelper.fetchArea();
      if (resRegion != null) {
        regionList = resRegion;
      }

      tlpTaslPeriodList = TlpTaskPeriodModel().getData(DateTime
          .now()
          .year);

      tlpTypeLIst = TlpTypeModel().getData();
      tlpTaskData = TlpTaskModel();
      allowedTLPType = "A";
      allowedTLPCondition = "A";
      _eventCompleted(emit);
    }
    isLoader =  false;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<AddTlpSurveyState> emit) {
    emit(FetchAddTlpSurveyDataState(
        isLoader: isLoader,
        sectionData: sectionData,
        maintenanceBaseData: maintenanceBaseData,
        pipelineData: pipelineData,
        regionData: regionData,
        sectionList: sectionList,
        pipelineList: pipelineList,
        maintenanceBaseList: maintenanceBaseList,
        regionList: regionList,
        tlpConnectionData: tlpConnectionData,
        tlpConnectionList: tlpConnectionList,
        tlpNumberData: tlpNumberData,
        tlpNumberList: tlpNumberList,
        tlpTaskPeriodData: tlpTaskPeriodData,
        tlpTaslPeriodList: tlpTaslPeriodList,
        tlpTypeData: tlpTypeData,
        tlpTypeLIst: tlpTypeLIst,
        pspOnController: pspOnController,
        pspOffController: pspOffController,
        casingPspOnController: casingPspOnController,
        casingPspOffController: casingPspOffController,
        casingIntegrityController: casingIntegrityController,
        foreignPspOnController: foreignPspOnController,
        foreignPspOffController: foreignPspOffController,
        acPspVoltController: acPspVoltController,
        ijOnController: ijOnController,
        ijOffController: ijOffController,
        ijIntegrityController: ijIntegrityController,
        surgeDiverterConditionController: surgeDiverterConditionController,
        couponOnController: couponOnController,
        couponOffController: couponOffController,
        calibrationController: calibrationController,
        mvAcrossTerminalController: mvAcrossTerminalController,
        testStationCurrentController: testStationCurrentController,
        cellConditionController: cellConditionController,
        groundingResistanceController: groundingResistanceController,
        dateOfReadingController: dateOfReadingController,
        remarksController: remarksController,
        chainageKMController: chainageKMController,
        locationDetaolController: locationDetaolController,
        taskIdController: taskIdController,
        yearController: yearController,
        allowedTLPCondition: allowedTLPCondition,
        acCurrentDischargeController: acCurrentDischargeController,
        allowedTLPType: allowedTLPType));
  }
}
