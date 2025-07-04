part of 'add_tlp_survey_bloc.dart';

sealed class AddTlpSurveyEvent extends Equatable {
  const AddTlpSurveyEvent();
}

class AddTlpSurveyPageLoadEvent extends AddTlpSurveyEvent {
  final BuildContext context;
  const AddTlpSurveyPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

// Select Region
class SelectRegionEvent extends AddTlpSurveyEvent {
  final RegionTypeModel regionData;
  const SelectRegionEvent({required this.regionData});
  @override
  List<Object?> get props => [regionData];
}

// Select Maintenance Base
class SelectMaintenanceBaseEvent extends AddTlpSurveyEvent {
  final MaintenanceTypeModel maintenanceBaseData;
  const SelectMaintenanceBaseEvent({required this.maintenanceBaseData});
  @override
  List<Object?> get props => [maintenanceBaseData];
}

// Select Pipeline
class SelectPipelineEvent extends AddTlpSurveyEvent {
  final PipelineModel pipelineData;
  const SelectPipelineEvent({required this.pipelineData});
  @override
  List<Object?> get props => [pipelineData];
}

// Select Section
class SelectSectionEvent extends AddTlpSurveyEvent {
  final SectionModel sectionData;
  const SelectSectionEvent({required this.sectionData});
  @override
  List<Object?> get props => [sectionData];
}

// Select TLP Task Period
class SelectTlpTaskPeriodEvent extends AddTlpSurveyEvent {
  final TlpTaskPeriodModel tlpTaskPeriodData;
  const SelectTlpTaskPeriodEvent({required this.tlpTaskPeriodData});
  @override
  List<Object?> get props => [tlpTaskPeriodData];
}

// Select TLP Number
class SelectTlpNumberEvent extends AddTlpSurveyEvent {
  final TlpNumberModel tlpNumberData;
  const SelectTlpNumberEvent({required this.tlpNumberData});
  @override
  List<Object?> get props => [tlpNumberData];
}

// Select TLP Type
class SelectTlpTypeEvent extends AddTlpSurveyEvent {
  final TlpTypeModel tlpTypeData;
  const SelectTlpTypeEvent({required this.tlpTypeData});
  @override
  List<Object?> get props => [tlpTypeData];
}

// Select TLP Connection
class SelectTlpConnectionEvent extends AddTlpSurveyEvent {
  final TlpConnectionModel tlpConnectionData;
  const SelectTlpConnectionEvent({required this.tlpConnectionData});
  @override
  List<Object?> get props => [tlpConnectionData];
}

class SelectYearEvent extends AddTlpSurveyEvent {
  final BuildContext context;
  const SelectYearEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class SelectDateReadingEvent extends AddTlpSurveyEvent {
  final BuildContext context;
  const SelectDateReadingEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class SubmitTlpEvent extends AddTlpSurveyEvent {
  final BuildContext context;
  const SubmitTlpEvent({required this.context});
  @override
  List<Object?> get props => [context];
}