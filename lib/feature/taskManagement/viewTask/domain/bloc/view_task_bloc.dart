import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_filter_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/helper/view_task_helper.dart';

part 'view_task_event.dart';
part 'view_task_state.dart';

class ViewTaskBloc extends Bloc<ViewTaskEvent, ViewTaskState> {

  List<TaskDataModel> _taskDataList = [];
  List<TaskDataModel> get taskDataList => _taskDataList;

  int _selectedDay =  0;
  int get selectedDay => _selectedDay;
  DateTime dateTime =  DateTime.now();

  List<TaskFilterModel> _taskFilterList = [];
  List<TaskFilterModel> get taskFilterList => _taskFilterList;

  bool _isLoader =  false;
  bool get isLoader => _isLoader;

  ViewTaskBloc() : super(ViewTaskInitial()) {
   on<ViewTaskPageLoadEvent>(_pageLoad);
   on<ViewTaskSelectedDayEvent>(_selectDay);
   on<ViewTaskSelectedFilterStatusEvent>(_selectFilterStatus);
  }

  _pageLoad(ViewTaskPageLoadEvent event, emit) async {
    emit(ViewTaskPageLoadState());
    _taskDataList = [];
    _taskFilterList = [];
    _isLoader =  false;
     dateTime =  DateTime.now();
    _selectedDay =  dateTime.day;
    var res =  await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(res != null)
    {
      _taskDataList =  res;
    }

    _taskFilterList =  TaskFilterModel().getData();
    _eventComplete(emit);
  }

  _selectDay(ViewTaskSelectedDayEvent event, emit) async
  {
    _selectedDay =  event.selectedIndex;
    _eventComplete(emit);
  }

  _selectFilterStatus(ViewTaskSelectedFilterStatusEvent event, emit) async
  {
    _isLoader =  true;
    _eventComplete(emit);
    if(event.selectedIndex == 0 && taskFilterList[event.selectedIndex].isSelected == false){
      _taskFilterList =  TaskFilterModel().getData();
    } else if(event.selectedIndex != 0){
        _taskFilterList[0].isSelected = false;
      _taskFilterList[event.selectedIndex].isSelected =
        taskFilterList[event.selectedIndex].isSelected  == true ? false : true;
    }
    _isLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewTaskState> emit) {
     emit(FetchViewTaskDataState(
         taskDataList: taskDataList,
         selectedDay: selectedDay,
         taskFilterList: taskFilterList,
         isLoader: isLoader,
     ));
  }
}
