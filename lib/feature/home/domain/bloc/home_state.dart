part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePageLoadState extends HomeInitial {
  @override
  List<Object> get props => [];
}

class FetchHomeDataState extends HomeInitial {
  final bool isLoader;
  final List<BottomNavigationBarItem> bottomNavigationBarItemList;
  final int bottomTabIndex;
  final RoleType roleType;
  final List<Widget> pageWidgetList;
  final List<DrawerModel> drawerList;
  final Widget childWidget;
  final Widget actionButtonWidget;
  final String title;
  final bool isNotificationSilent;

  FetchHomeDataState({
    required this.isLoader,
    required this.bottomNavigationBarItemList,
    required this.bottomTabIndex,
    required this.roleType,
    required this.pageWidgetList,
    required this.drawerList,
    required this.childWidget,
    required this.title,
    required this.actionButtonWidget,
    required this.isNotificationSilent,
  });

  @override
  List<Object> get props => [
        isLoader,
        bottomNavigationBarItemList,
        bottomTabIndex,
        roleType,
        pageWidgetList,
        drawerList,
        childWidget,
        title,
        actionButtonWidget,
        isNotificationSilent,
      ];
}
