import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/model/psp_field_model.dart';
import 'package:flutter_gail/feature/pspMonitoring/helper/psp_monitoring_helper.dart';

part 'psp_monitoring_event.dart';

part 'psp_monitoring_state.dart';

class PspMonitoringBloc extends Bloc<PspMonitoringEvent, PspMonitoringState> {
  final PspMonitoringHelper _helper = PspMonitoringHelper();

  // Type Of TLP values (same as the web form)
  static const List<String> _tlpTypes = [
    "A", "B", "C", "D", "E", "F", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
  ];

  int _updateCount = 0;
  int _fieldRequestId = 0;
  bool isLoader = false;

  bool isMaintenanceBaseLoader = false;
  bool isPipelineLoader = false;
  bool isSectionLoader = false;
  bool isTlpNumberLoader = false;
  bool isTaskLoader = false;
  bool isFieldLoader = false;

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

  List<CpOptionModel> tlpNumberList = [];
  CpOptionModel tlpNumberData = CpOptionModel();

  final List<CpOptionModel> tlpTypeList =
      _tlpTypes.map((type) => CpOptionModel.value(id: type, name: type)).toList();
  CpOptionModel tlpTypeData = CpOptionModel();

  // Additional TLP Connection is optional: "None" sends an empty value
  final List<CpOptionModel> additionalTlpConnectionList = [
    CpOptionModel.value(id: "", name: "None"),
    ..._tlpTypes.map((type) => CpOptionModel.value(id: type, name: type)),
  ];
  CpOptionModel additionalTlpConnectionData = CpOptionModel();

  /// Selected task: id goes to the API, name is shown in the form
  CpOptionModel taskData = CpOptionModel();

  List<PspFieldModel> fieldList = [];
  final Map<String, TextEditingController> fieldControllers = {};
  final Map<String, CpOptionModel> fieldOptionValues = {};

  TextEditingController taskController = TextEditingController();
  TextEditingController chainageController = TextEditingController();
  TextEditingController locationDetailsController = TextEditingController();
  TextEditingController magnesiumAnodeReadingController = TextEditingController();
  TextEditingController dateOfReadingController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  PspMonitoringBloc() : super(PspMonitoringInitial()) {
    on<PspMonitoringPageLoadEvent>(_pageLoad);
    on<PspSelectRegionEvent>(_selectRegion);
    on<PspSelectMaintenanceBaseEvent>(_selectMaintenanceBase);
    on<PspSelectPipelineEvent>(_selectPipeline);
    on<PspSelectSectionEvent>(_selectSection);
    on<PspSelectYearEvent>(_selectYear);
    on<PspSelectMonthEvent>(_selectMonth);
    on<PspSelectTlpNumberEvent>(_selectTlpNumber);
    on<PspSelectTlpTypeEvent>(_selectTlpType);
    on<PspSelectAdditionalTlpConnectionEvent>(_selectAdditionalTlpConnection);
    on<PspSelectFieldOptionEvent>(_selectFieldOption);
    on<PspSelectDateOfReadingEvent>(_selectDateOfReading);
    on<PspSubmitInspectionEvent>(_submit);
  }

  @override
  Future<void> close() {
    for (final controller in fieldControllers.values) {
      controller.dispose();
    }
    return super.close();
  }

