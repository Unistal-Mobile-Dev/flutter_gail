import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/model/encroachment_model.dart';
import 'package:flutter_gail/feature/task/addEncroachment/helper/encroachment_helper.dart';

part 'encroachment_event.dart';

part 'encroachment_state.dart';

class EncroachmentBloc extends Bloc<EncroachmentEvent, EncroachmentState> {

  String location = "";
  List<EncroachmentModel> encroachmentList = [];
  EncroachmentModel encroachmentData = EncroachmentModel();
  File file = File("");
  bool isLoader = false;
  bool isFileLoader = false;
  TextEditingController chainageController = TextEditingController();
  ArcGISPoint arcGISPoint =  ArcGISPoint(x: 0.0, y: 0.0);

  EncroachmentBloc() : super(EncroachmentInitial()) {
    on<PageLoadEvent>(_pageLoad);
    on<SelectFileEvent>(_selectFile);
    on<SelectEncroachmentTypeEvent>(_selectEncroachmentType);
    on<SubmitEvent>(_submit);
  }

  _pageLoad(PageLoadEvent event, emit) async {
    emit(EncroachmentPageLoadState());
    arcGISPoint = event.arcGISPoint;
    location = "";
    encroachmentList = [];
    encroachmentData = EncroachmentModel();
    file = File("");
    isLoader = false;
    isFileLoader = false;
    chainageController = TextEditingController();
    var res =  await EncroachmentHelper.fetchEncroachmentTypes();
    if(res != null){
      encroachmentList =  res;
    }
    _eventCompleted(emit);
  }

  _selectFile(SelectFileEvent event, emit) async {
    isFileLoader =  true;
    _eventCompleted(emit);
    var res =  await DashboardHelper.cameraPiker(context: event.context);
    if(res != null){
      file =  res;
    }
    isFileLoader =  false;
    _eventCompleted(emit);
  }

  _selectEncroachmentType(SelectEncroachmentTypeEvent event, emit) {
      encroachmentData =  event.encroachmentData;
      _eventCompleted(emit);
  }

  _submit(SubmitEvent event, emit) async {


  }

  _eventCompleted(Emitter<EncroachmentState> emit) {
    emit(FetchEncroachmentDataState(location: location,
        isLoader: isLoader,
        chainageController: chainageController,
        encroachmentData: encroachmentData,
        encroachmentList: encroachmentList,
        file: file,
        isFileLoader: isFileLoader));
  }

}
