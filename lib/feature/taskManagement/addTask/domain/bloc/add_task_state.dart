part of 'add_task_bloc.dart';

sealed class AddTaskState extends Equatable {
  const AddTaskState();
}

final class AddTaskInitial extends AddTaskState {
  @override
  List<Object> get props => [];
}
