import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_gail/feature/home/helper/home_helper.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:vibration/vibration.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<BottomNavigationBarItem> _bottomNavigationBarItemList = [];

  List<BottomNavigationBarItem> get bottomNavigationBarItemList =>
      _bottomNavigationBarItemList;

  int _bottomTabIndex = 0;

  int get bottomTabIndex => _bottomTabIndex;

  final bool _isLoader = false;

  bool get isLoader => _isLoader;

  RoleType _roleType = RoleType.patrollingMan;

  RoleType get roleType => _roleType;

  List<Widget> _pageWidgetList = [];

  List<Widget> get pageWidgetList => _pageWidgetList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<DrawerModel> _drawerList = [];

  List<DrawerModel> get drawerList => _drawerList;

  Widget _childWidget = Container();

  Widget get childWidget => _childWidget;

  String _title = "";

  String get title => _title;

  Widget _actionButtonWidget = const SizedBox.shrink();

  Widget get actionButtonWidget => _actionButtonWidget;

  List<DrawerSubModel> _restaurantMenu = [];

  List<DrawerSubModel> get restaurantMenu => _restaurantMenu;

  List<FirebaseDeviceModel> firebaseDeviceList = [];

  bool isNotificationSilent =  false;

  HomeBloc() : super(HomeInitial()) {
    on<HomePageLoadEvent>(_pageLoad);
    on<HomeDrawerItemSelectedEvent>(_drawerItemSelected);
    on<HomeDrawerItemSubListSelectedEvent>(_drawerSublistSelected);
    on<HomeChangeBottomNavigationItemEvent>(_changeBottomNavigationBarIndex);
    on<HomePageNotificationSilentEvent>(_notificationSilent);
  }

  _pageLoad(HomePageLoadEvent event, emit) async {
    emit(HomePageLoadState());
    _bottomTabIndex = 0;
    _userData = UserInfo.instance!.userData!;
    _roleType = userData.roleType!;
    _bottomNavigationBarItemList = [];
    _restaurantMenu = [];
    _pageWidgetList = [];
    FirebaseService.instance.setupInteractedMessage();
    _title = "Complaint ( ${userData.roleName} )";
    _childWidget = const DashboardPage();
    _actionButtonWidget = const SizedBox.shrink();

    String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
    if(notificationSilent == "1"){
      isNotificationSilent =  true;
    } else {
      isNotificationSilent =  false;
    }

    _drawerList = await HomeHelper.fetchDrawerList(
        context: !event.context.mounted ? event.context : event.context);
    _bottomNavigationBarItemList = await HomeHelper.fetchAppBottomBarItems(
        context: !event.context.mounted ? event.context : event.context);
    List<Widget> pageList = await HomeHelper.fetchPageList();
    if (pageList.isNotEmpty) {
      _childWidget = pageList[bottomTabIndex];
    }
    _eventCompleted(emit);

  }

  _drawerItemSelected(HomeDrawerItemSelectedEvent event, emit) async {
    List<DrawerModel> tempList = drawerList;
    _drawerList = [];
    _eventCompleted(emit);

    for (int i = 0; i < tempList.length; i++) {
      if (i == event.index) {
        tempList[event.index].isSelected = event.isSelected;
        if (tempList[event.index].sublist.isEmpty) {
          _childWidget = tempList[event.index].widget;
          _title = tempList[event.index].label;
          _actionButtonWidget = tempList[event.index].actionButtonWidget ??
              const SizedBox.shrink();
        }
      } else {
        tempList[i].isSelected = false;
        for (int j = 0; j < tempList[i].sublist.length; j++) {
          tempList[i].sublist[j].isSelected = false;
        }
      }
    }
    _drawerList = [];
    _eventCompleted(emit);
    _drawerList = tempList;
    _eventCompleted(emit);
  }

  _drawerSublistSelected(HomeDrawerItemSubListSelectedEvent event, emit) {
    List<DrawerModel> tempList = drawerList;
    _drawerList = [];
    _eventCompleted(emit);

    for (int i = 0; i < tempList.length; i++) {
      if (i == event.listIndex) {
        for (int j = 0; j < tempList[i].sublist.length; j++) {
          if (j == event.index) {
            tempList[i].sublist[j].isSelected = event.isSelected;
            _childWidget = tempList[i].sublist[j].widget!;
            _title = tempList[i].sublist[j].label.toString();
            _actionButtonWidget = tempList[i].sublist[j].actionButtonWidget ??
                const SizedBox.shrink();
          } else {
            tempList[i].sublist[j].isSelected = false;
          }
        }
      } else {
        for (int j = 0; j < tempList[i].sublist.length; j++) {
          tempList[i].sublist[j].isSelected = false;
        }
      }
    }
    _drawerList = tempList;
    _eventCompleted(emit);
  }

  _changeBottomNavigationBarIndex(
      HomeChangeBottomNavigationItemEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    _bottomTabIndex = event.index;
    List<Widget> pageList = await HomeHelper.fetchPageList();
    print(pageList.length);
    _childWidget = pageList[bottomTabIndex];
    _eventCompleted(emit);
  }

  _notificationSilent(HomePageNotificationSilentEvent event, emit) async {
    String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
    if(notificationSilent == "1"){
      isNotificationSilent =  false;
      SharedPreferencesUtils.setString(key: PreferencesName.notificationSilent, value: "0");
    } else {
      isNotificationSilent =  true;
      SharedPreferencesUtils.setString(key: PreferencesName.notificationSilent, value: "1");
    }
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<HomeState> emit) {
    emit(FetchHomeDataState(
      isLoader: isLoader,
      bottomNavigationBarItemList: bottomNavigationBarItemList,
      bottomTabIndex: bottomTabIndex,
      roleType: roleType,
      pageWidgetList: pageWidgetList,
      drawerList: drawerList,
      childWidget: childWidget,
      title: title,
      actionButtonWidget: actionButtonWidget,
      isNotificationSilent: isNotificationSilent,
    ));
  }
}
