import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/line_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/maintenance_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/repeat_frequency_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/route_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/section_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_group_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/task_from_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/task_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/vendor_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/walker_model.dart';
import 'package:flutter_gail/feature/task/createTask/helper/create_task_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {

  bool isLoader =  false;
  List<ShiftTypeModel> shiftList = [];
  ShiftTypeModel shiftData = ShiftTypeModel();
  List<LineModel> lineList = [];
  LineModel lineData =  LineModel();
  TextEditingController startPatrollingDateController =  TextEditingController();
  TextEditingController endPatrollingDateController =  TextEditingController();
  TextEditingController startPatrollingTimeController =  TextEditingController();
  TextEditingController endPatrollingTimeController =  TextEditingController();
  TextEditingController taskDateController = TextEditingController();

  List<TaskTypeModel> taskTypeList = [];
  TaskTypeModel taskTypeData =  TaskTypeModel();

  List<RegionTypeModel> regionTypeList = [];
  RegionTypeModel regionTypeData =  RegionTypeModel();

  List<MaintenanceTypeModel> maintenanceTypeList = [];
  MaintenanceTypeModel maintenanceTypeData =  MaintenanceTypeModel();

  List<PipelineModel> pipelineList = [];
  PipelineModel pipelineData =  PipelineModel();

  List<RouteModel> routeList = [];
  RouteModel routeData =  RouteModel();

  List<ShiftGroupModel> shiftGroupList = [];
  ShiftGroupModel shiftGroupData =  ShiftGroupModel();

  List<UserTypeModel> userTypeList = [];
  UserTypeModel userTypeData =  UserTypeModel();

  List<VendorModel> vendorList = [];
  VendorModel vendorData =  VendorModel();

  List<WalkerModel> walkerList = [];
  WalkerModel walkerData =  WalkerModel();

  List<SectionModel> sectionList = [];
  SectionModel sectionData =  SectionModel();

  List<RepeatFrequencyModel> repeatFrequencyList = [];
  List<RepeatFrequencyModel> repeatFrequencyData = [];

  List<UserNameModel> userNameList = [];
  List<UserNameModel> userNameData =  [];

  List<TaskFromModel> taskFromList  = [];

  List<ShiftTypeModel> allShiftList = [];

  CreateTaskBloc() : super(CreateTaskInitial()) {
    on<CreateTaskPageLoadEvent>(_pageLoad);
    on<CreateTaskSelectLineDataEvent>(_lineData);
    on<CreateTaskSelectShitDataEvent>(_shiftData);
    on<CreateTaskStartPatrollingDateEvent>(_startPatrollingDate);
    on<CreateTaskStartPatrollingTimeEvent>(_startPatrollingTime);
    on<CreateTaskEndPatrollingDateEvent>(_endPatrollingDate);
    on<CreateTaskEndPatrollingTimeEvent>(_endPatrollingTime);
    on<CreateTaskDateEvent>(_taskDate);
    on<CreateTaskRegionEvent>(_selectRegion);
    on<CreateTaskMaintenanceTypeEvent>(_selectMaintenance);
    on<CreateTaskTypeEvent>(_selectTaskType);
    on<CreateTaskPipelineTypeEvent>(_selectPipeline);
    on<CreateTaskRouteEvent>(_selectRoute);
    on<CreateTaskShiftGroupEvent>(_selectShiftGroup);
    on<CreateTaskUserTypeEvent>(_selectUserType);
    on<CreateTaskVendorEvent>(_selectVendor);
    on<CreateTaskSectionTypeEvent>(_selectSection);
    on<CreateTaskRepeatFrequencyEvent>(_selectRepeatFrequency);
    on<CreateTaskUserNameEvent>(_selectUserName);
    on<CreateTaskSubmitEvent>(_submit);
  }

  _pageLoad(CreateTaskPageLoadEvent event, emit) async {
    emit(CreateTaskPageLoadState());
    isLoader =  false;
    shiftData = ShiftTypeModel();
    lineData =  LineModel();
    startPatrollingDateController.text = "";
    endPatrollingDateController.text = "";
    startPatrollingTimeController.text = "";
    endPatrollingTimeController.text = "";
    taskDateController.text = "";
    lineList = [];
    shiftList = [];
    taskFromList = [];
    routeData = RouteModel();
    shiftData =  ShiftTypeModel();
    repeatFrequencyData =  [];
    userTypeData =  UserTypeModel();
    vendorData =  VendorModel();
    userNameData =  [];
    allShiftList = [];
    regionTypeData =  RegionTypeModel();
    maintenanceTypeData =  MaintenanceTypeModel();
    pipelineData =  PipelineModel();
    sectionData =  SectionModel();
    shiftGroupList = [];


    var resRegion =  await CreateTaskHelper.fetchArea();
    if(resRegion !=  null){
      regionTypeList =  resRegion;
    }

    var taskFromListRes = await CreateTaskHelper.fetchTaskDropDownValuesList();
    allShiftList = taskFromListRes.shiftList;
    userNameList =  taskFromListRes.userNameList;
    routeList =  taskFromListRes.routeList;
    vendorList =  taskFromListRes.vendorList;
    userTypeList =  taskFromListRes.userTypeList;
    shiftList =  allShiftList;

    repeatFrequencyList =  await CreateTaskHelper.fetchRepeatFrequency();


    _eventComplete(emit);
  }

  _lineData(CreateTaskSelectLineDataEvent event, emit) {
    lineData =  event.lineData;
    _eventComplete(emit);
  }

  _shiftData(CreateTaskSelectShitDataEvent event, emit) {
    shiftData =  event.shiftData;
    _eventComplete(emit);
  }

  _startPatrollingDate(CreateTaskStartPatrollingDateEvent event, emit) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(event.dateTime);
    startPatrollingDateController.text = formattedDate;
    _eventComplete(emit);
  }

  _startPatrollingTime(CreateTaskStartPatrollingTimeEvent event, emit) {
    String time = event.duration.toString().replaceAll(".000000", "");
    startPatrollingTimeController.text =  time;
    _eventComplete(emit);
  }

  _endPatrollingDate(CreateTaskEndPatrollingDateEvent event, emit) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(event.dateTime);
    endPatrollingDateController.text = formattedDate;
    _eventComplete(emit);
  }

  _endPatrollingTime(CreateTaskEndPatrollingTimeEvent event, emit) {
    String time = event.duration.toString().replaceAll(".000000", "");
    endPatrollingTimeController.text =  time;
    _eventComplete(emit);
  }

  _taskDate(CreateTaskDateEvent event, emit) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(event.dateTime);
    taskDateController.text = formattedDate;
    _eventComplete(emit);
  }

  _selectRegion(CreateTaskRegionEvent event, emit) async{
    regionTypeData =  event.regionTypeData;
    maintenanceTypeList = [];
    maintenanceTypeData =  MaintenanceTypeModel();
    _eventComplete(emit);

    var resMaintenance = await CreateTaskHelper.fetchMaintenance(regionData: regionTypeData);
    if(resMaintenance != null){
      maintenanceTypeList =  resMaintenance;
    }
    _eventComplete(emit);
  }

  _selectMaintenance(CreateTaskMaintenanceTypeEvent event, emit) async {
    maintenanceTypeData =  event.maintenanceTypeData;
    pipelineList = [];
    pipelineData = PipelineModel();
    _eventComplete(emit);
    var resPipeline = await CreateTaskHelper.fetchPipeline(
        regionData: regionTypeData, maintenanceTypeData: maintenanceTypeData);
    if(resPipeline != null){
      pipelineList =  resPipeline;
    }
    _eventComplete(emit);
  }

  _selectTaskType(CreateTaskTypeEvent event, emit) {
    taskTypeData =  event.taskTypeData;
    _eventComplete(emit);
  }

  _selectPipeline(CreateTaskPipelineTypeEvent event, emit)  async {
    pipelineData =  event.pipelineData;
    sectionList = [];
    sectionData =  SectionModel();
    _eventComplete(emit);
    var resSection = await CreateTaskHelper.fetchSection(
        regionData: regionTypeData,
        maintenanceTypeData: maintenanceTypeData,
       pipelineData: pipelineData
    );
    if(resSection != null){
      sectionList =  resSection;
    }
    _eventComplete(emit);
  }

  _selectRoute(CreateTaskRouteEvent event, emit) {
    routeData =  event.routeData;
    _eventComplete(emit);
  }

  _selectShiftGroup(CreateTaskShiftGroupEvent event, emit) {
    int index =  event.index;
    String selectedValue =  event.selectedValue;
    isLoader =  true;
    _eventComplete(emit);
    shiftGroupList[index].selectedValue = selectedValue;

    isLoader =  false;
    _eventComplete(emit);
  }

  _selectUserType(CreateTaskUserTypeEvent event, emit) async{
    userTypeData =  event.userTypeData;
    vendorList = [];
    _eventComplete(emit);

    var resVendor =  await CreateTaskHelper.fetchVendor(userTypeData: userTypeData);
    if(resVendor != null){
      vendorList = resVendor;
    }
    _eventComplete(emit);
  }

  _selectVendor(CreateTaskVendorEvent event, emit) async {
    vendorData =  event.vendorData;
    userNameList = [];
    _eventComplete(emit);
    var resUserName =  await CreateTaskHelper.fetchUserName(
        userTypeData: userTypeData, vendorData: vendorData);
    if(resUserName != null){
      userNameList = resUserName;
    }
    _eventComplete(emit);
  }

  _selectSection(CreateTaskSectionTypeEvent event, emit) {
    sectionData =  event.sectionData;
    _eventComplete(emit);
  }

  _selectRepeatFrequency(CreateTaskRepeatFrequencyEvent event, emit) {
    repeatFrequencyData = event.repeatFrequencyData;
    _eventComplete(emit);
  }

  _selectUserName(CreateTaskUserNameEvent event, emit) {
    userNameData = event.userNameData;
    shiftGroupList = [];

    for(var userData in userNameData){
      shiftGroupList.add(
        ShiftGroupModel(
           userNameData: userData,
           selectedValue: "",
           shiftList: shiftList.where((element)
           =>  element.sgCode.toString() == shiftData.sgCode.toString()).toList(),
        )
      );
    }
    _eventComplete(emit);
  }

  _submit(CreateTaskSubmitEvent event, emit) async {
    isLoader =  true;
    _eventComplete(emit);
    var textFiledValidation =  await CreateTaskHelper.textFieldValidationCheck(
        context: !event.context.mounted ?  event.context : event.context,
        regionData: regionTypeData,
        maintenanceData: maintenanceTypeData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        routeModel: routeData,
        routeLength: routeData.length !=  null ? routeData.length.toString(): "",
        shiftData: shiftData,
        shiftGroupList: shiftGroupList,
        userNameList: userNameData,
        userTypeModel: userTypeData,
        assignedStartDate: startPatrollingDateController.text.toString(),
        assignedEndDate: endPatrollingDateController.text.toString(),
        repeatFrequencyList: repeatFrequencyData,
        vendorData: vendorData);
    if(textFiledValidation == false){
      isLoader =  false;
      _eventComplete(emit);
      return ;
    }
    isLoader =  true;
    _eventComplete(emit);
    var res =  await CreateTaskHelper.submitData(
        context: !event.context.mounted ?  event.context : event.context,
        regionData: regionTypeData,
        maintenanceData: maintenanceTypeData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        routeModel: routeData,
        routeLength: routeData.length !=  null ? routeData.length.toString(): "",
        shiftData: shiftData,
        shiftGroupList: shiftGroupList,
        userNameList: userNameData,
        userTypeModel: userTypeData,
        assignedStartDate: startPatrollingDateController.text.toString(),
        assignedEndDate: endPatrollingDateController.text.toString(),
        repeatFrequencyList: repeatFrequencyData,
        vendorData: vendorData);
    if(res != null){
      isLoader =  false;
      shiftData = ShiftTypeModel();
      lineData =  LineModel();
      startPatrollingDateController.text = "";
      endPatrollingDateController.text = "";
      startPatrollingTimeController.text = "";
      endPatrollingTimeController.text = "";
      taskDateController.text = "";
      routeData = RouteModel();
      shiftData =  ShiftTypeModel();
      repeatFrequencyData =  [];
      userTypeData =  UserTypeModel();
      vendorData =  VendorModel();
      userNameData =  [];
      allShiftList = [];
      regionTypeData =  RegionTypeModel();
      maintenanceTypeData =  MaintenanceTypeModel();
      pipelineData =  PipelineModel();
      sectionData =  SectionModel();
      shiftGroupList = [];
    }
    isLoader =  false;
    _eventComplete(emit);

  }

  _eventComplete(Emitter<CreateTaskState> emit) {
    emit(FetchCreateTaskDataState(
      isLoader: isLoader,
      endPatrollingDateController: endPatrollingDateController,
      endPatrollingTimeController: endPatrollingTimeController,
      lineData: lineData,
      lineList: lineList,
      shiftData: shiftData,
      shiftList: shiftList,
      startPatrollingDateController: startPatrollingDateController,
      startPatrollingTimeController: startPatrollingTimeController,
      taskDateController: taskDateController,
      maintenanceTypeData: maintenanceTypeData,
      maintenanceTypeList: maintenanceTypeList,
      pipelineData: pipelineData,
      pipelineList: pipelineList,
      regionTypeData: regionTypeData,
      regionTypeList: regionTypeList,
      routeData: routeData,
      routeList: routeList,
      shiftGroupData: shiftGroupData,
      shiftGroupList: shiftGroupList,
      taskTypeData: taskTypeData,
      taskTypeList: taskTypeList,
      userTypeData: userTypeData,
      userTypeList: userTypeList,
      vendorData: vendorData,
      vendorList: vendorList,
      walkerData: walkerData,
      walkerList: walkerList,
      sectionData: sectionData,
      sectionList: sectionList,
      repeatFrequencyData: repeatFrequencyData,
      repeatFrequencyList: repeatFrequencyList,
      userNameData: userNameData,
      userNameList: userNameList,
    ));
  }
}
