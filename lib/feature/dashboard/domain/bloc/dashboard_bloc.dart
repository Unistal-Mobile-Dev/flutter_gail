import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineMasterModel.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';
import 'package:flutter_gail/services/network_helper.dart';

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

    await DashboardHelper.requestMandatoryLocationPermission(event.context);

    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    print("Background service running === ${isRunning}");

/*    bool connected = await NetworkHelper.isConnected();
    if(connected){
      double mbps = await NetworkHelper.checkDownloadSpeed();
      print("Speed  === $mbps");
    }*/

    var resPipe =
        await DashboardHelper.getPipelineSummaryApi(context: event.context);
    if (resPipe != null) {
      pipelineStatuses = resPipe.pipelineStatuses;
      cpSystemStatuses = resPipe.cpSystemStatuses;
      pieChartList = [
        MapEntry("Pipeline Status", {
          for (var e in pipelineStatuses)
            e.pipelineStatus: e.statusCount.toDouble()/1000
        }),
        MapEntry("CP System Status", {
          for (var e in cpSystemStatuses)
            e.pipelineStatus: e.statusCount.toDouble()
        }),
      ];
    }
    _eventCompleted(emit);

    final result =
        await DashboardHelper.getPipelineMasterApi(context: event.context);
    if (result != null) {
      lengthPiggabilty = result.length;
      pieChartList.addAll([
        MapEntry(
          "Piggability",
          result.piggabilityCountMap.map((k, v) => MapEntry(k, v.toDouble()))..remove("Under Conversion"),

        ),
      ]);
    }
    _eventCompleted(emit);
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
