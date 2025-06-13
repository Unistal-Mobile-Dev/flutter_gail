import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/domain/models/permissions_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/task/viewTask/helper/task_helper.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  bool isLoader =  false;
  List<TaskModel> taskList = [];
  List<TaskModel> searchTaskList = [];
  TaskModel taskData =  TaskModel();
  int tabIndex = 0;

  DateTime startDate =  DateTime.now();
  DateTime endDate =  DateTime.now();

  bool isAssignTask = false;
  LoginDataModel userData =  LoginDataModel();

  TaskBloc() : super(TaskInitial()) {
    on<TaskPageLoadEvent>(_pageLoad);
    on<TaskPageSelectDateEvent>(_selectDate);
    on<TaskPageSelectDataEvent>(_selectTask);
    on<TaskPagRefreshDataEvent>(_pageRefresh);
    on<TaskTabIndexEvent>(_tabIndex);
  }

  _pageLoad(TaskPageLoadEvent event, emit) async {
    emit(TaskPageLoadState());
    isLoader =  false;
    isAssignTask = false;
    taskList = [];
    searchTaskList = [];
    tabIndex = 0;
    taskData =  TaskModel();
    startDate = DateTime.now().subtract(const Duration(days: 7));
    endDate =  DateTime.now();
    userData =  UserInfo.instance!.userData!;
    if(userData.modules != null){
      for(var moduleData in userData.modules!) {
        if(moduleData.permissionList != null){
          for(var permissionData in moduleData.permissionList!){
            if(permissionData.name.toString().toLowerCase() == "write"){
              isAssignTask =  permissionData.value ?? false;
            }
          }
        }
      }
    }

    var res = await TaskHelper.fetchTask(startDate: startDate.toString(), endDate: endDate.toString());
    taskList =  res ?? [];
    searchTaskList  =  taskList;
    taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.notStarted).toList();
    _eventComplete(emit);

    if(taskList.isNotEmpty){
      TaskHelper.showNotificationWithNumber();
    }
  }

  _selectDate(TaskPageSelectDateEvent event, emit) async {
    try{
      DateTimeRange? dateTimeRange = await showDateRangePicker(
        context: !event.context.mounted ? event.context : event.context,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime.now(),
        currentDate: DateTime.now(),
        initialDateRange: DateTimeRange(start: startDate, end: endDate),
        saveText: 'Done',
      );
      if(dateTimeRange != null){
        startDate =  dateTimeRange.start;
        endDate =  dateTimeRange.end;
        isLoader =  true;
        taskList = [];
        searchTaskList = [];
        _eventComplete(emit);
        var res = await TaskHelper.fetchTask(startDate: startDate.toString(), endDate: endDate.toString());
        taskList =  res ?? [];
        searchTaskList  =  taskList;
        if(tabIndex == 0){
          taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.notStarted).toList();
        }
        else if(tabIndex== 1){
          taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.started
              || taskData.taskStatus == TaskStatus.pause  || taskData.taskStatus == TaskStatus.resume).toList();
        }
        else if(tabIndex == 2){
          taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.completed  ).toList();
        }
      }
    }catch(_){}

    isLoader =  false;
    _eventComplete(emit);
  }

  _tabIndex(TaskTabIndexEvent event, emit) {
    tabIndex =  event.tabIndex;
    if(tabIndex == 0){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.notStarted).toList();
    }
    else if(tabIndex== 1){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.started
          || taskData.taskStatus == TaskStatus.pause  || taskData.taskStatus == TaskStatus.resume).toList();
    }
    else if(tabIndex == 2){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.completed  ).toList();
    }
    _eventComplete(emit);
  }

  _selectTask(TaskPageSelectDataEvent event, emit) {
    taskData =  taskList[event.index];
    _eventComplete(emit);
  }

  _pageRefresh(TaskPagRefreshDataEvent event, emit) async {
    var res = await TaskHelper.fetchTask(startDate: startDate.toString(), endDate: endDate.toString());
    taskList =  res ?? [];
    searchTaskList  =  taskList;
    if(tabIndex == 0){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.notStarted).toList();
    }
    else if(tabIndex== 1){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.started
          || taskData.taskStatus == TaskStatus.pause  || taskData.taskStatus == TaskStatus.resume).toList();
    }
    else if(tabIndex == 2){
      taskList = searchTaskList.where((taskData) => taskData.taskStatus == TaskStatus.completed  ).toList();
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<TaskState> emit) {
    emit(FetchTaskDataState(
        isLoader: isLoader,
        isAssignTask: isAssignTask,
        taskList: taskList,
        searchTaskList: searchTaskList
    ));
  }
}
