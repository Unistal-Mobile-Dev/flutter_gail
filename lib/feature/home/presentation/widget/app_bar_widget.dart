/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final Widget? tabBar;

  const AppBarWidget({
    Key? key,
    this.title,
    this.leadingWidget,
    this.boolLeading,
    this.actions,
    this.tabBar,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: (boolLeading ?? true) && leadingWidget == null,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.themeColor,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: AppColor.themeColor,
      elevation: 0,
      centerTitle: true,
      leading: leadingWidget,
      title: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Text(
          title ?? "",
          textAlign: TextAlign.center,
        ),
      ),
      actions: actions ?? [],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: tabBar ?? Container(),
      ),
    );
  }
}*/
