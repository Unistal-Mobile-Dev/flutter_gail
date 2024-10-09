import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_gail/feature/home/presentation/widget/logout_widget.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_gail/utils/commonWidgets/message_box_two_button_pop.dart';

class TabletDrawerWidget extends StatelessWidget {
  final FetchHomeDataState dataState;

  const TabletDrawerWidget({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.themeLightColor,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _logo(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              _listBuilder(dataState: dataState),
/*               _changePassword(context: context),*/
              _logout(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo({required BuildContext context}) {
    return Hero(
      tag: 'logo',
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
/*            Image.asset(
              AppIcon.appLogo,
            ),*/
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Image.asset(
                AppConfig.instanceInit()!.client == Client.gail
                    ? AppIcon.gailLogo
                    : AppIcon.gailLogo,
                width: MediaQuery.of(context).size.width * 0.13,
              ),
            ),
          ],
        ),
      ),
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
        if (drawerData.isSelected == false) {
          BlocProvider.of<HomeBloc>(context).add(HomeDrawerItemSelectedEvent(
              isSelected: true, index: index, context: context));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.01,
            bottom: MediaQuery.of(context).size.width * 0.01),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  drawerData.icon,
                  color: drawerData.isSelected == true
                      ? AppColor.white
                      : AppColor.black,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.008,
                ),
                Expanded(
                  child: TextWidget(
                    drawerData.label,
                    fontSize: AppFont.font_13,
                    color: drawerData.isSelected == true
                        ? AppColor.white
                        : AppColor.black,
                    fontWeight: drawerData.isSelected == true
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Icon(
                  drawerData.isSelected == true && drawerData.sublist.isNotEmpty
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_right_sharp,
                  color: AppColor.black,
                ),
              ],
            ),
            drawerData.sublist.isNotEmpty && drawerData.isSelected == true
                ? _subListBuilder(
                    context: context, drawerData: drawerData, listIndex: index)
                : const SizedBox.shrink(),
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
                  /*   Navigator.of(context).pop();*/
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
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: drawerData.sublist[index].isSelected == true
                          ? AppColor.white
                          : AppColor.black,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(
                      child: TextWidget(
                        drawerData.sublist[index].label.toString(),
                        fontSize: AppFont.font_12,
                        color: drawerData.sublist[index].isSelected == true
                            ? AppColor.white
                            : AppColor.black,
                      ),
                    ),

                    //Icon( Icons.keyboard_arrow_right_sharp, color: AppColor.black,),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _logout({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.01,
          bottom: MediaQuery.of(context).size.width * 0.01),
      child: GestureDetector(
        onTap: () async {
          if (AppConfig.getDeviceType(context: context) == DeviceType.phone) {
            showModalBottomSheet(
                context: context, builder: (context) => const LogoutWidget());
          } else {
            bool isLogout = (await showDialog(
                    context: context,
                    builder: (BuildContext mContext) =>
                        MessageBoxTwoButtonPopWidget(
                            width: MediaQuery.of(context).size.width / 2.5,
                            message: AppString.logoutMessage,
                            okButtonText: AppString.logout,
                            onPressed: () =>
                                Navigator.of(context).pop(true)))) ??
                false;

            if (isLogout == true) {
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreenPage()),
                  (route) => false);
              SharedPreferencesUtils.clearAll();
            }
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.logout,
              color: AppColor.black,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            TextWidget(
              AppString.logout,
              fontSize: AppFont.font_12,
            ),
          ],
        ),
      ),
    );
  }
}
