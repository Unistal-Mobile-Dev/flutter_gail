part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
}

final class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

final class TaskPageLoadState extends TaskInitial {}

final class FetchTaskDataState extends TaskInitial {
  final bool isLoader;
  final List<TaskModel> taskList;
  final List<TaskModel> searchTaskList;

  FetchTaskDataState({
    required this.isLoader,
    required this.taskList,
    required this.searchTaskList,
  });

  @override
  List<Object> get props => [
    isLoader,
    taskList,
    searchTaskList];
}
