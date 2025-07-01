import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  bool isLoader = false;
  List<PipelineSection> listOfPipelineSection = [];

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardPageLoadEvent>(_pageLoad);
  }

  _pageLoad(DashboardPageLoadEvent event, emit) async {
    emit(DashboardPageLoadState());
    isLoader = false;
    listOfPipelineSection = [];
    var res =  await DashboardHelper.getSummaryApi();
    if(res != null){
      listOfPipelineSection =  res;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<DashboardState> emit) {
    emit(FetchDashboardDataState(
        isLoader: isLoader, listOfPipelineSection: listOfPipelineSection));
  }
}
