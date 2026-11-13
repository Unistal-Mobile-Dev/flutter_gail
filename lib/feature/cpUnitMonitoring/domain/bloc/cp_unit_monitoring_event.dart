part of 'cp_unit_monitoring_bloc.dart';

sealed class CpUnitMonitoringEvent extends Equatable {
  const CpUnitMonitoringEvent();
}

class CpUnitMonitoringPageLoadEvent extends CpUnitMonitoringEvent {
  final BuildContext context;
  const CpUnitMonitoringPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

// Select Region
class CpSelectRegionEvent extends CpUnitMonitoringEvent {
  final CpOptionModel regionData;
  const CpSelectRegionEvent({required this.regionData});
  @override
  List<Object?> get props => [regionData];
}

// Select Maintenance Base
class CpSelectMaintenanceBaseEvent extends CpUnitMonitoringEvent {
  final CpOptionModel maintenanceBaseData;
  const CpSelectMaintenanceBaseEvent({required this.maintenanceBaseData});
  @override
  List<Object?> get props => [maintenanceBaseData];
}

// Select Pipeline
class CpSelectPipelineEvent extends CpUnitMonitoringEvent {
  final CpOptionModel pipelineData;
  const CpSelectPipelineEvent({required this.pipelineData});
  @override
  List<Object?> get props => [pipelineData];
}

// Select Section
class CpSelectSectionEvent extends CpUnitMonitoringEvent {
  final CpOptionModel sectionData;
  const CpSelectSectionEvent({required this.sectionData});
  @override
  List<Object?> get props => [sectionData];
}

// Select Year
class CpSelectYearEvent extends CpUnitMonitoringEvent {
  final CpOptionModel yearData;
  const CpSelectYearEvent({required this.yearData});
  @override
  List<Object?> get props => [yearData];
}

// Select Month
class CpSelectMonthEvent extends CpUnitMonitoringEvent {
  final CpOptionModel monthData;
  const CpSelectMonthEvent({required this.monthData});
  @override
  List<Object?> get props => [monthData];
}

// Select Rectifier
class CpSelectRectifierEvent extends CpUnitMonitoringEvent {
  final CpOptionModel rectifierData;
  const CpSelectRectifierEvent({required this.rectifierData});
  @override
  List<Object?> get props => [rectifierData];
}

// Select Operating Mode
class CpSelectOperatingModeEvent extends CpUnitMonitoringEvent {
  final CpOptionModel operatingModeData;
  const CpSelectOperatingModeEvent({required this.operatingModeData});
  @override
  List<Object?> get props => [operatingModeData];
}

// Select On/Off Status
class CpSelectOnOffStatusEvent extends CpUnitMonitoringEvent {
  final CpOptionModel onOffStatusData;
  const CpSelectOnOffStatusEvent({required this.onOffStatusData});
  @override
  List<Object?> get props => [onOffStatusData];
}

// Select Rectifier Health
class CpSelectRectifierHealthEvent extends CpUnitMonitoringEvent {
  final CpOptionModel rectifierHealthData;
  const CpSelectRectifierHealthEvent({required this.rectifierHealthData});
  @override
  List<Object?> get props => [rectifierHealthData];
}

// Select Inspection Date
class CpSelectInspectionDateEvent extends CpUnitMonitoringEvent {
  final BuildContext context;
  const CpSelectInspectionDateEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CpSubmitInspectionEvent extends CpUnitMonitoringEvent {
  final BuildContext context;
  const CpSubmitInspectionEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
