part of 'view_task_bloc.dart';

sealed class ViewTaskEvent extends Equatable {
  const ViewTaskEvent();
}

class ViewTaskPageLoadEvent extends ViewTaskEvent {
  final BuildContext context;
  const ViewTaskPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class ViewTaskSelectedDayEvent extends ViewTaskEvent {
  final BuildContext context;
  final int selectedIndex;
  const ViewTaskSelectedDayEvent({required this.context, required this.selectedIndex});
  @override
  List<Object?> get props => [context, selectedIndex];
}

class ViewTaskSelectedFilterStatusEvent extends ViewTaskEvent {
  final BuildContext context;
  final int selectedIndex;
  const ViewTaskSelectedFilterStatusEvent({required this.context, required this.selectedIndex});
  @override
  List<Object?> get props => [context, selectedIndex];
}

