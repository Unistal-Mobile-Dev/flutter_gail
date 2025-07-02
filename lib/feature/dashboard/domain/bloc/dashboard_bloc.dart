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
  List<MapEntry<String, Map<String, double>>> pieChartList = [];

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardPageLoadEvent>(_pageLoad);
  }



  _pageLoad(DashboardPageLoadEvent event, emit) async {
    isLoader =  false;
    var resPipe = await DashboardHelper.getPipelineSummaryApi(context: event.context);
    if(resPipe != null){
      pipelineStatuses = resPipe.pipelineStatuses;
      cpSystemStatuses = resPipe.cpSystemStatuses;
      pieChartList = [
        MapEntry("Pipeline Status", {
          for (var e in pipelineStatuses) e.pipelineStatus: e.statusCount.toDouble()
        }),
        MapEntry("CP System Status", {
          for (var e in cpSystemStatuses) e.pipelineStatus: e.statusCount.toDouble()
        }),
      ];

    }
    await  _fetchSummary(context: event.context);
    _eventCompleted(emit);
  }


  _fetchSummary({required BuildContext context}) async {
    var res = await DashboardHelper.getSummaryApi();

    if (res != null) {
      listOfPipelineSection = res;

      double piggable = 0;
      double unpiggable = 0;

      for (var data in listOfPipelineSection) {
        final int pigTotal = data.piggingNd + data.piggingDue + data.piggingOverdue;

        if (pigTotal > 0) {
          piggable += pigTotal;
        } else {
          unpiggable += 1;
        }
      }

      final Map<String, double> piggingMap = {
        "Piggable": piggable,
        "Unpiggable": unpiggable,
      };
      final total = piggable + unpiggable;
      print("total--->${total.toString().length}");
      pieChartList.add(MapEntry("Pigging Status (Total: $total)", piggingMap));

    }
  }


  _eventCompleted(Emitter<DashboardState> emit) {
    emit(FetchDashboardDataState(
        isLoader: isLoader,
        listOfPipelineSection: listOfPipelineSection,
        pieChartList: pieChartList,
    ));
}
}
