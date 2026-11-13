part of 'psp_monitoring_bloc.dart';

sealed class PspMonitoringEvent extends Equatable {
  const PspMonitoringEvent();
}

class PspMonitoringPageLoadEvent extends PspMonitoringEvent {
  final BuildContext context;
  const PspMonitoringPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

// Select Region
class PspSelectRegionEvent extends PspMonitoringEvent {
  final CpOptionModel regionData;
  const PspSelectRegionEvent({required this.regionData});
  @override
  List<Object?> get props => [regionData];
}

// Select Maintenance Base
class PspSelectMaintenanceBaseEvent extends PspMonitoringEvent {
  final CpOptionModel maintenanceBaseData;
  const PspSelectMaintenanceBaseEvent({required this.maintenanceBaseData});
  @override
  List<Object?> get props => [maintenanceBaseData];
}

// Select Pipeline
class PspSelectPipelineEvent extends PspMonitoringEvent {
  final CpOptionModel pipelineData;
  const PspSelectPipelineEvent({required this.pipelineData});
  @override
  List<Object?> get props => [pipelineData];
}

// Select Section
class PspSelectSectionEvent extends PspMonitoringEvent {
  final CpOptionModel sectionData;
  const PspSelectSectionEvent({required this.sectionData});
  @override
  List<Object?> get props => [sectionData];
}

// Select Year
class PspSelectYearEvent extends PspMonitoringEvent {
  final CpOptionModel yearData;
  const PspSelectYearEvent({required this.yearData});
  @override
  List<Object?> get props => [yearData];
}

// Select Month
class PspSelectMonthEvent extends PspMonitoringEvent {
  final CpOptionModel monthData;
  const PspSelectMonthEvent({required this.monthData});
  @override
  List<Object?> get props => [monthData];
}

// Select TLP No
class PspSelectTlpNumberEvent extends PspMonitoringEvent {
  final CpOptionModel tlpNumberData;
  const PspSelectTlpNumberEvent({required this.tlpNumberData});
  @override
  List<Object?> get props => [tlpNumberData];
}

// Select Type Of TLP
class PspSelectTlpTypeEvent extends PspMonitoringEvent {
  final CpOptionModel tlpTypeData;
  const PspSelectTlpTypeEvent({required this.tlpTypeData});
  @override
  List<Object?> get props => [tlpTypeData];
}

// Select Additional TLP Connection
class PspSelectAdditionalTlpConnectionEvent extends PspMonitoringEvent {
  final CpOptionModel additionalTlpConnectionData;
  const PspSelectAdditionalTlpConnectionEvent({required this.additionalTlpConnectionData});
  @override
  List<Object?> get props => [additionalTlpConnectionData];
}

// Select value of a dynamic dropdown field (field_type 3)
class PspSelectFieldOptionEvent extends PspMonitoringEvent {
  final String slug;
  final CpOptionModel optionData;
  const PspSelectFieldOptionEvent({required this.slug, required this.optionData});
  @override
  List<Object?> get props => [slug, optionData];
}

// Select Date of Reading
class PspSelectDateOfReadingEvent extends PspMonitoringEvent {
  final BuildContext context;
  const PspSelectDateOfReadingEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class PspSubmitInspectionEvent extends PspMonitoringEvent {
  final BuildContext context;
  const PspSubmitInspectionEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
