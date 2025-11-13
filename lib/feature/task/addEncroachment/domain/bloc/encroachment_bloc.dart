import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/model/encroachment_model.dart';
import 'package:flutter_gail/feature/task/addEncroachment/helper/encroachment_helper.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';

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
  TaskModel taskData =  TaskModel();
  LocationModel locationModel = LocationModel();

  EncroachmentBloc() : super(EncroachmentInitial()) {
    on<PageLoadEvent>(_pageLoad);
    on<SelectFileEvent>(_selectFile);
    on<SelectEncroachmentTypeEvent>(_selectEncroachmentType);
    on<SubmitEvent>(_submit);
  }

  _pageLoad(PageLoadEvent event, emit) async {
    emit(EncroachmentPageLoadState());

    encroachmentList = [];
    encroachmentData = EncroachmentModel();
    file = File("");
    isLoader = false;
    isFileLoader = false;
    chainageController = TextEditingController();
    taskData =  BlocProvider.of<TaskBloc>(!event.context.mounted?  event.context : event.context).taskData;
    var res = await EncroachmentHelper.fetchEncroachmentTypes();
    if (res != null) {
      encroachmentList = res;
    }
    var locationRes = await LocationHelper.getLocation(
        context: !event.context.mounted ? event.context : event.context);
    locationModel = LocationModel();
    if (locationRes != null) {
      locationModel = locationRes;
    }
    location = locationModel.address.toString();
    _eventCompleted(emit);
  }

  _selectFile(SelectFileEvent event, emit) async {
    isFileLoader = true;
    _eventCompleted(emit);
    var res = await DashboardHelper.cameraPiker(context: event.context);
    if (res != null) {
      file = res;
    }
    isFileLoader = false;
    _eventCompleted(emit);
  }

  _selectEncroachmentType(SelectEncroachmentTypeEvent event, emit) {
    encroachmentData = event.encroachmentData;
    _eventCompleted(emit);
  }

  _submit(SubmitEvent event, emit) async {
    BuildContext context =  event.context;
    var textFiledValidation =  await EncroachmentHelper.textFiledValidation(context: context,
        chainage: chainageController.text.toString(),
        encroachmentData: encroachmentData, locationData: locationModel, file: file);

    if(textFiledValidation == false){
      return;
    }

    isLoader =  true;
    _eventCompleted(emit);
    var res =  await EncroachmentHelper.submit(context: !context.mounted ? context : context,
        chainage: chainageController.text.toString(),
         taskData: taskData,
        encroachmentData: encroachmentData, locationData: locationModel, file: file);
    if(res != null){
      encroachmentData = EncroachmentModel();
      file = File("");
      isLoader = false;
      isFileLoader = false;
      chainageController = TextEditingController();
    }
    isLoader =  false;
    _eventCompleted(emit);

  }

  _eventCompleted(Emitter<EncroachmentState> emit) {
    emit(FetchEncroachmentDataState(
        location: location,
        isLoader: isLoader,
        chainageController: chainageController,
        encroachmentData: encroachmentData,
        encroachmentList: encroachmentList,
        file: file,
        isFileLoader: isFileLoader));
  }
}
