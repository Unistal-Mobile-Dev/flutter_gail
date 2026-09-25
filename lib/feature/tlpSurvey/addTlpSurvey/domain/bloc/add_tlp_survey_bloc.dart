import 'dart:convert';
import 'dart:developer' as developer;

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
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/widget/qr_scanner_screen.dart';
import 'package:intl/intl.dart';

part 'add_tlp_survey_event.dart';
part 'add_tlp_survey_state.dart';

class AddTlpSurveyBloc extends Bloc<AddTlpSurveyEvent, AddTlpSurveyState> {
  bool isLoader = false;
  bool isQrDataLoaded = false;
  bool isAutoFilling = false; // ✅ Track auto-fill progress

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

  List<TlpConnectionModel> tlpConnection1List = [];
  TlpConnectionModel tlpConnection1Data = TlpConnectionModel();

  TextEditingController taskIdController = TextEditingController();
  TextEditingController chainageKMController = TextEditingController();
  TextEditingController locationDetaolController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  TextEditingController sectionCodeController = TextEditingController();

  TextEditingController pspOnController = TextEditingController();
  TextEditingController pspOffController = TextEditingController();

  TextEditingController casingPspOnController = TextEditingController();
  TextEditingController casingPspOffController = TextEditingController();

  TextEditingController casingIntegrityController = TextEditingController();

  TextEditingController foreignPspOnController = TextEditingController();
  TextEditingController foreignPspOffController = TextEditingController();

  TextEditingController dcInterferenceController = TextEditingController();

  TextEditingController acPspVoltController = TextEditingController();

  TextEditingController acceptableAcPspVoltController = TextEditingController();

  TextEditingController soilResistivityController = TextEditingController();

  TextEditingController ijOnController = TextEditingController();
  TextEditingController ijOffController = TextEditingController();

  TextEditingController ijIntegrityController = TextEditingController();

  TextEditingController surgeDiverterConditionController =
  TextEditingController();

  TextEditingController couponDcCurrentDensityController =
  TextEditingController();
  TextEditingController couponAcCurrentDensityController =
  TextEditingController();

  TextEditingController couponOnController = TextEditingController();
  TextEditingController couponOffController = TextEditingController();

  TextEditingController calibrationController = TextEditingController();
  TextEditingController mvAcrossTerminalController = TextEditingController();
  TextEditingController testStationCurrentController = TextEditingController();

  TextEditingController cellConditionController = TextEditingController();
  TextEditingController groundingResistanceController = TextEditingController();

