import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/model/crossing_type_model.dart';
import 'package:flutter_gail/feature/task/addCrossing/helper/add_crossing_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'add_crossing_event.dart';
part 'add_crossing_state.dart';

class AddCrossingBloc extends Bloc<AddCrossingEvent, AddCrossingState> {

  bool isLoader =  false;
  List<CrossingTypeModel> crossingTypeList = [];
  CrossingTypeModel crossingTypeData =  CrossingTypeModel();
  String warningMarker = "1";
  String drainCondition = "1";
  String bankCondition = "1";
  TextEditingController remarkController  =  TextEditingController();
  TaskModel taskData =  TaskModel();
  File cameraFile = File("");
  File videoFile = File("");
  File voiceRecordFile = File("");

  AddCrossingBloc() : super(AddCrossingInitial()) {
    on<AddCrossingPageLoadEvent>(_pageLoad);
    on<AddCrossingSelectCrossingEvent>(_selectCrossing);
    on<AddCrossingSelectWarningMarkerEvent>(_selectWarningMarker);
    on<AddCrossingSelectDrainConditionEvent>(_selectDrainCondition);
    on<AddCrossingSelectBankConditionEvent>(_selectBankCondition);
    on<AddCrossingSelectMediaEvent>(_selectMedia);
    on<AddCrossingSelectVoiceEvent>(_selectAudio);
    on<AddCrossingSubmitEvent>(_submit);
  }

  _pageLoad(AddCrossingPageLoadEvent event, emit) async {
    emit(AddCrossingPageLoadState());
    isLoader =  false;
    crossingTypeList = [];
    crossingTypeData =  CrossingTypeModel();
    warningMarker = "1";
    drainCondition = "1";
    bankCondition = "1";
    remarkController.text = "";
    cameraFile = File("");
    videoFile = File("");
    voiceRecordFile = File("");
    taskData  =  BlocProvider.of<TaskBloc>(event.context).taskData;
    var res =  await AddCrossingHelper.fetchCrossingType();
    if(res != null){
      crossingTypeList =  res;
    }
    _eventCompleted(emit);
  }

  _selectCrossing(AddCrossingSelectCrossingEvent event, emit) {
     for(int i = 0; i < crossingTypeList.length; i++) {
         if(i ==  event.index){
             crossingTypeList[i].isSelected =  true;
         } else {
           crossingTypeList[i].isSelected =  false;
         }
     }
     crossingTypeData =  crossingTypeList[event.index];
    _eventCompleted(emit);
  }

  _selectWarningMarker(AddCrossingSelectWarningMarkerEvent event, emit) {
    warningMarker =  event.warningMarker;
    _eventCompleted(emit);
  }

  _selectDrainCondition(AddCrossingSelectDrainConditionEvent event, emit) {
    drainCondition =  event.drainCondition;
    _eventCompleted(emit);
  }

  _selectBankCondition(AddCrossingSelectBankConditionEvent event, emit) {
     bankCondition =  event.bankCondition;
     _eventCompleted(emit);
  }

  _selectMedia(AddCrossingSelectMediaEvent event, emit) async {
    if(event.isVideo == false) {
      if(event.mediaType == 1){
        var res =  await DashboardHelper.cameraPiker(context: event.context);
        if(res != null){
          cameraFile =  res;
        }
      } else {
        var res =  await DashboardHelper.imagePiker(context: event.context);
        if(res != null){
          cameraFile =  res;
        }
      }
    } else {
      var res =  await DashboardHelper.videoPiker(context: event.context);
      if(res != null){
        videoFile =  res;
      }
    }
    _eventCompleted(emit);
  }

  _selectAudio(AddCrossingSelectVoiceEvent event, emit) async {
    if(event.audioPath.isNotEmpty){
      voiceRecordFile =  File(event.audioPath);
      _eventCompleted(emit);
    }
  }

  _submit(AddCrossingSubmitEvent event, emit) async {

    var textFieldValidation =  await AddCrossingHelper.textFieldValidation(
        context: !event.context.mounted ? event.context : event.context,
        crossingTypeData: crossingTypeData);
    if(textFieldValidation == false){
      return;
    }
    isLoader =  true;
    _eventCompleted(emit);
    var res =  await AddCrossingHelper.saveCrossingData(context: !event.context.mounted ? event.context : event.context,
        taskData: taskData, crossingTypeData: crossingTypeData,
        markerCondition: warningMarker,
        drainCondition: drainCondition, bankCondition: bankCondition,
        remark: remarkController.text.toString(),
        cameraFile: cameraFile,
        voiceFile: voiceRecordFile,
        videoFile: videoFile);
    if(res != null){
      Navigator.pop(!event.context.mounted ? event.context : event.context);
    }
    isLoader =  false;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<AddCrossingState>emit) {
    emit(FetchAddCrossingDataState(isLoader: isLoader,
      remarkController: remarkController,
      warningMarker: warningMarker,
      crossingTypeData: crossingTypeData,
      crossingTypeList: crossingTypeList,
      drainCondition: drainCondition,
      bankCondition: bankCondition,
      cameraFile: cameraFile,
      videoFile: videoFile,
      voiceRecordFile: voiceRecordFile,
    ));
  }
}

