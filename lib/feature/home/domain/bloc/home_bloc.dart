import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_gail/feature/home/helper/home_helper.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
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
    on<SelectWidgetHomeEvent>(_selectWidget);
    on<HomeChangeBottomNavigationItemEvent>(_changeBottomNavigationBarIndex);
    on<HomePageNotificationSilentEvent>(_notificationSilent);
  }

  _pageLoad(HomePageLoadEvent event, emit) async {
    emit(HomePageLoadState());
    _bottomTabIndex = 0;
    _userData = UserInfo.instance!.userData!;
    _bottomNavigationBarItemList = [];
    _restaurantMenu = [];
    _pageWidgetList = [];
    _childWidget = Container();
    _title = "Dashboard";
    _actionButtonWidget = const SizedBox.shrink();


    // await DashboardHelper.checkAppVersion(event.context);

    String notificationSilent = await SharedPreferencesUtils.getString(key: PreferencesName.notificationSilent);
    if(notificationSilent == "1"){
      isNotificationSilent =  true;
    } else {
      isNotificationSilent =  false;
    }

    await LoginHelper.addDevice(userId: userData.users!.id.toString(),
        context: !event.context.mounted ? event.context : event.context);

    List<DrawerModel> pageList = await HomeHelper.fetchPageList();
    if(pageList.isNotEmpty){
      _childWidget = pageList[0].widget;
      _title =  pageList[0].label.toString();
    }
    
    _eventCompleted(emit);

  }

  _selectWidget(SelectWidgetHomeEvent event, emit) {
    _childWidget =  event.widget;
    _title =  event.title;
    _eventCompleted(emit);
  }

  _changeBottomNavigationBarIndex(
      HomeChangeBottomNavigationItemEvent event, emit) async {
    Vibration.vibrate(duration: 100);
      _bottomTabIndex = event.index;
    List<DrawerModel> pageList = await HomeHelper.fetchPageList();
    if(pageList.isNotEmpty){
      _childWidget = pageList[bottomTabIndex].widget;
      _title =  pageList[bottomTabIndex].label.toString();
    }

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