  _pageLoad(PspMonitoringPageLoadEvent event, emit) async {
    emit(PspMonitoringPageLoadState());
    _resetLoaders();
    regionList = [];
    regionData = CpOptionModel();
    maintenanceBaseList = [];
    maintenanceBaseData = CpOptionModel();
    yearData = CpOptionModel();
    monthData = CpOptionModel();
    _clearPipeline();

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

  _selectRegion(PspSelectRegionEvent event, emit) async {
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

  _selectMaintenanceBase(PspSelectMaintenanceBaseEvent event, emit) async {
    maintenanceBaseData = event.maintenanceBaseData;
    _clearPipeline();
    isPipelineLoader = true;
    _eventCompleted(emit);

    pipelineList = await _helper.fetchPipelines(maintenanceBaseData: maintenanceBaseData);
    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectPipeline(PspSelectPipelineEvent event, emit) async {
    pipelineData = event.pipelineData;
    _clearSection();
    isSectionLoader = true;
    _eventCompleted(emit);

    sectionList = await _helper.fetchSections(pipelineData: pipelineData);
    isSectionLoader = false;
    _eventCompleted(emit);
  }

  _selectSection(PspSelectSectionEvent event, emit) async {
    sectionData = event.sectionData;
    tlpNumberList = [];
    _clearInspection();
    _clearTask();
    isTlpNumberLoader = true;
    _eventCompleted(emit);

    tlpNumberList = await _helper.fetchTlpNumbers(sectionData: sectionData);
    isTlpNumberLoader = false;
    _eventCompleted(emit);
    await _loadTask(emit);
  }

  _selectYear(PspSelectYearEvent event, emit) async {
    yearData = event.yearData;
    _eventCompleted(emit);
    await _loadTask(emit);
  }

  _selectMonth(PspSelectMonthEvent event, emit) async {
    monthData = event.monthData;
    _eventCompleted(emit);
    await _loadTask(emit);
  }

  _selectTlpNumber(PspSelectTlpNumberEvent event, emit) async {
    tlpNumberData = event.tlpNumberData;
    chainageController.text = "";
    locationDetailsController.text = "";
    _eventCompleted(emit);

    // Chainage & Location Details of the TLP
    final details = await _helper.fetchTlpDetails(tlpNumberData: tlpNumberData);
    if (details != null) {
      chainageController.text = details['chainage']?.toString() ?? "";
      locationDetailsController.text = details['location_detail']?.toString() ?? "";
    }
    _eventCompleted(emit);
  }

  _selectTlpType(PspSelectTlpTypeEvent event, emit) async {
    tlpTypeData = event.tlpTypeData;
    await _loadFields(emit);
  }

  _selectAdditionalTlpConnection(PspSelectAdditionalTlpConnectionEvent event, emit) async {
    additionalTlpConnectionData = event.additionalTlpConnectionData;
    await _loadFields(emit);
  }

  _selectFieldOption(PspSelectFieldOptionEvent event, emit) {
    fieldOptionValues[event.slug] = event.optionData;
    _eventCompleted(emit);
  }

  _selectDateOfReading(PspSelectDateOfReadingEvent event, emit) async {
    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: "Select Date of Reading",
    );
    if (selectedDate != null) {
      dateOfReadingController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      _eventCompleted(emit);
    }
  }

  _submit(PspSubmitInspectionEvent event, emit) async {
    BuildContext context = event.context;
    final isValid = PspMonitoringHelper.textFieldValidation(
      context: context,
      regionData: regionData,
      maintenanceBaseData: maintenanceBaseData,
      pipelineData: pipelineData,
      sectionData: sectionData,
      yearData: yearData,
      monthData: monthData,
      taskData: taskData,
      tlpNumberData: tlpNumberData,
      tlpTypeData: tlpTypeData,
      dateOfReadingController: dateOfReadingController,
    );
    if (!isValid) return;

    // Field name -> controller of every reading input
    final isNumberValid = PspMonitoringHelper.numberFieldValidation(
      context: context,
      fields: {
        "Magnesium Anode Reading": magnesiumAnodeReadingController,
        for (final field in fieldList.where((field) => !field.isDropdown))
          if (fieldControllers[field.slug] != null) field.name: fieldControllers[field.slug]!,
      },
    );
    if (!isNumberValid) return;

    isLoader = true;
    _eventCompleted(emit);

    final dateOfReading = DateFormat('dd-MM-yyyy').parse(dateOfReadingController.text.trim());
    final body = <String, dynamic>{
      "region_id": regionData.id,
      "maintenancebase_id": maintenanceBaseData.id,
      "pipeline_id": pipelineData.id,
      "section_id": sectionData.id,
      "year": yearData.id,
      "month": monthData.id,
      "task_id": taskData.id,
      "tlp_no": tlpNumberData.id,
      "tlp_type": tlpTypeData.id,
      "add_tlp_conn": additionalTlpConnectionData.id ?? "",
      "magnesium_anode_reading": magnesiumAnodeReadingController.text.trim(),
      "date_of_reading": DateFormat('yyyy-MM-dd').format(dateOfReading),
      "remarks": remarksController.text.trim(),
    };
    // Dynamic fields: key = field_alias
    for (final field in fieldList) {
      body[field.slug] = field.isDropdown
          ? fieldOptionValues[field.slug]?.id ?? ""
          : fieldControllers[field.slug]?.text.trim() ?? "";
    }

    var res = await _helper.submit(context: context, body: body);
    if (res != null) {
      // Keep Region...Month and Task for the next TLP, clear the readings
      _clearInspection();
    }
    isLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _loadTask(Emitter<PspMonitoringState> emit) async {
    if (sectionData.id == null || yearData.id == null || monthData.id == null) return;
    _clearTask();
    isTaskLoader = true;
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
    taskController.text = taskData.name ?? "";
    isTaskLoader = false;
    _eventCompleted(emit);
  }

  Future<void> _loadFields(Emitter<PspMonitoringState> emit) async {
    if (tlpTypeData.id == null) return;
    // Only the latest request is used when the user changes the type quickly
    final requestId = ++_fieldRequestId;
    isFieldLoader = true;
    _eventCompleted(emit);

    final fields = await _helper.fetchFields(
      tlpType: tlpTypeData.id!,
      additionalTlpConnection: additionalTlpConnectionData.id ?? "",
    );
    if (requestId != _fieldRequestId) return;

    fieldList = fields;
    // Keep values of fields that are still shown (same slug), drop the others
    final slugs = fieldList.map((field) => field.slug).toSet();
    // Removed controllers are not disposed: the old form may still use them until it rebuilds
    fieldControllers.removeWhere((slug, controller) => !slugs.contains(slug));
    fieldOptionValues.removeWhere((slug, value) => !slugs.contains(slug));
    for (final field in fieldList.where((field) => !field.isDropdown)) {
      fieldControllers.putIfAbsent(field.slug, () => TextEditingController());
    }

    isFieldLoader = false;
    _eventCompleted(emit);
  }

  void _resetLoaders() {
    isLoader = false;
    isMaintenanceBaseLoader = false;
    isPipelineLoader = false;
    isSectionLoader = false;
    isTlpNumberLoader = false;
    isTaskLoader = false;
    isFieldLoader = false;
  }

  void _clearPipeline() {
    pipelineList = [];
    pipelineData = CpOptionModel();
    _clearSection();
  }

  void _clearSection() {
    sectionList = [];
    sectionData = CpOptionModel();
    tlpNumberList = [];
    _clearTask();
    _clearInspection();
  }

  void _clearTask() {
    taskData = CpOptionModel();
    taskController.text = "";
  }

  void _clearInspection() {
    _fieldRequestId++;
    isFieldLoader = false;
    tlpNumberData = CpOptionModel();
    tlpTypeData = CpOptionModel();
    additionalTlpConnectionData = CpOptionModel();
    fieldList = [];
    fieldControllers.clear();
    fieldOptionValues.clear();
    chainageController.text = "";
    locationDetailsController.text = "";
    magnesiumAnodeReadingController.text = "";
    dateOfReadingController.text = "";
    remarksController.text = "";
  }

  _eventCompleted(Emitter<PspMonitoringState> emit) {
    emit(FetchPspMonitoringDataState(
      updateCount: ++_updateCount,
      isLoader: isLoader,
      isMaintenanceBaseLoader: isMaintenanceBaseLoader,
      isPipelineLoader: isPipelineLoader,
      isSectionLoader: isSectionLoader,
      isTlpNumberLoader: isTlpNumberLoader,
      isTaskLoader: isTaskLoader,
      isFieldLoader: isFieldLoader,
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
      tlpNumberList: tlpNumberList,
      tlpNumberData: tlpNumberData,
      tlpTypeList: tlpTypeList,
      tlpTypeData: tlpTypeData,
      additionalTlpConnectionList: additionalTlpConnectionList,
      additionalTlpConnectionData: additionalTlpConnectionData,
      fieldList: List.unmodifiable(fieldList),
      fieldControllers: Map.unmodifiable(fieldControllers),
      fieldOptionValues: Map.unmodifiable(fieldOptionValues),
      taskController: taskController,
      chainageController: chainageController,
      locationDetailsController: locationDetailsController,
      magnesiumAnodeReadingController: magnesiumAnodeReadingController,
      dateOfReadingController: dateOfReadingController,
      remarksController: remarksController,
    ));
  }
}
