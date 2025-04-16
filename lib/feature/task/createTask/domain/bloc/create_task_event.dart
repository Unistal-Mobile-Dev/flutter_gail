part of 'create_task_bloc.dart';

sealed class CreateTaskEvent extends Equatable {
  const CreateTaskEvent();
}

class CreateTaskPageLoadEvent extends CreateTaskEvent {
  final BuildContext context;
  const CreateTaskPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class CreateTaskSelectShitDataEvent extends CreateTaskEvent {
  final ShiftTypeModel shiftData;
  const CreateTaskSelectShitDataEvent({required this.shiftData});
  @override
  List<Object?> get props => [shiftData];
}

class CreateTaskSelectLineDataEvent extends CreateTaskEvent {
  final LineModel lineData;
  const CreateTaskSelectLineDataEvent({required this.lineData});
  @override
  List<Object?> get props => [lineData];
}

class CreateTaskStartPatrollingDateEvent extends CreateTaskEvent {
  final BuildContext context;
  final DateTime dateTime;
  const CreateTaskStartPatrollingDateEvent({
    required this.context,
    required this.dateTime
  });
  @override
  List<Object?> get props => [context];
}

class CreateTaskStartPatrollingTimeEvent extends CreateTaskEvent {
  final BuildContext context;
  final Duration duration;
  const CreateTaskStartPatrollingTimeEvent({
    required this.context,
    required this.duration,
  });
  @override
  List<Object?> get props => [context];
}

class CreateTaskEndPatrollingDateEvent extends CreateTaskEvent {
  final BuildContext context;
  final DateTime dateTime;
  const CreateTaskEndPatrollingDateEvent({required this.context, required this.dateTime});
  @override
  List<Object?> get props => [context, dateTime];
}

class CreateTaskEndPatrollingTimeEvent extends CreateTaskEvent {
  final BuildContext context;
  final Duration duration;
  const CreateTaskEndPatrollingTimeEvent({
    required this.context,
    required this.duration,
  });
  @override
  List<Object?> get props => [context];
}

class CreateTaskDateEvent extends CreateTaskEvent {
  final BuildContext context;
  final DateTime dateTime;
  const CreateTaskDateEvent({required this.context, required this.dateTime});
  @override
  List<Object?> get props => [context, dateTime];
}

class CreateTaskTypeEvent extends CreateTaskEvent {
  final TaskTypeModel taskTypeData;
  const CreateTaskTypeEvent({required this.taskTypeData});
  @override
  List<Object?> get props => [taskTypeData];
}

class CreateTaskRegionEvent extends CreateTaskEvent {
  final RegionTypeModel regionTypeData;
  const CreateTaskRegionEvent({required this.regionTypeData});
  @override
  List<Object?> get props => [regionTypeData];
}

class CreateTaskMaintenanceTypeEvent extends CreateTaskEvent {
  final MaintenanceTypeModel maintenanceTypeData;
  const CreateTaskMaintenanceTypeEvent({required this.maintenanceTypeData});
  @override
  List<Object?> get props => [maintenanceTypeData];
}

class CreateTaskPipelineTypeEvent extends CreateTaskEvent {
  final PipelineModel pipelineData;
  const CreateTaskPipelineTypeEvent({required this.pipelineData});
  @override
  List<Object?> get props => [pipelineData];
}

class CreateTaskSectionTypeEvent extends CreateTaskEvent {
  final SectionModel sectionData;
  const CreateTaskSectionTypeEvent({required this.sectionData});
  @override
  List<Object?> get props => [sectionData];
}


class CreateTaskRouteEvent extends CreateTaskEvent {
  final RouteModel routeData;
  const CreateTaskRouteEvent({required this.routeData});
  @override
  List<Object?> get props => [routeData];
}

class CreateTaskShiftGroupEvent extends CreateTaskEvent {
  final bool selectedValue;
  final String value;
  final int id;
  final int lastIndex;
  const CreateTaskShiftGroupEvent({
    required this.selectedValue, required this.id, required this.lastIndex, required this.value});
  @override
  List<Object?> get props => [selectedValue, id, value, lastIndex];
}

class CreateTaskVendorEvent extends CreateTaskEvent {
  final VendorModel vendorData;
  const CreateTaskVendorEvent({required this.vendorData});
  @override
  List<Object?> get props => [vendorData];
}

class CreateTaskUserTypeEvent extends CreateTaskEvent {
  final UserTypeModel userTypeData;
  final BuildContext context;
  const CreateTaskUserTypeEvent({required this.userTypeData, required this.context});
  @override
  List<Object?> get props => [userTypeData, context];
}

class CreateTaskRepeatFrequencyEvent extends CreateTaskEvent {
  final RepeatFrequencyModel repeatFrequencyData;
  const CreateTaskRepeatFrequencyEvent({required this.repeatFrequencyData});
  @override
  List<Object?> get props => [repeatFrequencyData];
}

class CreateTaskUserNameEvent extends CreateTaskEvent {
  final List<UserNameModel> userNameData;
  const CreateTaskUserNameEvent({required this.userNameData});
  @override
  List<Object?> get props => [userNameData];
}


class CreateTaskSubmitEvent extends CreateTaskEvent {
  final BuildContext context;
  const CreateTaskSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}