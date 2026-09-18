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
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/widget/scan_qr.dart';

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

  // NEW: Additional TLP Connection 1
  List<TlpConnectionModel> tlpConnection1List = [];
  TlpConnectionModel tlpConnection1Data = TlpConnectionModel();

  TextEditingController taskIdController = TextEditingController();
  TextEditingController chainageKMController = TextEditingController();
  TextEditingController locationDetaolController = TextEditingController();
  TextEditingController yearController = TextEditingController();

// NEW: Section Code
  TextEditingController sectionCodeController = TextEditingController();

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

// NEW: DC Interference (Yes/No)
  TextEditingController dcInterferenceController = TextEditingController();

// AC PSP (At HT Crossing/Parallel) Volts
  TextEditingController acPspVoltController = TextEditingController();

// NEW: Acceptable AC PSP (Volts)
  TextEditingController acceptableAcPspVoltController = TextEditingController();

// NEW: Soil Resistivity (Ω·m)
  TextEditingController soilResistivityController = TextEditingController();

// IJ Reading (Un-protected Side) (-mV)
  TextEditingController ijOnController = TextEditingController();
  TextEditingController ijOffController = TextEditingController();

// Integrity of IJ
  TextEditingController ijIntegrityController = TextEditingController();

// Condition of Surge Diverter
  TextEditingController surgeDiverterConditionController =
  TextEditingController();

// NEW: Coupon current density (A/m²)
  TextEditingController couponDcCurrentDensityController =
  TextEditingController();
  TextEditingController couponAcCurrentDensityController =
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

