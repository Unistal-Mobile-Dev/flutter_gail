import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/task/viewTask/helper/task_helper.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  bool isLoader =  false;
  List<TaskModel> taskList = [];
  List<TaskModel> searchTaskList = [];
  TaskModel taskData =  TaskModel();

  TaskBloc() : super(TaskInitial()) {
    on<TaskPageLoadEvent>(_pageLoad);
    on<TaskPageSelectDataEvent>(_selectTask);
    on<TaskTabIndexEvent>(_tabIndex);
  }

  _pageLoad(TaskPageLoadEvent event, emit) async {
    emit(TaskPageLoadState());
    isLoader =  false;
    taskList = [];
    searchTaskList = [];
    taskData =  TaskModel();
    var res = await TaskHelper.fetchTask();
    taskList =  res ?? [];
    searchTaskList  =  taskList;
    taskList = searchTaskList.where((taskData) => taskData.patrollManStatus.toString() == "0").toList();
    _eventComplete(emit);
  }

  _tabIndex(TaskTabIndexEvent event, emit) {
    if(event.tabIndex == 0){
      taskList = searchTaskList.where((taskData) => taskData.patrollManStatus.toString() == "0").toList();
    }
    else if(event.tabIndex == 1){
      taskList = searchTaskList.where((taskData) => taskData.patrollManStatus.toString() != "0"
           && taskData.patrollManStatus.toString() != "2" ).toList();
    }
    else if(event.tabIndex == 2){
      taskList = searchTaskList.where((taskData) => taskData.patrollManStatus.toString() == "2" ).toList();
    }
    _eventComplete(emit);
  }

  _selectTask(TaskPageSelectDataEvent event, emit) {
    taskData =  taskList[event.index];
    _eventComplete(emit);
  }

  _eventComplete(Emitter<TaskState> emit) {
    emit(FetchTaskDataState(
        isLoader: isLoader,
        taskList: taskList,
        searchTaskList: searchTaskList
    ));
  }
}
