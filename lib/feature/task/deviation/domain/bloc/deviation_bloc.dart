import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/deviation/domain/model/deviation_model.dart';
import 'package:flutter_gail/feature/task/deviation/helper/deviation_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'deviation_event.dart';

part 'deviation_state.dart';

class DeviationBloc extends Bloc<DeviationEvent, DeviationState> {

  bool isLoader = false;
  DeviationModel deviationData = DeviationModel();
  List<DeviationModel> deviationList = [];
  File file = File("");
  bool isFileLoader = false;
  TextEditingController otherController =  TextEditingController();
  TaskModel taskData =  TaskModel();

  DeviationBloc() : super(DeviationInitial()) {
    on<DeviationPageLoadEvent>(_pageLoad);
    on<SelectDeviation>(_selectDeviation);
    on<SelectFile>(_selectFile);
    on<SubmitEvent>(_submit);
  }

  _pageLoad(DeviationPageLoadEvent event, emit) async {
    emit(DeviationPageLoadState());
    isLoader = false;
    deviationData = DeviationModel();
    deviationList = DeviationModel().getDeviationData();
    file = File("");
    isFileLoader = false;
    otherController =  TextEditingController();
    taskData =  BlocProvider.of<TaskBloc>(!event.context.mounted?  event.context : event.context).taskData;
    _eventCompleted(emit);
  }

  _selectDeviation(SelectDeviation event, emit) {
     deviationData =  event.deviationData;
     otherController.text = "";
     _eventCompleted(emit);
  }

  _selectFile(SelectFile event, emit) async {
    isFileLoader = true;
    _eventCompleted(emit);
    var res = await DashboardHelper.cameraPiker(context: event.context);
    if (res != null) {
      file = res;
    }
    isFileLoader = false;
    _eventCompleted(emit);
  }

  _submit(SubmitEvent event, emit) async {
    BuildContext context =  event.context;
    var textFiledValidation =  await DeviationHelper.textFiledValidation(context: context,
        other: otherController.text.toString(),
        deviationData: deviationData, file: file);

    if(textFiledValidation == false){
      return;
    }

    isLoader =  true;
    _eventCompleted(emit);
    var res =  await DeviationHelper.submit(context: !context.mounted ? context : context,
        other: otherController.text.toString(),
        taskData: taskData,
        deviationData: deviationData, file: file);
    if(res != null){
      deviationData = DeviationModel();
      file = File("");
      isLoader = false;
      isFileLoader = false;
      otherController = TextEditingController();
    }
    isLoader =  false;
    _eventCompleted(emit);

  }

  _eventCompleted(Emitter<DeviationState> emit) {
    emit(FetchDeviationDataState(deviationList: deviationList,
        isLoader: isLoader,
        file: file,
        isFileLoader: isFileLoader,
        deviationData: deviationData,
         otherController: otherController,
    ));
  }
}
