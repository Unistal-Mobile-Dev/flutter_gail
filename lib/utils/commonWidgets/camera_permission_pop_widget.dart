import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionPopWidget extends StatelessWidget {
  const CameraPermissionPopWidget({super.key});

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
        Icons.camera_alt_outlined,
        size: MediaQuery.of(context).size.height * 0.09,
        color: AppColor.red,
      ),
    );
  }

  Widget _text({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: TextWidget(
        "Your Camera Permission Status is Denied.\n Please Allow the app Permission.",
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
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
            foregroundColor:
                MaterialStateProperty.all<Color>(AppColor.themeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColor.themeColor)))),
        onPressed: () async {
          await openAppSettings();
          Navigator.pop(!context.mounted ? context : context);
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
