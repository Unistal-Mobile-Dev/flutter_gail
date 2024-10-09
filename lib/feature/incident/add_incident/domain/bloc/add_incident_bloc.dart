import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/model/incident_type_model.dart';

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

  AddIncidentBloc() : super(AddIncidentInitial()) {
    on<AddIncidentPageLoadEvent>(_pageLoad);
    on<AddIncidentSelectTypeEvent>(_selectIncidentType);
    on<AddIncidentSelectImageEvent>(_selectImage);
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
