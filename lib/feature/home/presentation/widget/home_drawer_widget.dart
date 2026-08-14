import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/presentation/widget/logout_widget.dart';
import 'package:flutter_gail/feature/imageShare/presentation/page/image_share_page.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/page/task_page.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/page/add_tlp_survey_page.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class HomeDrawerWidget extends StatelessWidget {
  HomeDrawerWidget({super.key});

  final LoginDataModel _userData = AppConfig.instanceInit()!.userData;

  LoginDataModel get userData => _userData;

  bool isAssignTask = false;

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = AppConfig.instanceInit()!.userData;
    if (userData.groupRoles != null) {
      for (var moduleData in userData.groupRoles!) {
        if (moduleData.permissions != null &&
            moduleData.moduleName.toString() ==
                "pipeline_patrolling_suervielliance") {
          for (var permissionData in moduleData.permissions!) {
            if (permissionData.name.toString().toLowerCase() == "write") {
              isAssignTask = permissionData.value ?? false;
            }
          }
        }
      }
    }

    // Get the dashboard module object safely
    final dashboardModule = userData.groupRoles!.firstWhere(
      (element) => element.moduleName!.toLowerCase() == "dashboard",
      orElse: () => GroupRoles(moduleName: ""), // provide a default Modules object
    );
    final dashboardName = dashboardModule.moduleName;

    // Get the pipeline_patrolling_suervielliance module object safely
    final taskModule = userData.groupRoles!.firstWhere(
      (element) =>
          element.moduleName!.toLowerCase() ==
          "pipeline_patrolling_suervielliance",
      orElse: () => GroupRoles(moduleName: ""), // provide a default Modules object
    );
    final taskName = taskModule.moduleName;

    // Get the pipeline_cp_system module object safely
    final tlpSurveyModule = userData.groupRoles!.firstWhere(
      (element) => element.moduleName!.toLowerCase() == "pipeline_cp_system",
      orElse: () => GroupRoles(moduleName: ""), // provide a default Modules object
    );
    final tlpSurveyName = tlpSurveyModule.moduleName;

    // Get the image_sharing module object safely
    final imageSharingModule = userData.groupRoles!.firstWhere(
      (element) => element.moduleName!.toLowerCase() == "image_sharing",
      orElse: () => GroupRoles(moduleName: ""), // provide a default Modules object
    );
    final imageSharingName = imageSharingModule.moduleName;

    // Get the pgis module object safely
    final pgisModule = userData.groupRoles!.firstWhere(
      (element) => element.moduleName!.toLowerCase() == "pgis",
      orElse: () => GroupRoles(moduleName: ""), // provide a default Modules object
    );
    final pgisName = pgisModule.moduleName;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchHomeDataState) {
          return Container(
            color: AppColor.white,
            child: Container(
              // color: AppColor.white,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    EnvironmentConfig.of(context)!.primaryTheme,
                    EnvironmentConfig.of(context)!.secondaryTheme.withOpacity(0.7),
                    EnvironmentConfig.of(context)!.primaryTheme,
                  ],
                ),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: ListView(
                children: [
                  _header(context: context),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.10),
                  dashboardName.toString().isNotEmpty
                      ? _dashboard(context: context)
                      : const SizedBox.shrink(),

                  taskName.toString().isNotEmpty
                      ? _task(context: context)
                      : const SizedBox.shrink(),

                  tlpSurveyName.toString().isNotEmpty
                      ? _tlpSurvey(context: context)
                      : const SizedBox.shrink(),

                  imageSharingName.toString().isNotEmpty
                      ? _imageSharing(context: context)
                      : const SizedBox.shrink(),
                  _logout(context: context),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }

  Widget _header({required BuildContext context}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            AppIcon.logo(),
            height: MediaQuery.of(context).size.width * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "${userData.users!.fullName.toString()}}",
                fontSize: AppFont.font_14,
                color: AppColor.white,
              ),
              TextWidget(
                userData.users!.email.toString(),
                color: AppColor.white,
                fontSize: AppFont.font_12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dashboard({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(
            SelectWidgetHomeEvent(
              widget: const DashboardPage(),
              title: AppString.dashboard,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.home_outlined, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.dashboard,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _task({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(
            SelectWidgetHomeEvent(
              widget: TaskPage(isAssignTask: isAssignTask),
              title: AppString.task,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.task_outlined, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.task,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tlpSurvey({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(
            SelectWidgetHomeEvent(
              widget: const AddTlpSurveyPage(),
              title: AppString.tlpSurvey,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.add_chart, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.tlpSurvey,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSharing({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(
            SelectWidgetHomeEvent(
              widget: const ImageSharePage(),
              title: AppString.imageSharing,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.image_aspect_ratio, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.imageSharing,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pgis({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => PgisPage()),
          // );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.gps_fixed_sharp, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.pgis,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logout({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const LogoutWidget(),
          );
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(Icons.logout, color: AppColor.white),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            TextWidget(
              AppString.logout,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
