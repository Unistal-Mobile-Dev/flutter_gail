part of 'create_task_bloc.dart';

sealed class CreateTaskState extends Equatable {
  const CreateTaskState();
}

final class CreateTaskInitial extends CreateTaskState {
  @override
  List<Object> get props => [];
}

final class CreateTaskPageLoadState extends CreateTaskInitial {}


final class FetchCreateTaskDataState extends CreateTaskInitial {
  final bool isLoader;
  final List<ShiftModel> shiftList;
  final ShiftModel shiftData;
  final List<LineModel> lineList;
  final LineModel lineData;
  final TextEditingController startPatrollingDateController;
  final TextEditingController endPatrollingDateController;
  final TextEditingController startPatrollingTimeController;
  final TextEditingController endPatrollingTimeController;
  final TextEditingController taskDateController;

  FetchCreateTaskDataState({
    required this.isLoader,
    required this.endPatrollingDateController,
    required this.endPatrollingTimeController,
    required this.lineData,
    required this.lineList,
    required this.shiftData,
    required this.shiftList,
    required this.startPatrollingDateController,
    required this.startPatrollingTimeController,
    required this.taskDateController,
  });

  @override
  List<Object> get props => [
    isLoader,
    endPatrollingDateController,
    endPatrollingTimeController,
    lineData,
    lineList,
    shiftData,
    shiftList,
    startPatrollingDateController,
    startPatrollingTimeController,
    taskDateController,
  ];
}