import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/model/marker_type_model.dart';
import 'package:flutter_gail/feature/task/addMarker/helper/add_marker_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'add_marker_event.dart';
part 'add_marker_state.dart';

class AddMarkerBloc extends Bloc<AddMarkerEvent, AddMarkerState> {

  bool isLoader =  false;
  List<MarkerTypeModel> markerTypeList = [];
  MarkerTypeModel markerTypeData =  MarkerTypeModel();
  String condition = "1";
  String painting = "1";
  TextEditingController remarkController  =  TextEditingController();
  TaskModel taskData =  TaskModel();
  File cameraFile = File("");
  File videoFile = File("");
  File voiceRecordFile = File("");
  MarkerModel markerData =  MarkerModel();

  AddMarkerBloc() : super(AddMarkerInitial()) {
    on<AddMarkerPageLoadEvent>(_pageLoad);
    on<AddMarkerSelectMarkerEvent>(_selectMarker);
    on<AddMarkerSelectConditionEvent>(_selectCondition);
    on<AddMarkerSelectPaintingEvent>(_selectPainting);
    on<AddMarkerSelectMediaEvent>(_selectMedia);
    on<AddMarkerSelectVoiceEvent>(_selectAudio);
    on<AddMarkerSubmitEvent>(_submit);
  }

  _pageLoad(AddMarkerPageLoadEvent event, emit) async {
    emit(AddMarkerPageLoadState());
    isLoader =  false;
    markerTypeList = [];
    markerTypeData =  MarkerTypeModel();
    condition = "1";
    painting = "1";
    remarkController.text = "";
    cameraFile = File("");
    videoFile = File("");
    voiceRecordFile = File("");
    markerData =  MarkerModel();
    var data =  event.data;

    if(data.toString().isNotEmpty){
      markerData =  MarkerModel.fromJson(data);
    }

    taskData  =  BlocProvider.of<TaskBloc>(event.context).taskData;
    var res =  await AddMarkerHelper.fetchMarkerType();
    if(res != null){
      markerTypeList = res;
      if(markerData.markerType != null){
        for(int i = 0; i < markerTypeList.length; i++){
          if(markerTypeList[i].id.toString() == markerData.markerType.toString())
          {
            markerTypeList[i].isSelected =  true;
            markerTypeData =  markerTypeList[i];
          }
        }
      }
    }

    _eventCompleted(emit);
  }

  _selectMarker(AddMarkerSelectMarkerEvent event, emit) {
    for (int i = 0; i < markerTypeList.length; i++){
         if(i ==  event.index){
           markerTypeList[i].isSelected =  true;
         } else {
           markerTypeList[i].isSelected =  false;
         }
    }
    markerTypeData =  markerTypeList[event.index];
    _eventCompleted(emit);
  }

  _selectCondition(AddMarkerSelectConditionEvent event, emit) {
    condition =  event.condition;
    _eventCompleted(emit);
  }

  _selectPainting(AddMarkerSelectPaintingEvent event, emit) {
    painting =  event.painting;
    _eventCompleted(emit);
  }
  
  _selectMedia(AddMarkerSelectMediaEvent event, emit) async {
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

  _selectAudio(AddMarkerSelectVoiceEvent event, emit) async {
    if(event.audioPath.isNotEmpty){
      voiceRecordFile =  File(event.audioPath);
      _eventCompleted(emit);
    }
  }

  _submit(AddMarkerSubmitEvent event, emit) async {

    var textFieldValidationCheck =  await AddMarkerHelper.textFieldValidation(
        context: !event.context.mounted ? event.context :event.context,
        markerTypeData: markerTypeData);
    if(textFieldValidationCheck ==  false){
      return;
    }

    isLoader = true;
    _eventCompleted(emit);
    var res =  await AddMarkerHelper.addMarkerData(context: !event.context.mounted ? event.context :event.context,
        taskData: taskData, markerTypeData: markerTypeData, condition: condition, painting: painting,
        remark: remarkController.text.toString(),
        cameraFile: cameraFile, voiceFile: voiceRecordFile, videoFile: videoFile);
    if(res != null){
      isLoader =  false;
      markerTypeData =  MarkerTypeModel();
      condition = "1";
      painting = "1";
      remarkController.text = "";
      cameraFile = File("");
      videoFile = File("");
      voiceRecordFile = File("");
      Navigator.pop(!event.context.mounted ? event.context : event.context);
    }
    isLoader = false;
    _eventCompleted(emit);

  }

  _eventCompleted(Emitter<AddMarkerState>emit) {
    emit(FetchAddMarkerDataState(isLoader: isLoader,
        remarkController: remarkController,
        condition: condition,
        markerTypeData: markerTypeData,
        markerTypeList: markerTypeList,
        painting: painting,
        cameraFile: cameraFile,
        videoFile: videoFile,
        voiceRecordFile: voiceRecordFile,
    ));
  }
}
