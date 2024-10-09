import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class SnackBarErrorWidget {
  final BuildContext context;

  SnackBarErrorWidget(this.context);

  show({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColor.themeSecondary,
        content: TextWidget(
      message,
      fontSize: AppFont.font_14,
      color: AppColor.red,
    )));
  }
}
