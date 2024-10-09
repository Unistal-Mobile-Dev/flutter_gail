import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateMessage {
  static showAlertDialog({required BuildContext context}) {
    Widget cancelButton = TextButton(
      child: TextWidget(
        "Update Later",
        fontSize: AppFont.font_14,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: TextWidget(
        "Update Now",
        fontSize: AppFont.font_14,
        color: AppColor.themeColor,
        fontWeight: FontWeight.w700,
      ),
      onPressed: () async {
        if (!await launchUrl(
          Uri.parse(
              "https://play.google.com/store/apps/details?id=com.purvabhartisteel.app"),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch ');
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Builder(builder: (context) {
        return TextWidget(
          "Update Available",
          fontSize: AppFont.font_16,
          fontWeight: FontWeight.w700,
        );
      }),
      content: TextWidget(
        "Please update the app to continue",
        fontSize: AppFont.font_14,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
