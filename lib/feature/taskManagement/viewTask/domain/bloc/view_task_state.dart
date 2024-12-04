part of 'view_task_bloc.dart';

sealed class ViewTaskState extends Equatable {
  const ViewTaskState();
}

final class ViewTaskInitial extends ViewTaskState {
  @override
  List<Object> get props => [];
}

final class ViewTaskPageLoadState extends ViewTaskInitial {
  @override
  List<Object> get props => [];
}

final class FetchViewTaskDataState extends ViewTaskInitial {

  final List<TaskDataModel> taskDataList;
  final int selectedDay;
  final List<TaskFilterModel> taskFilterList;
  final bool isLoader;
  final PageController pageController;
  final TaskView taskView;
  final List<TaskModel> taskList;

  FetchViewTaskDataState({
    required this.taskDataList,
    required this.selectedDay,
    required this.taskFilterList,
    required this.isLoader,
    required this.pageController,
    required this.taskView,
    required this.taskList,
  });

  @override
  List<Object> get props => [
    taskDataList,
    selectedDay,
    taskFilterList,
    isLoader,
    pageController,
    taskView,
    taskList,
  ];
}