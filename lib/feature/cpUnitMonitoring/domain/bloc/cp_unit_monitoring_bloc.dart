import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/helper/cp_unit_monitoring_helper.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

part 'cp_unit_monitoring_event.dart';

part 'cp_unit_monitoring_state.dart';

class CpUnitMonitoringBloc extends Bloc<CpUnitMonitoringEvent, CpUnitMonitoringState> {
  final CpUnitMonitoringHelper _helper = CpUnitMonitoringHelper();

  int _updateCount = 0;
  bool isLoader = false;

  bool isMaintenanceBaseLoader = false;
  bool isPipelineLoader = false;
  bool isSectionLoader = false;
  bool isRectifierLoader = false;
  bool isTaskIdLoader = false;

  List<CpOptionModel> regionList = [];
  CpOptionModel regionData = CpOptionModel();

  List<CpOptionModel> maintenanceBaseList = [];
  CpOptionModel maintenanceBaseData = CpOptionModel();

  List<CpOptionModel> pipelineList = [];
  CpOptionModel pipelineData = CpOptionModel();

  List<CpOptionModel> sectionList = [];
  CpOptionModel sectionData = CpOptionModel();

  List<CpOptionModel> yearList = [];
  CpOptionModel yearData = CpOptionModel();

  List<CpOptionModel> monthList = [];
  CpOptionModel monthData = CpOptionModel();

  List<CpOptionModel> rectifierList = [];
  CpOptionModel rectifierData = CpOptionModel();

  // TODO: confirm Operating Mode / On-Off / Health values with the web form
  final List<CpOptionModel> operatingModeList = [
    CpOptionModel.value(id: "Auto", name: "Auto"),
    CpOptionModel.value(id: "Manual", name: "Manual"),
  ];
  CpOptionModel operatingModeData = CpOptionModel();

  final List<CpOptionModel> onOffStatusList = [
    CpOptionModel.value(id: "On", name: "On"),
    CpOptionModel.value(id: "Off", name: "Off"),
  ];
  CpOptionModel onOffStatusData = CpOptionModel();

  final List<CpOptionModel> rectifierHealthList = [
    CpOptionModel.value(id: "Ok", name: "Ok"),
    CpOptionModel.value(id: "Not Ok", name: "Not Ok"),
  ];
  CpOptionModel rectifierHealthData = CpOptionModel();

  /// Selected task: id goes to the API, name is shown in the form
  CpOptionModel taskData = CpOptionModel();
  TextEditingController taskIdController = TextEditingController();
  TextEditingController chainageController = TextEditingController();
  TextEditingController inspectedByController = TextEditingController();
  TextEditingController inspectionDateController = TextEditingController();
  TextEditingController pspController = TextEditingController();
  TextEditingController acVoltageInController = TextEditingController();
  TextEditingController acCurrentInController = TextEditingController();
  TextEditingController dcCurrentOutController = TextEditingController();
  TextEditingController targetInternalPspController = TextEditingController();
  TextEditingController pspReferenceCell1Controller = TextEditingController();
  TextEditingController pspReferenceCell2Controller = TextEditingController();
  TextEditingController pspReferenceCell3Controller = TextEditingController();
  TextEditingController controllingReferenceCellController = TextEditingController();
  TextEditingController pspNearestController = TextEditingController();
  TextEditingController powerAvailabilityController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  List<TextEditingController> get _readingControllers => [
    chainageController,
    pspController,
    acVoltageInController,
    acCurrentInController,
    dcCurrentOutController,
    targetInternalPspController,
    pspReferenceCell1Controller,
    pspReferenceCell2Controller,
    pspReferenceCell3Controller,
    controllingReferenceCellController,
    pspNearestController,
    powerAvailabilityController,
    remarksController,
  ];

