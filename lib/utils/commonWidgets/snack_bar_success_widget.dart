import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class SnackBarSuccessWidget {
  final BuildContext context;

  SnackBarSuccessWidget(this.context);

  show({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: TextWidget(
        message,
        fontSize: AppFont.font_14,
        color: AppColor.white,
      ),
      backgroundColor: AppColor.themeColor,
    ));
  }
}
