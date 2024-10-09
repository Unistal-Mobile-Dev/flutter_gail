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
  final ShiftModel shiftData;
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

class CreateTaskSubmitEvent extends CreateTaskEvent {
  final BuildContext context;
  const CreateTaskSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}