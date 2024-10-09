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
  @override
  List<Object> get props => [];
}
