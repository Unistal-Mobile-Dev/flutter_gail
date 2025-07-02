part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardPageLoadState extends DashboardInitial {
  @override
  List<Object> get props => [];
}

class FetchDashboardDataState extends DashboardInitial {
  final bool isLoader;
  final List<PipelineSection> listOfPipelineSection;
  final List<MapEntry<String, Map<String, double>>> pieChartList;
  final Map<String, int> lengthPiggabilty;
  FetchDashboardDataState({
    required this.isLoader,
    required this.listOfPipelineSection,
    required this.pieChartList,
    required this.lengthPiggabilty,
  });
  @override
  List<Object> get props => [
    isLoader,
    listOfPipelineSection,
    pieChartList,
    lengthPiggabilty,
  ];
}