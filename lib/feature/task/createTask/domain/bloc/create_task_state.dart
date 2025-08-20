part of 'create_task_bloc.dart';

sealed class CreateTaskState extends Equatable {
  const CreateTaskState();
}

final class CreateTaskInitial extends CreateTaskState {
  @override
  List<Object> get props => [];
}

final class CreateTaskPageLoadState extends CreateTaskInitial {}


final class FetchCreateTaskDataState extends CreateTaskInitial {
  final bool isLoader;
  final List<ShiftTypeModel> shiftList;
  final ShiftTypeModel shiftData;
  final List<LineModel> lineList;
  final LineModel lineData;
  final TextEditingController startPatrollingDateController;
  final TextEditingController endPatrollingDateController;
  final TextEditingController startPatrollingTimeController;
  final TextEditingController endPatrollingTimeController;
  final TextEditingController taskDateController;
  final List<TaskTypeModel> taskTypeList;
  final TaskTypeModel taskTypeData;
  final List<RegionTypeModel> regionTypeList;
  final RegionTypeModel regionTypeData;
  final List<MaintenanceTypeModel> maintenanceTypeList;
  final MaintenanceTypeModel maintenanceTypeData ;
  final List<PipelineModel> pipelineList;
  final PipelineModel pipelineData;
  final List<RouteModel> routeList;
  final RouteModel routeData;
  final List<ShiftGroupModel> shiftGroupList;
  final ShiftGroupModel shiftGroupData;
  final List<UserTypeModel> userTypeList;
  final UserTypeModel userTypeData;
  final List<VendorModel> vendorList;
  final VendorModel vendorData;
  final List<WalkerModel> walkerList;
  final WalkerModel walkerData;
  final List<SectionModel> sectionList;
  final SectionModel sectionData;
  final List<RepeatFrequencyModel> repeatFrequencyList;
  final RepeatFrequencyModel repeatFrequencyData;
  final List<UserNameModel> userNameList;
  final List<UserNameModel> userNameData;
  final bool isMaintenanceLoader;
  final bool isPipelineNameLoader;
  final bool isSectionNameLoader;
  final bool isPatrolRouteNameLoader;
  final bool isVendorLoader;
  final bool isUserNameLoader;
  final List<SupervisorUsersModel> supervisorUsersList;
  final SupervisorUsersModel supervisorUsersData;
  final List<LineWalkerUsersModel> lineWalkerUsersList;
  final List<LineWalkerUsersModel> lineWalkerUsersData;

  FetchCreateTaskDataState({
    required this.isLoader,
    required this.isVendorLoader,
    required this.isUserNameLoader,
    required this.endPatrollingDateController,
    required this.endPatrollingTimeController,
    required this.lineData,
    required this.lineList,
    required this.shiftData,
    required this.shiftList,
    required this.startPatrollingDateController,
    required this.startPatrollingTimeController,
    required this.taskDateController,
    required this.vendorData,
    required this.userTypeData,
    required this.shiftGroupData,
    required this.routeData,
    required this.pipelineData,
    required this.taskTypeData,
    required this.vendorList,
    required this.maintenanceTypeData,
    required this.maintenanceTypeList,
    required this.pipelineList,
    required this.regionTypeData,
    required this.regionTypeList,
    required this.routeList,
    required this.shiftGroupList,
    required this.taskTypeList,
    required this.userTypeList,
    required this.walkerData,
    required this.walkerList,
    required this.sectionList,
    required this.sectionData,
    required this.repeatFrequencyData,
    required this.repeatFrequencyList,
    required this.userNameData,
    required this.userNameList,
    required this.isMaintenanceLoader,
    required this.isPatrolRouteNameLoader,
    required this.isPipelineNameLoader,
    required this.isSectionNameLoader,
    required this.lineWalkerUsersData,
    required this.lineWalkerUsersList,
    required this.supervisorUsersData,
    required this.supervisorUsersList,
  });

  @override
  List<Object> get props => [
    isLoader,
    isVendorLoader,
    isUserNameLoader,
    isLoader,
    endPatrollingDateController,
    endPatrollingTimeController,
    lineData,
    lineList,
    shiftData,
    shiftList,
    startPatrollingDateController,
    startPatrollingTimeController,
    taskDateController,
    vendorData,
    userTypeData,
    shiftGroupData,
    routeData,
    pipelineData,
    taskTypeData,
    vendorList,
    maintenanceTypeData,
    maintenanceTypeList,
    pipelineList,
    regionTypeData,
    regionTypeList,
    routeList,
    shiftGroupList,
    taskTypeList,
    userTypeList,
    walkerData,
    walkerList,
    sectionList,
    sectionData,
    repeatFrequencyData,
    repeatFrequencyList,
    userNameData,
    userNameList,
    isMaintenanceLoader,
    isPatrolRouteNameLoader,
    isPipelineNameLoader,
    isSectionNameLoader,
    lineWalkerUsersData,
    lineWalkerUsersList,
    supervisorUsersData,
    supervisorUsersList,
  ];
}