  TextEditingController dateOfReadingController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController acCurrentDischargeController = TextEditingController();

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
    on<SelectTlpConnection1Event>(_selectTlpConnection1);
    on<SelectYearEvent>(_selectYear);
    on<SelectDateReadingEvent>(_selectDateReading);
    on<ScanQrCodeEvent>(_scanQrCode);
    on<QrDataScannedEvent>(_handleQrDataScanned);
    on<AutoFillFormEvent>(_autoFillForm); // ✅ NEW EVENT
    on<SubmitTlpEvent>(_submit);
  }

  void _initControllers() {
    sectionCodeController = TextEditingController();
    pspOnController = TextEditingController();
    pspOffController = TextEditingController();
    casingPspOnController = TextEditingController();
    casingPspOffController = TextEditingController();
    casingIntegrityController = TextEditingController();
    foreignPspOnController = TextEditingController();
    foreignPspOffController = TextEditingController();
    dcInterferenceController = TextEditingController();
    acPspVoltController = TextEditingController();
    acceptableAcPspVoltController = TextEditingController();
    soilResistivityController = TextEditingController();
    ijOnController = TextEditingController();
    ijOffController = TextEditingController();
    ijIntegrityController = TextEditingController();
    surgeDiverterConditionController = TextEditingController();
    couponDcCurrentDensityController = TextEditingController();
    couponAcCurrentDensityController = TextEditingController();
    couponOnController = TextEditingController();
    couponOffController = TextEditingController();
    calibrationController = TextEditingController();
    mvAcrossTerminalController = TextEditingController();
    testStationCurrentController = TextEditingController();
    cellConditionController = TextEditingController();
    groundingResistanceController = TextEditingController();
    dateOfReadingController = TextEditingController();
    remarksController = TextEditingController();
    remarks2Controller = TextEditingController();
    acCurrentDischargeController = TextEditingController();
  }

  _pageLoad(AddTlpSurveyPageLoadEvent event, emit) async {
    emit(AddTlpSurveyPageLoadState());

    regionList = [];
    regionData = RegionTypeModel();

    maintenanceBaseList = [];
    maintenanceBaseData = MaintenanceTypeModel();

    pipelineList = [];
    pipelineData = PipelineModel();

    sectionList = [];
    sectionData = SectionModel();

    tlpTaslPeriodList = [];
    tlpTaskPeriodData = TlpTaskPeriodModel();

    tlpNumberList = [];
    tlpNumberData = TlpNumberModel();

    tlpTypeLIst = [];
    tlpTypeData = TlpTypeModel();

    tlpConnectionList = [];
    tlpConnectionData = TlpConnectionModel();

    tlpConnection1List = [];
    tlpConnection1Data = TlpConnectionModel();

    taskIdController = TextEditingController();
    chainageKMController = TextEditingController();
    locationDetaolController = TextEditingController();
    yearController = TextEditingController();

    isQrDataLoaded = false;
    isAutoFilling = false;
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
    tlpConnection1Data = TlpConnectionModel();
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
      final DateFormat apiFormat = DateFormat('yyyy-MM-dd');
      final formattedApiDate = apiFormat.format(selectedDate);

      dateOfReadingController.text = formattedApiDate;
      _eventCompleted(emit);
    }
  }

  // ========================================================================
  // ✅ QR SCANNING & AUTO-FILL METHODS
  // ========================================================================

  void _scanQrCode(ScanQrCodeEvent event, emit) async {
    developer.log('📱 Opening QR Scanner...', name: 'QR_SCAN');

    final result = await Navigator.push(
      event.context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    developer.log('🔍 QR Scan Result: $result', name: 'QR_SCAN');

    if (result != null && result.toString().isNotEmpty) {
      add(QrDataScannedEvent(qrData: result));
    } else {
      developer.log('⚠️ No QR data received', name: 'QR_SCAN');
      isQrDataLoaded = false;
      _eventCompleted(emit);
    }
  }

  void _handleQrDataScanned(QrDataScannedEvent event, emit) {
    try {
      developer.log('📊 Processing QR Data: ${event.qrData}', name: 'QR_PARSE');

      final dataMap = _parseQrData(event.qrData.toString());

      developer.log('✅ Parsed Data: ${dataMap.keys.toList()}', name: 'QR_PARSE');

      // ✅ Start auto-fill process
      isAutoFilling = true;
      _eventCompleted(emit);

      // Trigger auto-fill event
      add(AutoFillFormEvent(dataMap: dataMap));

    } catch (e, stackTrace) {
      developer.log('❌ Error parsing QR: $e', name: 'QR_PARSE', error: e, stackTrace: stackTrace);
      isQrDataLoaded = false;
      isAutoFilling = false;
      _eventCompleted(emit);
    }
  }

  Map<String, dynamic> _parseQrData(String qrString) {
    developer.log('🔍 Parsing QR string...', name: 'QR_PARSE');

    final Map<String, dynamic> dataMap = {};

    // Try JSON first
    try {
      final parsed = jsonDecode(qrString) as Map<String, dynamic>;
      developer.log('✓ JSON format detected', name: 'QR_PARSE');
      return parsed;
    } catch (e) {
      developer.log('⚠️ Not JSON, parsing as plain text', name: 'QR_PARSE');
    }

    // Parse plain text format
    final lines = qrString.split('\n');

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim().toLowerCase();
          final value = parts.sublist(1).join(':').trim();

          switch (key) {
            case 'device tag id':
            case 'device tag':
            case 'tag id':
              dataMap['device_tag_id'] = value;
              dataMap['task_id'] = value;
              break;

            case 'station':
              dataMap['station'] = value;
              break;

            case 'section':
              dataMap['section'] = value;
              dataMap['location_details'] = value;
              break;

            case 'gps':
            case 'coordinates':
              dataMap['gps'] = value;
              final gpsCoords = value.split(',');
              if (gpsCoords.length >= 2) {
                dataMap['latitude'] = gpsCoords[0].trim();
                dataMap['longitude'] = gpsCoords[1].trim();
              }
              break;

            default:
              dataMap[key.replaceAll(' ', '_')] = value;
          }
        }
      }
    }

    return dataMap;
  }

  // ✅ NEW: Auto-fill form by navigating through dropdowns
  void _autoFillForm(AutoFillFormEvent event, emit) async {
    try {
      final dataMap = event.dataMap;

      developer.log('🔄 Starting auto-fill process...', name: 'AUTO_FILL');

      // Step 1: Get current year from system
      final currentYear = DateTime.now().year;
      yearController.text = currentYear.toString();
      tlpTaslPeriodList = TlpTaskPeriodModel().getData(currentYear);
      _eventCompleted(emit);
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Select Region (based on station or default)
      if (regionList.isNotEmpty) {
        // Try to find matching region or use first one
        final region = _findBestMatchRegion(dataMap);
        if (region != null) {
          add(SelectRegionEvent(regionData: region));
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      // Step 3: Select Maintenance Base (after region loads)
      if (maintenanceBaseList.isNotEmpty) {
        final maintenance = maintenanceBaseList.first;
        add(SelectMaintenanceBaseEvent(maintenanceBaseData: maintenance));
        await Future.delayed(const Duration(milliseconds: 800));
      }

      // Step 4: Select Pipeline
      if (pipelineList.isNotEmpty) {
        final pipeline = pipelineList.first;
        add(SelectPipelineEvent(pipelineData: pipeline));
        await Future.delayed(const Duration(milliseconds: 800));
      }

      // Step 5: Select Section (find matching section from QR)
      if (sectionList.isNotEmpty) {
        final section = _findMatchingSection(dataMap);
        if (section != null) {
          add(SelectSectionEvent(sectionData: section));
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Step 6: Select TLP Task Period (current year)
      if (tlpTaslPeriodList.isNotEmpty) {
        final period = tlpTaslPeriodList.first;
        add(SelectTlpTaskPeriodEvent(tlpTaskPeriodData: period));
        await Future.delayed(const Duration(milliseconds: 800));
      }

      // Step 7: Select TLP Number (find matching from task data)
      if (tlpNumberList.isNotEmpty) {
        final tlpNumber = _findMatchingTlpNumber(dataMap);
        if (tlpNumber != null) {
          add(SelectTlpNumberEvent(tlpNumberData: tlpNumber));
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Step 8: Select TLP Type
      if (tlpTypeLIst.isNotEmpty) {
        final tlpType = tlpTypeLIst.isNotEmpty ? tlpTypeLIst.first : tlpTypeData;
        add(SelectTlpTypeEvent(tlpTypeData: tlpType));
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 9: Select TLP Connection
      if (tlpConnectionList.isNotEmpty) {
        final connection = tlpConnectionList.first;
        add(SelectTlpConnectionEvent(tlpConnectionData: connection));
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 10: Populate all text fields
      _populateTextFields(dataMap);

      // ✅ Mark as loaded
      isQrDataLoaded = true;
      isAutoFilling = false;

      developer.log('✅ Auto-fill completed successfully!', name: 'AUTO_FILL');
      _eventCompleted(emit);

    } catch (e, stackTrace) {
      developer.log('❌ Auto-fill error: $e', name: 'AUTO_FILL', error: e, stackTrace: stackTrace);
      isQrDataLoaded = false;
      isAutoFilling = false;
      _eventCompleted(emit);
    }
  }

  // ✅ Helper: Find best matching region
  RegionTypeModel? _findBestMatchRegion(Map<String, dynamic> dataMap) {
    if (regionList.isEmpty) return null;

    final station = dataMap['station']?.toString().toLowerCase() ?? '';
    final section = dataMap['section']?.toString().toLowerCase() ?? '';

    // Try to find region by station name
    for (var region in regionList) {
      final regionName = region.name?.toLowerCase() ?? '';
      if (station.contains(regionName) || regionName.contains(station.split(' ').first)) {
        developer.log('✓ Matched Region: ${region.name}', name: 'AUTO_FILL');
        return region;
      }
    }

    // Default to first region
    return regionList.first;
  }

  // ✅ Helper: Find matching section
  SectionModel? _findMatchingSection(Map<String, dynamic> dataMap) {
    if (sectionList.isEmpty) return null;

    final sectionData = dataMap['section']?.toString().toLowerCase() ?? '';

    for (var section in sectionList) {
      final sectionName = section.name?.toLowerCase() ?? '';
      if (sectionName.contains(sectionData) || sectionData.contains(sectionName)) {
        developer.log('✓ Matched Section: ${section.name}', name: 'AUTO_FILL');
        return section;
      }
    }

    // Try partial match with first word
    final firstWord = sectionData.split(' ').first;
    if (firstWord.isNotEmpty) {
      for (var section in sectionList) {
        final sectionName = section.name?.toLowerCase() ?? '';
        if (sectionName.contains(firstWord)) {
          developer.log('✓ Partial matched Section: ${section.name}', name: 'AUTO_FILL');
          return section;
        }
      }
    }

    return sectionList.first;
  }

  // ✅ Helper: Find matching TLP number
  TlpNumberModel? _findMatchingTlpNumber(Map<String, dynamic> dataMap) {
    if (tlpNumberList.isEmpty) return null;

    final deviceTag = dataMap['device_tag_id']?.toString().toLowerCase() ?? '';
    final location = dataMap['location_details']?.toString().toLowerCase() ?? '';

    for (var tlpNum in tlpNumberList) {
      final assetId = tlpNum.assetId?.toString().toLowerCase() ?? '';
      final locDesc = tlpNum.locationDescription?.toString().toLowerCase() ?? '';

      if (assetId.contains(deviceTag) || deviceTag.contains(assetId) ||
          locDesc.contains(location) || location.contains(locDesc)) {
        developer.log('✓ Matched TLP Number: ${tlpNum.assetId}', name: 'AUTO_FILL');
        return tlpNum;
      }
    }

    return tlpNumberList.first;
  }

  // ✅ Helper: Populate all text fields
  void _populateTextFields(Map<String, dynamic> dataMap) {
    int fieldsPopulated = 0;

    void setField(TextEditingController controller, dynamic value, String fieldName) {
      if (value != null && value.toString().isNotEmpty) {
        controller.text = value.toString();
        fieldsPopulated++;
        developer.log('✓ Populated: $fieldName = $value', name: 'AUTO_FILL');
      }
    }

    developer.log('📝 Populating text fields...', name: 'AUTO_FILL');

    // Task ID
    setField(taskIdController, dataMap['task_id'], 'task_id');

    // Location Details
    setField(locationDetaolController, dataMap['location_details'], 'location_details');

    // Section Code
    if (dataMap['section'] != null) {
      String section = dataMap['section'].toString();
      if (section.contains('(') && section.contains(')')) {
        final startIdx = section.indexOf('(') + 1;
        final endIdx = section.indexOf(')');
        if (startIdx > 0 && endIdx > startIdx) {
          final code = section.substring(startIdx, endIdx);
          setField(sectionCodeController, code, 'section_code');
        }
      }
    }

    // Remarks
    if (dataMap['station'] != null) {
      remarksController.text += 'Station: ${dataMap['station']}\n';
    }
    if (dataMap['latitude'] != null && dataMap['longitude'] != null) {
      remarksController.text += 'GPS: Lat ${dataMap['latitude']}, Lng ${dataMap['longitude']}';
    }

    // Measurement fields (if any)
    setField(pspOnController, dataMap['psp_on'], 'psp_on');
    setField(pspOffController, dataMap['psp_off'], 'psp_off');
    setField(casingPspOnController, dataMap['casing_psp_on'], 'casing_psp_on');
    setField(casingPspOffController, dataMap['casing_psp_off'], 'casing_psp_off');
    setField(casingIntegrityController, dataMap['casing_integrity'], 'casing_integrity');
    setField(foreignPspOnController, dataMap['foreign_psp_on'], 'foreign_psp_on');
    setField(foreignPspOffController, dataMap['foreign_psp_off'], 'foreign_psp_off');
    setField(dcInterferenceController, dataMap['dc_interference'], 'dc_interference');
    setField(acPspVoltController, dataMap['ac_psp_volt'], 'ac_psp_volt');
    setField(acceptableAcPspVoltController, dataMap['acceptable_ac_psp_volt'], 'acceptable_ac_psp_volt');
    setField(soilResistivityController, dataMap['soil_resistivity'], 'soil_resistivity');
    setField(ijOnController, dataMap['ij_on'], 'ij_on');
    setField(ijOffController, dataMap['ij_off'], 'ij_off');
    setField(ijIntegrityController, dataMap['ij_integrity'], 'ij_integrity');
    setField(surgeDiverterConditionController, dataMap['surge_diverter_condition'], 'surge_diverter_condition');
    setField(couponDcCurrentDensityController, dataMap['coupon_dc_current_density'], 'coupon_dc_current_density');
    setField(couponAcCurrentDensityController, dataMap['coupon_ac_current_density'], 'coupon_ac_current_density');
    setField(couponOnController, dataMap['coupon_on'], 'coupon_on');
    setField(couponOffController, dataMap['coupon_off'], 'coupon_off');
    setField(calibrationController, dataMap['calibration'], 'calibration');
    setField(mvAcrossTerminalController, dataMap['mv_across_terminal'], 'mv_across_terminal');
    setField(testStationCurrentController, dataMap['test_station_current'], 'test_station_current');
    setField(cellConditionController, dataMap['cell_condition'], 'cell_condition');
    setField(groundingResistanceController, dataMap['grounding_resistance'], 'grounding_resistance');
    setField(dateOfReadingController, dataMap['date_of_reading'], 'date_of_reading');
    setField(acCurrentDischargeController, dataMap['ac_current_discharge'], 'ac_current_discharge');

    developer.log('📈 Total fields populated: $fieldsPopulated', name: 'AUTO_FILL');
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

    if (textFiledValidation == false) {
      isLoader = false;
      _eventCompleted(emit);
      return;
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
        allowedTLPCondition: allowedTLPCondition,
        dcInterferenceController: dcInterferenceController,
        acceptableAcPspVoltController: acceptableAcPspVoltController,
        soilResistivityController: soilResistivityController,
        couponDcCurrentDensityController: couponDcCurrentDensityController,
        couponAcCurrentDensityController: couponAcCurrentDensityController,
        remarks2Controller: remarks2Controller,);

    if (res != null) {
      regionList = [];
      regionData = RegionTypeModel();

      maintenanceBaseList = [];
      maintenanceBaseData = MaintenanceTypeModel();

      pipelineList = [];
      pipelineData = PipelineModel();

      sectionList = [];
      sectionData = SectionModel();

      tlpTaslPeriodList = [];
      tlpTaskPeriodData = TlpTaskPeriodModel();

      tlpNumberList = [];
      tlpNumberData = TlpNumberModel();

      tlpTypeLIst = [];
      tlpTypeData = TlpTypeModel();

      tlpConnectionList = [];
      tlpConnectionData = TlpConnectionModel();

      tlpConnection1List = [];
      tlpConnection1Data = TlpConnectionModel();

      taskIdController = TextEditingController();
      chainageKMController = TextEditingController();
      locationDetaolController = TextEditingController();
      yearController = TextEditingController();

      isQrDataLoaded = false;
      isAutoFilling = false;
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

  _eventCompleted(Emitter<AddTlpSurveyState> emit) {
    emit(FetchAddTlpSurveyDataState(
        isLoader: isLoader,
        isQrDataLoaded: isQrDataLoaded,
        isAutoFilling: isAutoFilling,
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
        tlpConnection1Data: tlpConnection1Data,
        tlpConnection1List: tlpConnection1List,
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
        dcInterferenceController: dcInterferenceController,
        acPspVoltController: acPspVoltController,
        acceptableAcPspVoltController: acceptableAcPspVoltController,
        soilResistivityController: soilResistivityController,
        ijOnController: ijOnController,
        ijOffController: ijOffController,
        ijIntegrityController: ijIntegrityController,
        surgeDiverterConditionController: surgeDiverterConditionController,
        couponDcCurrentDensityController: couponDcCurrentDensityController,
        couponAcCurrentDensityController: couponAcCurrentDensityController,
        couponOnController: couponOnController,
        couponOffController: couponOffController,
        calibrationController: calibrationController,
        mvAcrossTerminalController: mvAcrossTerminalController,
        testStationCurrentController: testStationCurrentController,
        cellConditionController: cellConditionController,
        groundingResistanceController: groundingResistanceController,
        dateOfReadingController: dateOfReadingController,
        remarksController: remarksController,
        remarks2Controller: remarks2Controller,
        chainageKMController: chainageKMController,
        locationDetaolController: locationDetaolController,
        taskIdController: taskIdController,
        sectionCodeController: sectionCodeController,
        yearController: yearController,
        allowedTLPCondition: allowedTLPCondition,
        acCurrentDischargeController: acCurrentDischargeController,
        allowedTLPType: allowedTLPType));
  }
}