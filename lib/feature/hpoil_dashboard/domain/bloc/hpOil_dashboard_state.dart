import 'package:equatable/equatable.dart';
import 'package:flutter_gail/feature/login/domain/models/login_model.dart';

abstract class HpOilDashboardState extends Equatable {
  const HpOilDashboardState();
}

class HpOilDashboardInitial extends HpOilDashboardState {
  @override
  List<Object> get props => [];
}

class HpOilDashboardPageLoadState extends HpOilDashboardInitial {
  @override
  List<Object> get props => [];
}

class FetchHpOilDashboardDataState extends HpOilDashboardInitial {
  final bool isLoader;
  final LoginDataModel userData;

  FetchHpOilDashboardDataState({
    required this.isLoader,
    required this.userData,
  });
  @override
  List<Object> get props => [
    isLoader,
    userData,
  ];
}