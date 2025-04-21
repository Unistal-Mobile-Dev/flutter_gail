import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/model/incident_type_model.dart';
import 'package:flutter_gail/feature/incident/add_incident/helper/add_incident_helper.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/domain/model/route_points_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

part 'add_incident_event.dart';
part 'add_incident_state.dart';

class AddIncidentBloc extends Bloc<AddIncidentEvent, AddIncidentState> {

  bool isLoader = false;
  List<IncidentTypeModel> incidentTypeList = [];
  IncidentTypeModel incidentTypeData =  IncidentTypeModel();
  TextEditingController incidentReportController =  TextEditingController();
  File imageFile =  File("");
  File audioRecordFile =  File("");
  File videoFile =  File("");
  TaskModel taskData =  TaskModel();

  AddIncidentBloc() : super(AddIncidentInitial()) {
    on<AddIncidentPageLoadEvent>(_pageLoad);
    on<AddIncidentSelectTypeEvent>(_selectIncidentType);
    on<AddIncidentSelectImageEvent>(_selectImage);
    on<AddIncidentSelectAudioEvent>(_selectAudio);
    on<AddIncidentSelectVideoEvent>(_selectVideo);
    on<AddIncidentSubmitEvent>(_submit);
  }

  _pageLoad(AddIncidentPageLoadEvent event, emit) async {
    emit(AddIncidentPageLoadState());
    isLoader = false;
    incidentTypeList = [];
    incidentTypeData =  IncidentTypeModel();
    incidentReportController.text = "";
    imageFile =  File("");
    audioRecordFile =  File("");
    videoFile =  File("");
    taskData =  BlocProvider.of<TaskBloc>(!event.context.mounted?  event.context : event.context).taskData;

     if(incidentTypeList.isEmpty){
       List<RoutePointsModel> routePointsList =
            BlocProvider.of<MapBloc>(!event.context.mounted ? event.context: event.context).routePointsList;
       if(routePointsList.isNotEmpty){
         incidentTypeList = routePointsList.first.incidentTypeList;
       }
       // var res =  await AddIncidentHelper.fetchIncidentTypeData();
       // if(res != null){
       //   incidentTypeList =  res;
       // }
     }
    _eventComplete(emit);
  }

  _selectIncidentType(AddIncidentSelectTypeEvent event, emit) {
    incidentTypeData =  event.incidentTypeData;
    _eventComplete(emit);
  }

  _selectImage(AddIncidentSelectImageEvent event, emit) async {
    if(event.mediaType == 1){
      var res =  await DashboardHelper.cameraPiker(context: event.context);
      if(res != null){
        imageFile =  res;
      }
    } else {
      var res =  await DashboardHelper.imagePiker(context: event.context);
      if(res != null){
        imageFile =  res;
      }
    }
    _eventComplete(emit);
  }

  _selectAudio(AddIncidentSelectAudioEvent event, emit) {
    audioRecordFile =  File(event.audioPath);
    _eventComplete(emit);
  }

  _selectVideo(AddIncidentSelectVideoEvent event, emit) async {
    if(event.mediaType == 1){
      var res =  await DashboardHelper.videoPiker(context: event.context);
      if(res != null){
        videoFile =  res;
      }
    } else {
      var res =  await DashboardHelper.filePiker(context: event.context);
      if(res != null){
        videoFile =  res;
      }
    }
    _eventComplete(emit);
  }


  _submit(AddIncidentSubmitEvent event, emit) async {

    bool isTextFieldValidation =  await AddIncidentHelper.textFieldValidation(
        context: !event.context.mounted ? event.context : event.context,
        incidentTypeData: incidentTypeData, incidentReport: incidentReportController.text.toString());
    if(isTextFieldValidation == false){
      return false;
    }
    isLoader = true;
    _eventComplete(emit);
    var res =  await AddIncidentHelper.saveIncidentData(context: !event.context.mounted ? event.context : event.context,
        taskData: taskData, incidentTypeData: incidentTypeData,
        incidentReport: incidentReportController.text.toString(),
        imageFile: imageFile, audioFile: audioRecordFile, videoFile: videoFile);
    if(res != null){
      Navigator.pop(!event.context.mounted ? event.context : event.context);
    }
    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<AddIncidentState>emit) {
    emit(FetchAddIncidentDataState(
        videoFile: videoFile,
        isLoader: isLoader,
        audioRecordFile: audioRecordFile,
        imageFile: imageFile,
        incidentTypeData: incidentTypeData,
        incidentTypeList: incidentTypeList,
        incidentReportController: incidentReportController
    ));
  }
}
