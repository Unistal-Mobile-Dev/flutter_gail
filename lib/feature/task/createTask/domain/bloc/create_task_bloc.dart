import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/line_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_model.dart';
import 'package:flutter_gail/feature/task/createTask/helper/create_task_helper.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {

  bool isLoader =  false;
  List<ShiftModel> shiftList = [];
  ShiftModel shiftData = ShiftModel();
  List<LineModel> lineList = [];
  LineModel lineData =  LineModel();
  TextEditingController startPatrollingDateController =  TextEditingController();
  TextEditingController endPatrollingDateController =  TextEditingController();
  TextEditingController startPatrollingTimeController =  TextEditingController();
  TextEditingController endPatrollingTimeController =  TextEditingController();
  TextEditingController taskDateController = TextEditingController();

  CreateTaskBloc() : super(CreateTaskInitial()) {
    on<CreateTaskPageLoadEvent>(_pageLoad);
    on<CreateTaskSelectLineDataEvent>(_lineData);
    on<CreateTaskSelectShitDataEvent>(_shiftData);
    on<CreateTaskStartPatrollingDateEvent>(_startPatrollingDate);
    on<CreateTaskStartPatrollingTimeEvent>(_startPatrollingTime);
    on<CreateTaskEndPatrollingDateEvent>(_endPatrollingDate);
    on<CreateTaskEndPatrollingTimeEvent>(_endPatrollingTime);
    on<CreateTaskDateEvent>(_taskDate);
    on<CreateTaskSubmitEvent>(_submit);
  }

  _pageLoad(CreateTaskPageLoadEvent event, emit) async {
    emit(CreateTaskPageLoadState());
    isLoader =  false;
    shiftData = ShiftModel();
    lineData =  LineModel();
    startPatrollingDateController.text = "";
    endPatrollingDateController.text = "";
    startPatrollingTimeController.text = "";
    endPatrollingTimeController.text = "";
    taskDateController.text = "";
    lineList = [];
    shiftList = [];

    lineList.add(LineModel(
      length: "1",
      id: "1",
      name: "Test Name",
    ));

    shiftList.add(ShiftModel(
       name: "Test Shift",
      id: "1",
      startTime: "23:90",
      endTime: "34:89"
    ));

    if(lineList.isEmpty){
      var res =  await CreateTaskHelper.fetchLineData();
      lineList = res ?? [];
    }
    if(shiftList.isEmpty){
      var res =  await CreateTaskHelper.fetchShiftData();
      shiftList = res ?? [];
    }
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
    String formattedDate = DateFormat('dd-MM-yyyy').format(event.dateTime);
    startPatrollingDateController.text = formattedDate;
    _eventComplete(emit);
  }

  _startPatrollingTime(CreateTaskStartPatrollingTimeEvent event, emit) {
    String time = event.duration.toString().replaceAll(".000000", "");
    startPatrollingTimeController.text =  time;
    _eventComplete(emit);
  }

  _endPatrollingDate(CreateTaskEndPatrollingDateEvent event, emit) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(event.dateTime);
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

  _submit(CreateTaskSubmitEvent event, emit) async {
    isLoader =  true;
    _eventComplete(emit);
    var textFiledValidation =  await CreateTaskHelper.textFieldValidation(context: event.context,
        lineData: lineData,
        startPatrollingDate: startPatrollingDateController.text.toString(),
        startPatrollingTime: startPatrollingTimeController.text.toString(),
        endPatrollingDate: endPatrollingDateController.text.toString(),
        endPatrollingTime: endPatrollingTimeController.text.toString(),
        shiftData: shiftData, taskDate: taskDateController.text.toString());
    if(textFiledValidation == false){
      isLoader =  false;
      _eventComplete(emit);
      return ;
    }

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
        taskDateController: taskDateController
    ));
  }
}
