import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addAsset/domain/model/constant_model.dart';
import 'package:flutter_gail/feature/task/addAsset/helper/add_asset_helper.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/model/marker_type_model.dart';
import 'package:flutter_gail/feature/task/addMarker/helper/add_marker_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/marker_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'add_asset_event.dart';

part 'add_asset_state.dart';

class AddAssetBloc extends Bloc<AddAssetEvent, AddAssetState> {
  bool isLoader = false;
  List<MarkerTypeModel> markerTypeList = [];
  MarkerTypeModel markerTypeData = MarkerTypeModel();



  List<ConstantModel> listOfAssetType = [];
  ConstantModel assetTypeData = ConstantModel();
  String condition = "1";
  String painting = "1";
  TextEditingController remarkController = TextEditingController();
  TaskModel taskData = TaskModel();
  File cameraFile = File("");
  File videoFile = File("");
  File voiceRecordFile = File("");
  MarkerModel markerData = MarkerModel();

  AddAssetBloc() : super(AddAssetInitial()) {
    on<AddAssetPageLoadEvent>(_pageLoad);
    on<AddAssetSelectAssetEvent>(_selectMarker);
    on<AddAssetSelectConditionEvent>(_selectCondition);
    on<AddAssetSelectPaintingEvent>(_selectPainting);
    on<AddAssetSelectMediaEvent>(_selectMedia);
    on<AddAssetSelectVoiceEvent>(_selectAudio);
    on<AddAssetSelectAssetTypeEvent>(_selectAssetType);
    on<AddAssetSubmitEvent>(_submit);
  }

  _pageLoad(AddAssetPageLoadEvent event, emit) async {
    emit(AddAssetPageLoadState());
    isLoader = false;
    markerTypeList = [];
    markerTypeData = MarkerTypeModel();
    condition = "Good";
    painting = "Good";
    remarkController.text = "";
    cameraFile = File("");
    videoFile = File("");
    voiceRecordFile = File("");
    markerData = MarkerModel();
    var data = event.data;
    listOfAssetType = [];
    assetTypeData = ConstantModel();
    if (data.toString().isNotEmpty) {
      markerData = MarkerModel.fromJson(data);
    }

    taskData = BlocProvider.of<TaskBloc>(event.context).taskData;
    var res = await AddMarkerHelper.fetchMarkerType();
    if (res != null) {
      markerTypeList = res;
      if (markerData.markerType != null) {
        for (int i = 0; i < markerTypeList.length; i++) {
          if (markerTypeList[i].id.toString() ==
              markerData.markerType.toString()) {
            markerTypeList[i].isSelected = true;
            markerTypeData = markerTypeList[i];
          }
        }
      }
    }
    var resAsset = await AddAssetHelper.fetchAssetTypeApi();
    if (resAsset != null) {
      listOfAssetType = resAsset;
    }
    _eventCompleted(emit);
  }

  _selectMarker(AddAssetSelectAssetEvent event, emit) {
    for (int i = 0; i < markerTypeList.length; i++) {
      if (i == event.index) {
        markerTypeList[i].isSelected = true;
      } else {
        markerTypeList[i].isSelected = false;
      }
    }
    markerTypeData = markerTypeList[event.index];
    _eventCompleted(emit);
  }

  _selectCondition(AddAssetSelectConditionEvent event, emit) {
    condition = event.condition;
    _eventCompleted(emit);
  }

  _selectPainting(AddAssetSelectPaintingEvent event, emit) {
    painting = event.painting;
    _eventCompleted(emit);
  }

  _selectMedia(AddAssetSelectMediaEvent event, emit) async {
    if (event.isVideo == false) {
      if (event.mediaType == 1) {
        var res = await DashboardHelper.cameraPiker(context: event.context);
        if (res != null) {
          cameraFile = res;
        }
      } else {
        var res = await DashboardHelper.imagePiker(context: event.context);
        if (res != null) {
          cameraFile = res;
        }
      }
    } else {
      var res = await DashboardHelper.videoPiker(context: event.context);
      if (res != null) {
        videoFile = res;
      }
    }
    _eventCompleted(emit);
  }

  _selectAssetType(AddAssetSelectAssetTypeEvent event, emit) {
    assetTypeData = event.assetTypeValue;
    _eventCompleted(emit);
  }

  _selectAudio(AddAssetSelectVoiceEvent event, emit) async {
    if (event.audioPath.isNotEmpty) {
      voiceRecordFile = File(event.audioPath);
      _eventCompleted(emit);
    }
  }

  _submit(AddAssetSubmitEvent event, emit) async {
    var textFieldValidationCheck = await AddAssetHelper.textFieldValidation(
      context: !event.context.mounted ? event.context : event.context,
      markerTypeData: markerTypeData,
    );
    if (textFieldValidationCheck == false) {
      return;
    }

    isLoader = true;
    _eventCompleted(emit);
    var res = await AddAssetHelper.addMarkerData(
      context: !event.context.mounted ? event.context : event.context,
      taskData: taskData,
      markerTypeData: markerTypeData,
      condition: condition,
      painting: painting,
      remark: remarkController.text.toString(),
      cameraFile: cameraFile,
      voiceFile: voiceRecordFile,
      videoFile: videoFile,
      assetTypeValue: assetTypeData,
    );
    if (res != null) {
      isLoader = false;
      markerTypeData = MarkerTypeModel();
      assetTypeData = ConstantModel();
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

  _eventCompleted(Emitter<AddAssetState> emit) {
    emit(
      FetchAddAssetDataState(
        isLoader: isLoader,
        remarkController: remarkController,
        condition: condition,
        markerTypeData: markerTypeData,
        markerTypeList: markerTypeList,
        painting: painting,
        cameraFile: cameraFile,
        videoFile: videoFile,
        voiceRecordFile: voiceRecordFile,
        assetTypeData: assetTypeData,
        listOfAssetType: listOfAssetType,
      ),
    );
  }
}
