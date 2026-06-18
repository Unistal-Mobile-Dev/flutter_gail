
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

  /// NEW: allow custom title widget (for Bloc)
  final Widget? titleWidget;

  /// NEW: enable gradient
  final bool isGradient;

  const AppBarWidget({
    Key? key,
    this.title,
    this.leadingWidget,
    this.boolLeading,
    this.actions,
    this.tabBar,
    this.titleWidget,
    this.isGradient = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
      (boolLeading ?? true) && leadingWidget == null,
      leading: leadingWidget,
      elevation: 0,
      centerTitle: true,

      /// STATUS BAR
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),

      /// ICON COLOR
      iconTheme: const IconThemeData(color: Colors.white),

      /// BACKGROUND (fallback if gradient = false)
      backgroundColor: isGradient ? Colors.transparent : EnvironmentConfig.of(context)!.primaryTheme,

      /// TITLE
      title: titleWidget ??
          Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),

      /// ACTIONS
      actions: actions ?? [],

      /// GRADIENT
      flexibleSpace: isGradient
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              EnvironmentConfig.of(context)!.secondaryTheme,
              EnvironmentConfig.of(context)!.primaryTheme,
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          color: EnvironmentConfig.of(context)!.primaryTheme,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),

      /// TAB BAR
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: tabBar ?? Container(),
      ),
    );
  }
}