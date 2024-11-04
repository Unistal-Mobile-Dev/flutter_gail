part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

class TaskPageLoadEvent extends TaskEvent {
  final BuildContext context;
  const TaskPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class TaskPagRefreshDataEvent extends TaskEvent {
  final BuildContext context;
  const TaskPagRefreshDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class TaskPageSelectDataEvent extends TaskEvent {
  final int index;
  const TaskPageSelectDataEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class TaskPageSelectDateEvent extends TaskEvent {
  final BuildContext context;
  const TaskPageSelectDateEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class TaskTabIndexEvent extends TaskEvent {
  final int tabIndex;
  const TaskTabIndexEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];

}