// NEW: Remarks 2
  TextEditingController remarks2Controller = TextEditingController();

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
    on<SelectTlpConnection1Event>(_selectTlpConnection1); // NEW
    on<SelectYearEvent>(_selectYear);
    on<SelectDateReadingEvent>(_selectDateReading);
    on<ScanQrCodeEvent>(_scanQrCode);
    on<QrDataScannedEvent>(_handleQrDataScanned);
    on<SubmitTlpEvent>(_submit);
  }

  // Helper: (re)initialise every measurement / input controller.
  void _initControllers() {
    // Identification
    sectionCodeController = TextEditingController(); // NEW

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
    dcInterferenceController = TextEditingController(); // NEW

    // AC PSP / Acceptable AC PSP / Soil Resistivity
    acPspVoltController = TextEditingController();
    acceptableAcPspVoltController = TextEditingController(); // NEW
    soilResistivityController = TextEditingController(); // NEW

    // IJ Reading (Un-protected Side) (-mV)
    ijOnController = TextEditingController();
    ijOffController = TextEditingController();

    // Integrity of IJ
    ijIntegrityController = TextEditingController();

    // Condition of Surge Diverter
    surgeDiverterConditionController = TextEditingController();

    // Monitoring of Coupons
    couponDcCurrentDensityController = TextEditingController(); // NEW
    couponAcCurrentDensityController = TextEditingController(); // NEW
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
    remarks2Controller = TextEditingController(); // NEW
    acCurrentDischargeController = TextEditingController();
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

    // TLP Connection 1  // NEW
    tlpConnection1List = [];
    tlpConnection1Data = TlpConnectionModel();

    taskIdController = TextEditingController();
    chainageKMController = TextEditingController();
    locationDetaolController = TextEditingController();
    yearController = TextEditingController();

    _initControllers();

    var resRegion = await AddTLPSurveyHelper.fetchArea();
    if (resRegion != null) {
      regionList = resRegion;
    }

    tlpTaslPeriodList = TlpTaskPeriodModel().getData(DateTime.now().year);

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
    // NEW: populate Section Code from the selected section (adjust the field
    // name to match your SectionModel, e.g. sectionData.code / .sectionCode).
    sectionCodeController.text = sectionData.code?.toString() ?? "";
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
    tlpConnection1Data = TlpConnectionModel(); // NEW
    allowedTLPType = tlpTypeData.name.toString();
    if (allowedTLPType == "A" ||
        allowedTLPType == "E" ||
        allowedTLPType == "F" ||
        allowedTLPType == "I" ||
        allowedTLPType == "J" ||
        allowedTLPType == "L" &&
            allowedTLPType == "M" &&
            allowedTLPType == "N" ||
        allowedTLPType == "O" ||
        allowedTLPType == "Q") {
      tlpConnectionList = TlpConnectionModel().getShortData();
    } else {
      tlpConnectionList = TlpConnectionModel().getFullData();
    }
    // NEW: Conn1 uses the same option list as Conn.
    tlpConnection1List = tlpConnectionList;

    _initControllers();

    _eventCompleted(emit);
  }

  void _selectTlpConnection(SelectTlpConnectionEvent event, emit) {
    tlpConnectionData = event.tlpConnectionData;
    allowedTLPCondition = tlpConnectionData.name.toString();

    _initControllers();
    _eventCompleted(emit);
  }

  // NEW: Additional TLP Connection 1 — stores the value only. It does not
  // change allowedTLPCondition or reset the measurement fields.
  void _selectTlpConnection1(SelectTlpConnection1Event event, emit) {
    tlpConnection1Data = event.tlpConnection1Data;
    _eventCompleted(emit);
  }

  void _selectYear(SelectYearEvent event, emit) async {
    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10),
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

  void _submit(SubmitTlpEvent event, emit) async {
    BuildContext context = event.context;
    isLoader = true;
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
    // NOTE: To validate the NEW fields, add these named params to
    // AddTLPSurveyHelper.textFieldValidation and pass them here:
    //   tlpConnection1Data, sectionCodeController, dcInterferenceController,
    //   acceptableAcPspVoltController, soilResistivityController,
    //   couponDcCurrentDensityController, couponAcCurrentDensityController,
    //   remarks2Controller

    if (textFiledValidation == false) {
      isLoader = false;
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
    // NOTE: To submit the NEW fields, add these named params to
    // AddTLPSurveyHelper.submit and pass them here:
    //   tlpConnection1Data, sectionCodeController, dcInterferenceController,
    //   acceptableAcPspVoltController, soilResistivityController,
    //   couponDcCurrentDensityController, couponAcCurrentDensityController,
    //   remarks2Controller
    if (res != null) {
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

      // TLP Connection 1  // NEW
      tlpConnection1List = [];
      tlpConnection1Data = TlpConnectionModel();

      taskIdController = TextEditingController();
      chainageKMController = TextEditingController();
      locationDetaolController = TextEditingController();
      yearController = TextEditingController();

      _initControllers();

      var resRegion = await AddTLPSurveyHelper.fetchArea();
      if (resRegion != null) {
        regionList = resRegion;
      }

      tlpTaslPeriodList = TlpTaskPeriodModel().getData(DateTime.now().year);

      tlpTypeLIst = TlpTypeModel().getData();
      tlpTaskData = TlpTaskModel();
      allowedTLPType = "A";
      allowedTLPCondition = "A";
      _eventCompleted(emit);
    }
    isLoader = false;
    _eventCompleted(emit);
  }


  void _scanQrCode(ScanQrCodeEvent event, emit) async {
    final result = await Navigator.push(
      event.context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (result != null) {
      add(QrDataScannedEvent(qrData: result));
    }
  }

  void _handleQrDataScanned(QrDataScannedEvent event, emit) {
    final dataMap = event.qrData is Map ? event.qrData : event.qrData.toJson();

    // Auto-fill fields
    if (dataMap['psp_on'] != null)
      pspOnController.text = dataMap['psp_on'].toString();
    if (dataMap['psp_off'] != null)
      pspOffController.text = dataMap['psp_off'].toString();
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
        tlpConnection1Data: tlpConnection1Data, // NEW
        tlpConnection1List: tlpConnection1List, // NEW
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
        dcInterferenceController: dcInterferenceController, // NEW
        acPspVoltController: acPspVoltController,
        acceptableAcPspVoltController: acceptableAcPspVoltController, // NEW
        soilResistivityController: soilResistivityController, // NEW
        ijOnController: ijOnController,
        ijOffController: ijOffController,
        ijIntegrityController: ijIntegrityController,
        surgeDiverterConditionController: surgeDiverterConditionController,
        couponDcCurrentDensityController:
        couponDcCurrentDensityController, // NEW
        couponAcCurrentDensityController:
        couponAcCurrentDensityController, // NEW
        couponOnController: couponOnController,
        couponOffController: couponOffController,
        calibrationController: calibrationController,
        mvAcrossTerminalController: mvAcrossTerminalController,
        testStationCurrentController: testStationCurrentController,
        cellConditionController: cellConditionController,
        groundingResistanceController: groundingResistanceController,
        dateOfReadingController: dateOfReadingController,
        remarksController: remarksController,
        remarks2Controller: remarks2Controller, // NEW
        chainageKMController: chainageKMController,
        locationDetaolController: locationDetaolController,
        taskIdController: taskIdController,
        sectionCodeController: sectionCodeController, // NEW
        yearController: yearController,
        allowedTLPCondition: allowedTLPCondition,
        acCurrentDischargeController: acCurrentDischargeController,
        allowedTLPType: allowedTLPType));
  }
}
