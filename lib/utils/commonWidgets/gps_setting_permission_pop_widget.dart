import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSSettingPermissionPopWidget extends StatelessWidget {
  const GPSSettingPermissionPopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.43,
        width: MediaQuery.of(context).size.width / 1.3,
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              _closeButton(context: context),
              _centerImage(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _text(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              _settingButton(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerImage({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: Icon(
        Icons.gps_off,
        size: MediaQuery.of(context).size.height * 0.09,
        color: AppColor.red,
      ),
    );
  }

  Widget _text({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: TextWidget(
        "Your GPS Permission Status is Denied.\n Please Allow all the time app Permission.",
        textAlign: TextAlign.center,
        color: AppColor.black,
        fontWeight: FontWeight.w500,
        fontSize: AppFont.font_12,
      ),
    );
  }

  Widget _settingButton({
    required BuildContext context,
  }) {
    return TextButton(
        style: ButtonStyle(
            padding:
                WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
            foregroundColor:
                WidgetStateProperty.all<Color>(AppColor.themeColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColor.themeColor)))),
        onPressed: () async {
          await openAppSettings();
          if (!context.mounted) return;
          Navigator.pop(context);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: TextWidget(
            "Open Setting",
            textAlign: TextAlign.center,
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w500,
            color: AppColor.themeColor,
          ),
        ));
  }

  Widget _closeButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: AppColor.grey,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
