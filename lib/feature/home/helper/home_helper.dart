import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';


class HomeHelper {
  static Future<dynamic> fetchDrawerList(
      {required BuildContext context}) async {
    try {
      List<DrawerModel> drawerList = [];
      drawerList.add(DrawerModel(
          widget: const DashboardPage(),
          icon: Icons.home_outlined,
          label: AppString.dashboard,
          sublist: [],
          isSelected: true));

      return drawerList;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchAppBottomBarItems(
      {required BuildContext context}) async {
    List<BottomNavigationBarItem> bottomNavigationBarItemList = [];
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
/*        bottomNavigationBarItemList.add(BottomNavigationBarItem(
          icon: Image.asset(
            AppIcon.gailLogo,
            height: 20.0,
          ),
          label: AppString.appName,
        ));*/
    } catch (_) {}

    return bottomNavigationBarItemList;
  }

  static Future<dynamic> fetchPageList() async {
    List<Widget> pageList = [];
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      pageList.add( const DashboardPage());
    } catch (_) {}
    return pageList;
  }

}