  CpUnitMonitoringBloc() : super(CpUnitMonitoringInitial()) {
    on<CpUnitMonitoringPageLoadEvent>(_pageLoad);
    on<CpSelectRegionEvent>(_selectRegion);
    on<CpSelectMaintenanceBaseEvent>(_selectMaintenanceBase);
    on<CpSelectPipelineEvent>(_selectPipeline);
    on<CpSelectSectionEvent>(_selectSection);
    on<CpSelectYearEvent>(_selectYear);
    on<CpSelectMonthEvent>(_selectMonth);
    on<CpSelectRectifierEvent>(_selectRectifier);
    on<CpSelectOperatingModeEvent>(_selectOperatingMode);
    on<CpSelectOnOffStatusEvent>(_selectOnOffStatus);
    on<CpSelectRectifierHealthEvent>(_selectRectifierHealth);
    on<CpSelectInspectionDateEvent>(_selectInspectionDate);
    on<CpSubmitInspectionEvent>(_submit);
  }

  _pageLoad(CpUnitMonitoringPageLoadEvent event, emit) async {
    emit(CpUnitMonitoringPageLoadState());
    _resetForm(clearHeader: true);

    // Year: current year and last 5 years
    final int currentYear = DateTime.now().year;
    yearList = List.generate(6, (index) {
      final year = (currentYear - index).toString();
      return CpOptionModel.value(id: year, name: year);
    });

    // Month: January ... December
    monthList = List.generate(12, (index) {
      return CpOptionModel.value(
        id: (index + 1).toString(),
        name: DateFormat('MMMM').format(DateTime(currentYear, index + 1)),
      );
    });

    regionList = await _helper.fetchRegions();
    if (regionList.isEmpty && event.context.mounted) {
      SnackBarErrorWidget(event.context).show(
        message: "Unable to load Region data. Please check internet and try again.",
      );
    }
    _eventCompleted(emit);
  }

  _selectRegion(CpSelectRegionEvent event, emit) async {
    regionData = event.regionData;
    maintenanceBaseList = [];
    maintenanceBaseData = CpOptionModel();
    _clearPipeline();
    isMaintenanceBaseLoader = true;
    _eventCompleted(emit);

    maintenanceBaseList = await _helper.fetchMaintenanceBases(regionData: regionData);
    isMaintenanceBaseLoader = false;
    _eventCompleted(emit);
  }

  _selectMaintenanceBase(CpSelectMaintenanceBaseEvent event, emit) async {
    maintenanceBaseData = event.maintenanceBaseData;
    _clearPipeline();
    isPipelineLoader = true;
    _eventCompleted(emit);

    pipelineList = await _helper.fetchPipelines(maintenanceBaseData: maintenanceBaseData);
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectPipeline(CpSelectPipelineEvent event, emit) async {
    pipelineData = event.pipelineData;
    _clearSection();
    isSectionLoader = true;
    _eventCompleted(emit);

    sectionList = await _helper.fetchSections(pipelineData: pipelineData);
    isSectionLoader = false;
    _eventCompleted(emit);
  }

  _selectSection(CpSelectSectionEvent event, emit) async {
    sectionData = event.sectionData;
    _clearRectifier();
    taskData = CpOptionModel();
    taskIdController.text = "";
    isRectifierLoader = true;
    _eventCompleted(emit);

    rectifierList = await _helper.fetchRectifiers(sectionData: sectionData);
    isRectifierLoader = false;
    _eventCompleted(emit);
    await _loadTaskId(emit);
  }

  _selectYear(CpSelectYearEvent event, emit) async {
    yearData = event.yearData;
    _eventCompleted(emit);
    await _loadTaskId(emit);
  }

  _selectMonth(CpSelectMonthEvent event, emit) async {
    monthData = event.monthData;
    _eventCompleted(emit);
    await _loadTaskId(emit);
  }

  _selectRectifier(CpSelectRectifierEvent event, emit) async {
    rectifierData = event.rectifierData;
    chainageController.text = _chainageOf(rectifierData.data) ?? "";
    _eventCompleted(emit);

    // Rectifier details (chainage etc.)
    final details = await _helper.fetchRectifierDetails(rectifierData: rectifierData);
    final chainage = _chainageOf(details);
    if (chainage != null) {
      chainageController.text = chainage;
    }
    _eventCompleted(emit);
  }

  _selectOperatingMode(CpSelectOperatingModeEvent event, emit) {
    operatingModeData = event.operatingModeData;
    _eventCompleted(emit);
  }

  _selectOnOffStatus(CpSelectOnOffStatusEvent event, emit) {
    onOffStatusData = event.onOffStatusData;
    _eventCompleted(emit);
  }

  _selectRectifierHealth(CpSelectRectifierHealthEvent event, emit) {
    rectifierHealthData = event.rectifierHealthData;
    _eventCompleted(emit);
  }

  _selectInspectionDate(CpSelectInspectionDateEvent event, emit) async {
    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: "Select Inspection Date",
    );
    if (selectedDate != null) {
      inspectionDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      _eventCompleted(emit);
    }
  }

