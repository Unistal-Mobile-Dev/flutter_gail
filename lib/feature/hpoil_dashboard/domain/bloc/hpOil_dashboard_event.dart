import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HpOilDashboardEvent extends Equatable {
  const HpOilDashboardEvent();
}

class HpOilDashboardPageLoadEvent extends HpOilDashboardEvent {
  final BuildContext context;

  const HpOilDashboardPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
