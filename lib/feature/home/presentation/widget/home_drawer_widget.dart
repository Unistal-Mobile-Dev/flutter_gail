import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/presentation/widget/logout_widget.dart';
import 'package:flutter_gail/feature/imageShare/presentation/page/image_share_page.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/presentation/page/add_incident_page.dart';
import 'package:flutter_gail/feature/pgis/presentation/page/pgis_page.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/page/task_page.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/page/add_tlp_survey_page.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

class HomeDrawerWidget extends StatelessWidget {
  HomeDrawerWidget({super.key});

  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  bool isImageSharing = false;
  bool isAssignTask = false;

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    if (userData.modules != null) {
      for (var moduleData in userData.modules!) {
        if (moduleData.permissionList != null &&
            moduleData.moduleName.toString() == "image_sharing") {
          isImageSharing = true;
        }

        if (moduleData.permissionList != null &&
            moduleData.moduleName.toString() ==
                "pipeline_patrolling_suervielliance") {
          for (var permissionData in moduleData.permissionList!) {
            if (permissionData.name.toString().toLowerCase() == "write") {
              isAssignTask = permissionData.value ?? false;
            }
          }
        }
      }
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchHomeDataState) {
          return Container(
            color: AppColor.white,
            child: Container(
              // color: AppColor.white,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 230, 55, 70),
                    Color.fromARGB(230, 216, 77, 89),
                    Color.fromARGB(255, 230, 55, 70),
                  ],
                ),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: ListView(
                children: [
                  _header(context: context),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.10,
                  ),
                  _dashboard(context: context),
                  _task(context: context),
                  _tlpSurvey(context: context),
                  _incident(context: context),
                  isImageSharing == true
                      ? _imageSharing(context: context)
                      : const SizedBox.shrink(),
                  _pgis(context: context),
                  _logout(context: context),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
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
            AppConfig.instanceInit()!.client == Client.gail
                ? AppIcon.gailLogo
                : AppIcon.gailLogo,
            height: MediaQuery.of(context).size.width * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "${userData.users!.firstName.toString()} ${userData.users!.surName.toString()}",
                fontSize: AppFont.font_14,
                color: AppColor.white,
              ),
              TextWidget(
                userData.users!.emailId.toString(),
                color: AppColor.white,
                fontSize: AppFont.font_12,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _listBuilder({required FetchHomeDataState dataState}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataState.drawerList.length,
        itemBuilder: (context, index) {
          return _itemBuilder(
              context: context,
              drawerData: dataState.drawerList[index],
              index: index);
        });
  }

  Widget _itemBuilder(
      {required BuildContext context,
      required DrawerModel drawerData,
      required int index}) {
    return GestureDetector(
      onTap: () {
        if (drawerData.sublist.isEmpty) {
          Navigator.pop(context);
        }
        if (drawerData.isSelected == false) {
          BlocProvider.of<HomeBloc>(context).add(HomeDrawerItemSelectedEvent(
              isSelected: true, index: index, context: context));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      drawerData.icon,
                      color: drawerData.isSelected == true
                          ? AppColor.white
                          : AppColor.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Expanded(
                  child: TextWidget(
                    drawerData.label,
                    fontSize: AppFont.font_13,
                    color: drawerData.isSelected == true
                        ? AppColor.white
                        : AppColor.white,
                    fontWeight: drawerData.isSelected == true
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                Icon(
                  drawerData.isSelected == true && drawerData.sublist.isNotEmpty
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_right_sharp,
                  color: AppColor.white,
                ),
              ],
            ),
            drawerData.isSublistLoader == false ||
                    drawerData.isSublistLoader == null
                ? drawerData.sublist.isNotEmpty && drawerData.isSelected == true
                    ? _subListBuilder(
                        context: context,
                        drawerData: drawerData,
                        listIndex: index)
                    : const SizedBox.shrink()
                : const DottedLoaderWidget(),
          ],
        ),
      ),
    );
  }

  Widget _subListBuilder(
      {required BuildContext context,
      required DrawerModel drawerData,
      required int listIndex}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: drawerData.sublist.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<HomeBloc>(context).add(
                      HomeDrawerItemSubListSelectedEvent(
                          isSelected: true,
                          index: index,
                          listIndex: listIndex));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: MediaQuery.of(context).size.width * 0.03,
                      color: drawerData.sublist[index].isSelected == true
                          ? AppColor.themeColor
                          : AppColor.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Expanded(
                      child: TextWidget(
                        drawerData.sublist[index].label.toString(),
                        fontSize: AppFont.font_12,
                        color: drawerData.sublist[index].isSelected == true
                            ? AppColor.themeColor
                            : AppColor.white,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _dashboard({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context)
              .add(SelectWidgetHomeEvent(widget: const DashboardPage(), title: AppString.dashboard));
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
                child: Icon(
                  Icons.home_outlined,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(SelectWidgetHomeEvent(
              widget: TaskPage(isAssignTask: isAssignTask), title: AppString.task));
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
                child: Icon(
                  Icons.task_outlined,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(SelectWidgetHomeEvent(
              widget: const AddTlpSurveyPage(), title: AppString.tlpSurvey));
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
                child: Icon(
                  Icons.add_chart,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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

  Widget _incident({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<AddIncidentBloc>(context).add(AddIncidentPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddIncidentPage()),
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
                child: Icon(
                  Icons.account_tree_outlined,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              AppString.incident,
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
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(SelectWidgetHomeEvent(
              widget: const ImageSharePage(), title: AppString.imageSharing));
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
                child: Icon(
                  Icons.image_aspect_ratio,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          // BlocProvider.of<HomeBloc>(context).add(SelectWidgetHomeEvent(
          //     widget: PgisPage(), title: AppString.pgis));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PgisPage()),
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
                child: Icon(
                  Icons.gps_fixed_sharp,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context, builder: (context) => const LogoutWidget());
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
                child: Icon(
                  Icons.logout,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
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
