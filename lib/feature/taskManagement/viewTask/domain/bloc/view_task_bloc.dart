import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_filter_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/helper/view_task_helper.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

part 'view_task_event.dart';
part 'view_task_state.dart';

enum TaskView { days, monthly}

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
  late PageController pageController;

  TaskView taskView =  TaskView.days;
  List<TaskModel> _taskList = [];
  List<TaskModel> get taskList => _taskList;

  ViewTaskBloc() : super(ViewTaskInitial()) {
   on<ViewTaskPageLoadEvent>(_pageLoad);
   on<ViewTaskSelectCalendarTypeEvent>(_selectCalendarType);
   on<ViewTaskPageSelectDateEvent>(_selectDate);
   on<ViewTaskSelectedDayEvent>(_selectDay);
   on<ViewTaskSelectedMonthEvent>(_selectMonth);
   on<ViewTaskSelectedFilterStatusEvent>(_selectFilterStatus);
  }

  _pageLoad(ViewTaskPageLoadEvent event, emit) async {
    emit(ViewTaskPageLoadState());
    _taskDataList = [];
    _taskFilterList = [];
    _isLoader =  false;
     taskView =  TaskView.days;
     dateTime =  DateTime.now();
    _taskList = [];
    _selectedDay =  taskView == TaskView.days ? dateTime.day-1 : dateTime.month-1;

    var res;
    if(taskView == TaskView.days) {
      res =  await ViewTaskHelper.createDaysCalender(dateTime: dateTime);
      if(res != null)
      {
        _taskDataList =  res;
      }
    } else {
      res =  await ViewTaskHelper.createMonthlyCalender(dateTime: dateTime);
      if(res != null)
      {
        _taskDataList =  res;
      }
    }


    pageController =  PageController(initialPage: taskDataList.length);
    pageController = PageController(viewportFraction: 0.2);

    _taskFilterList =  TaskFilterModel().getData();
    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);

    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(taskView == TaskView.days){
      _taskList =  taskList.where((element) =>
      element.date.toString().replaceAll(" 00:00:00.000", "")
          ==  DateFormat("yyyy-MM-dd").format(dateTime).toString()).toList();
    }

    _eventComplete(emit);
  }

  _selectCalendarType(ViewTaskSelectCalendarTypeEvent event, emit) async {
    taskView =  event.taskView;
    _selectedDay =  taskView == TaskView.days ? dateTime.day-1 : dateTime.month-1;
    var res;
    if(taskView == TaskView.days) {
      res =  await ViewTaskHelper.createDaysCalender(dateTime: dateTime);
      if(res != null)
      {
        _taskDataList =  res;
      }
    } else {
      res =  await ViewTaskHelper.createMonthlyCalender(dateTime: dateTime);
      if(res != null)
      {
        _taskDataList =  res;
      }
    }

    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(taskView == TaskView.days){
      _taskList =  taskList.where((element) =>
      element.date.toString().replaceAll(" 00:00:00.000", "")
          ==  DateFormat("yyyy-MM-dd").format(dateTime).toString()).toList();
    } else
    if(taskView == TaskView.monthly){
      DateTime date =  DateTime(dateTime.year, selectedDay+1, selectedDay+1);
      _taskList =  taskList.where((element) =>
      element.month.toString() == date.month.toString()).toList();
    }
    _eventComplete(emit);
  }

  _selectDate(ViewTaskPageSelectDateEvent event, emit) async {
    BuildContext context =  event.context;

    if(taskView == TaskView.days) {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: DateTime(DateTime.now().year - 23, 1),
          lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
      );
      if (pickedDate != null) {
        dateTime =  pickedDate;
        _selectedDay =  taskView == TaskView.days ? dateTime.day-1 : dateTime.month-1;
        var res =  await ViewTaskHelper.createDaysCalender(dateTime: dateTime);
        if(res != null)
        {
          _taskDataList =  res;
        }
        _eventComplete(emit);
      } else {
        if (kDebugMode) {
          print("Date is not selected");
        }
      }
    } else if( taskView == TaskView.monthly) {
      DateTime? pickedDate = await showMonthPicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5, 5),
        lastDate: DateTime(DateTime.now().year + 8, 9),
        initialDate: dateTime,
      );
      if (pickedDate != null) {
        dateTime =  pickedDate;
        _selectedDay =  taskView == TaskView.days ? dateTime.day-1 : dateTime.month-1;
        var res =  await ViewTaskHelper.createMonthlyCalender(dateTime: dateTime);
        if(res != null)
        {
          _taskDataList =  res;
        }
        _eventComplete(emit);
      }
    }

    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(taskView == TaskView.days){
      _taskList =  taskList.where((element) =>
      element.date.toString().replaceAll(" 00:00:00.000", "")
          ==  DateFormat("yyyy-MM-dd").format(dateTime).toString()).toList();
    } else
    if(taskView == TaskView.monthly){
      DateTime date =  DateTime(dateTime.year, selectedDay+1, selectedDay+1);
      _taskList =  taskList.where((element) =>
      element.month.toString() == date.month.toString()).toList();
    }
    _eventComplete(emit);
  }

  _selectDay(ViewTaskSelectedDayEvent event, emit) async {
    _selectedDay =  event.selectedIndex;
    pageController.animateToPage(selectedDay, duration: const Duration(
      milliseconds: 250,
    ), curve: Curves.easeInOutBack);
    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(taskView == TaskView.days){
      DateTime date =  DateTime(dateTime.year, dateTime.month, selectedDay+1);
      _taskList =  taskList.where((element) =>
      element.date.toString().replaceAll(" 00:00:00.000", "")
          ==  DateFormat("yyyy-MM-dd").format(date).toString()).toList();
    }
    _eventComplete(emit);
  }

  _selectMonth(ViewTaskSelectedMonthEvent event, emit) async
  {
    _selectedDay =  event.selectedIndex;
    pageController.animateToPage(selectedDay, duration: const Duration(
      milliseconds: 250,
    ), curve: Curves.easeInOutBack);
    _taskList = await ViewTaskHelper.fetchTaskData(dateTime: dateTime);
    if(taskView == TaskView.monthly){
      DateTime date =  DateTime(dateTime.year, selectedDay+1, selectedDay+1);
      _taskList =  taskList.where((element) =>
      element.month.toString() == date.month.toString()).toList();
    }
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
         pageController: pageController,
         taskView: taskView,
         taskList: taskList,
     ));
  }
}
