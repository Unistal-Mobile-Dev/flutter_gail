import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class SnackBarSuccessWidget {
  final BuildContext context;

  SnackBarSuccessWidget(this.context);

  show({required dynamic message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: TextWidget(
        message.toString(),
        fontSize: AppFont.font_14,
        color: AppColor.white,
      ),
      backgroundColor:Colors.green,
    ));
  }
}
