import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/domain/model/firebase_device_model.dart';
import 'package:flutter_gail/feature/imageShare/presentation/page/image_share_page.dart';
import 'package:flutter_gail/feature/pgis/presentation/page/pgis_page.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/page/task_page.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/page/add_tlp_survey_page.dart';
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
    } catch (_) {}

    return bottomNavigationBarItemList;
  }

  static Future<dynamic> fetchPageList() async {
    List<DrawerModel> pageList = [];
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;

      // Get the dashboard module object safely
      final dashboardModule = userData.modules!.firstWhere(
            (element) => element.moduleId!.toString() == "dashboard",
        orElse: () => Modules(moduleName: ""), // provide a default Modules object
      );
      final dashboardName = dashboardModule.moduleName;

      // Get the pipeline_patrolling_suervielliance module object safely
      final taskModule = userData.modules!.firstWhere(
            (element) => element.moduleId!.toString() == "166",
        orElse: () => Modules(moduleName: ""), // provide a default Modules object
      );
      final taskName = taskModule.moduleName;

      // Get the pipeline_cp_system module object safely
      final tlpSurveyModule = userData.modules!.firstWhere(
            (element) => element.moduleId!.toString() == "pipeline_cp_system",
        orElse: () => Modules(moduleName: ""), // provide a default Modules object
      );
      final tlpSurveyName = tlpSurveyModule.moduleName;

      // Get the image_sharing module object safely
      final imageSharingModule = userData.modules!.firstWhere(
            (element) => element.moduleId!.toString() == "image_sharing",
        orElse: () => Modules(moduleName: ""), // provide a default Modules object
      );
      final imageSharingName = imageSharingModule.moduleName;

      // Get the pgis module object safely
      final pgisModule = userData.modules!.firstWhere(
            (element) => element.moduleId!.toString() == "pgis",
        orElse: () => Modules(moduleName: ""), // provide a default Modules object
      );
      final pgisName = pgisModule.moduleName;

      // Dashboard
      if(dashboardName.toString().isNotEmpty) {
        pageList.add(
          DrawerModel(widget: const DashboardPage(), label: AppString.dashboard)
        );
      }

      // Task
      if(taskName.toString().isNotEmpty) {
        bool isAssignTask =  false;
        for (var permissionData in taskModule.permissionList!) {
          if (permissionData.name.toString().toLowerCase() == "write") {
            isAssignTask = permissionData.value ?? false;
          }
        }
        pageList.add(
            DrawerModel(widget: TaskPage(isAssignTask: isAssignTask,), label: AppString.task)
        );
      }

      // Tlp Survey
      if(tlpSurveyName.toString().isNotEmpty) {
        pageList.add(
            DrawerModel(widget: AddTlpSurveyPage(), label: AppString.tlpSurvey)
        );
      }

      // image Sharing
      if(imageSharingName.toString().isNotEmpty) {
        pageList.add(
            DrawerModel(widget: ImageSharePage(), label: AppString.imageSharing)
        );
      }

      // pgis
      if(pgisName.toString().isNotEmpty) {
        pageList.add(
            DrawerModel(widget: DashboardPage(), label: AppString.dashboard)
        );
      }

    } catch (e) {
      print("Dashboard list fetch  ========================= ${e.toString()}");
    }
    return pageList;
  }

}
