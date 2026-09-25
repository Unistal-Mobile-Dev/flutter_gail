import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

import 'environment_config.dart';

ThemeData appTheme({required BuildContext context}) {
  final primary = EnvironmentConfig.of(context)!.primaryTheme;
  return ThemeData(
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: AppColor.white,
      onSurface: Colors.black,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary; // the color when checkbox is selected;
        }
        return Colors.white; //the color when checkbox is unselected;
      }),
      checkColor: WidgetStateProperty.all<Color>(AppColor.white),
      side: const BorderSide(color: Color(0xff585858)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColor.black),
      ),
    ),
    primaryColor: primary,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColor.white),
      color: primary,
    ),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: primary,
      headerForegroundColor: Colors.white,
      backgroundColor: Colors.white,
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primary),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColor.grey),
      ),
      surfaceTintColor: Colors.white,
      dayStyle: TextStyle(color: primary),
      weekdayStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.w700,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.white,
      surfaceTintColor: AppColor.white,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    primarySwatch: Colors.pink,
    fontFamily: AppFont.merriweather,
  );
}

Widget appBackGround({
  required Widget child,
  required BuildContext context,
  bool? isGradientChange,
  bool? isRemoveBackground,
}) {
  return Container();
}
