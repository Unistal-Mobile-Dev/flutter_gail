import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineMasterModel.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  bool isLoader = false;
  List<PipelineSection> listOfPipelineSection = [];
  List<PipelineStatus> pipelineStatuses = [];
  List<CpSystemStatus> cpSystemStatuses = [];
  Map<String, int> lengthPiggabilty = {};
  List<MapEntry<String, Map<String, double>>> pieChartList = [];

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardPageLoadEvent>(_pageLoad);
  }

  _pageLoad(DashboardPageLoadEvent event, emit) async {
    isLoader = false;
    lengthPiggabilty = {};
    var resPipe =
        await DashboardHelper.getPipelineSummaryApi(context: event.context);
    if (resPipe != null) {
      pipelineStatuses = resPipe.pipelineStatuses;
      cpSystemStatuses = resPipe.cpSystemStatuses;
      pieChartList = [
        MapEntry("Pipeline Status", {
          for (var e in pipelineStatuses)
            e.pipelineStatus: e.statusCount.toDouble()
        }),
        MapEntry("CP System Status", {
          for (var e in cpSystemStatuses)
            e.pipelineStatus: e.statusCount.toDouble()
        }),
      ];
    }

    final result =
        await DashboardHelper.getPipelineMasterApi(context: event.context);
    if (result != null) {
      lengthPiggabilty = result.length;
      pieChartList.addAll([
        MapEntry(
          "Piggability",
          result.piggabilityCountMap.map((k, v) => MapEntry(k, v.toDouble())),
        ),
      ]);
    }

    var res = await DashboardHelper.getSummaryApi();
    if (res != null) {
      listOfPipelineSection = res;
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<DashboardState> emit) {
    emit(FetchDashboardDataState(
      isLoader: isLoader,
      listOfPipelineSection: listOfPipelineSection,
      pieChartList: pieChartList,
      lengthPiggabilty: lengthPiggabilty,
    ));
  }
}