  _submit(CpSubmitInspectionEvent event, emit) async {
    BuildContext context = event.context;
    final isValid = CpUnitMonitoringHelper.textFieldValidation(
      context: context,
      regionData: regionData,
      maintenanceBaseData: maintenanceBaseData,
      pipelineData: pipelineData,
      sectionData: sectionData,
      yearData: yearData,
      monthData: monthData,
      taskIdController: taskIdController,
      rectifierData: rectifierData,
      inspectionDateController: inspectionDateController,
    );
    if (!isValid) return;

    isLoader = true;
    _eventCompleted(emit);

    final inspectionDate = DateFormat('dd-MM-yyyy').parse(inspectionDateController.text.trim());
    final body = <String, dynamic>{
      "id": "", // empty = new inspection
      "region_id": regionData.id,
      "maintenancebase_id": maintenanceBaseData.id,
      "pipeline_id": pipelineData.id,
      "section_id": sectionData.id,
      "year": yearData.id,
      "month": monthData.id,
      "task_id": taskData.id,
      "rectifier_id": rectifierData.id,
      "operating_mode": operatingModeData.id ?? "",
      "inspected_by": inspectedByController.text.trim(),
      "inspection_date": DateFormat('yyyy-MM-dd').format(inspectionDate),
      "psp": pspController.text.trim(),
      "on_off_status": onOffStatusData.id ?? "",
      "ac_voltage_ip": acVoltageInController.text.trim(),
      "ac_current_ip": acCurrentInController.text.trim(),
      "dc_current_op": dcCurrentOutController.text.trim(),
      "target_internal_psp": targetInternalPspController.text.trim(),
      "psp_ref_cell_1": pspReferenceCell1Controller.text.trim(),
      "psp_ref_cell_2": pspReferenceCell2Controller.text.trim(),
      "psp_ref_cell_3": pspReferenceCell3Controller.text.trim(),
      "controlling_reference_cell": controllingReferenceCellController.text.trim(),
      "psp_nearest": pspNearestController.text.trim(),
      "percent_availability_of_power_for_cp_unit": powerAvailabilityController.text.trim(),
      "rectifier_health": rectifierHealthData.id ?? "",
      "remarks": remarksController.text.trim(),
    };

    var res = await _helper.submit(context: context, body: body);
    if (res != null) {
      // Keep Region...Month and Task ID for the next rectifier, clear the readings
      _clearRectifier();
    }
    isLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _loadTaskId(Emitter<CpUnitMonitoringState> emit) async {
    if (sectionData.id == null || yearData.id == null || monthData.id == null) return;
    taskData = CpOptionModel();
    taskIdController.text = "";
    isTaskIdLoader = true;
    _eventCompleted(emit);

    final task = await _helper.fetchTask(
      regionData: regionData,
      maintenanceBaseData: maintenanceBaseData,
      pipelineData: pipelineData,
      sectionData: sectionData,
      year: yearData.id!,
      month: monthData.id!,
    );
    taskData = task ?? CpOptionModel();
    taskIdController.text = taskData.name ?? "";
    isTaskIdLoader = false;
    _eventCompleted(emit);
  }

  String? _chainageOf(Map<String, dynamic>? data) {
    if (data == null) return null;
    for (final key in ["chainage", "chainage_m", "chainage_in_m", "engm"]) {
      final value = data[key];
      if (value != null && value.toString().isNotEmpty) return value.toString();
    }
    return null;
  }

  void _resetForm({required bool clearHeader}) {
    isLoader = false;
    isMaintenanceBaseLoader = false;
    isPipelineLoader = false;
    isSectionLoader = false;
    isRectifierLoader = false;
    isTaskIdLoader = false;
    if (clearHeader) {
      regionList = [];
      regionData = CpOptionModel();
      maintenanceBaseList = [];
      maintenanceBaseData = CpOptionModel();
      yearData = CpOptionModel();
      monthData = CpOptionModel();
      _clearPipeline();
    }
  }

  void _clearPipeline() {
    pipelineList = [];
    pipelineData = CpOptionModel();
    _clearSection();
  }

  void _clearSection() {
    sectionList = [];
    sectionData = CpOptionModel();
    taskData = CpOptionModel();
    taskIdController.text = "";
    rectifierList = [];
    _clearRectifier();
  }

  void _clearRectifier() {
    rectifierData = CpOptionModel();
    operatingModeData = CpOptionModel();
    onOffStatusData = CpOptionModel();
    rectifierHealthData = rectifierHealthList.first;
    inspectionDateController.text = "";
    inspectedByController.text =
        UserInfo.instance?.userData?.users?.firstName?.toString() ?? "";
    for (final controller in _readingControllers) {
      controller.text = "";
    }
  }

  _eventCompleted(Emitter<CpUnitMonitoringState> emit) {
    emit(FetchCpUnitMonitoringDataState(
      updateCount: ++_updateCount,
      isLoader: isLoader,
      isMaintenanceBaseLoader: isMaintenanceBaseLoader,
      isPipelineLoader: isPipelineLoader,
      isSectionLoader: isSectionLoader,
      isRectifierLoader: isRectifierLoader,
      isTaskIdLoader: isTaskIdLoader,
      regionList: regionList,
      regionData: regionData,
      maintenanceBaseList: maintenanceBaseList,
      maintenanceBaseData: maintenanceBaseData,
      pipelineList: pipelineList,
      pipelineData: pipelineData,
      sectionList: sectionList,
      sectionData: sectionData,
      yearList: yearList,
      yearData: yearData,
      monthList: monthList,
      monthData: monthData,
      rectifierList: rectifierList,
      rectifierData: rectifierData,
      operatingModeList: operatingModeList,
      operatingModeData: operatingModeData,
      onOffStatusList: onOffStatusList,
      onOffStatusData: onOffStatusData,
      rectifierHealthList: rectifierHealthList,
      rectifierHealthData: rectifierHealthData,
      taskIdController: taskIdController,
      chainageController: chainageController,
      inspectedByController: inspectedByController,
      inspectionDateController: inspectionDateController,
      pspController: pspController,
      acVoltageInController: acVoltageInController,
      acCurrentInController: acCurrentInController,
      dcCurrentOutController: dcCurrentOutController,
      targetInternalPspController: targetInternalPspController,
      pspReferenceCell1Controller: pspReferenceCell1Controller,
      pspReferenceCell2Controller: pspReferenceCell2Controller,
      pspReferenceCell3Controller: pspReferenceCell3Controller,
      controllingReferenceCellController: controllingReferenceCellController,
      pspNearestController: pspNearestController,
      powerAvailabilityController: powerAvailabilityController,
      remarksController: remarksController,
    ));
  }
}
