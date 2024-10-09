part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomePageLoadEvent extends HomeEvent {
  final BuildContext context;

  const HomePageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class HomePageRefreshEvent extends HomeEvent {
  final BuildContext context;

  const HomePageRefreshEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class HomeDrawerItemSelectedEvent extends HomeEvent {
  final bool isSelected;
  final int index;
  final BuildContext context;

  const HomeDrawerItemSelectedEvent(
      {required this.isSelected, required this.index, required this.context});

  @override
  List<Object?> get props => [isSelected, index, context];
}

class HomeDrawerItemSubListSelectedEvent extends HomeEvent {
  final bool isSelected;
  final int index;
  final int listIndex;

  const HomeDrawerItemSubListSelectedEvent({
    required this.isSelected,
    required this.index,
    required this.listIndex,
  });

  @override
  List<Object?> get props => [isSelected, index, listIndex];
}

class HomeChangeBottomNavigationItemEvent extends HomeEvent {
  final int index;
  final BuildContext context;

  const HomeChangeBottomNavigationItemEvent(
      {required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}

class HomePageNotificationSilentEvent extends HomeEvent {
  final BuildContext context;

  const HomePageNotificationSilentEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
