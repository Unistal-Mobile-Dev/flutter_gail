import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class LogOutPopWidget extends StatelessWidget {
  final String? logOutMessage;

  const LogOutPopWidget({super.key, this.logOutMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.43,
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
              _logOutButton(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _cancelButton(context: context)
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
        Icons.lock_open,
        color: EnvironmentConfig.of(context)!.secondaryTheme,
        size: MediaQuery.of(context).size.height * 0.09,
      ),
    );
  }

  Widget _text({required BuildContext context}) {
    return TextWidget(
      logOutMessage == null ? "Do you want logout?" : logOutMessage.toString(),
      textAlign: TextAlign.center,
      color: AppColor.black,
      fontWeight: FontWeight.w500,
      fontSize: AppFont.font_16,
    );
  }

  Widget _logOutButton({required BuildContext context}) {
    return TextButton(
        style: ButtonStyle(
            padding:
                WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
            foregroundColor:
                WidgetStateProperty.all<Color>(EnvironmentConfig.of(context)!.primaryTheme),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: EnvironmentConfig.of(context)!.primaryTheme)))),
        onPressed: () async {
/*          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      LoginScreenPage()),
                  (Route<dynamic> route) => false);*/
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: TextWidget(
            "Log Out",
            textAlign: TextAlign.center,
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w500,
            color: EnvironmentConfig.of(context)!.primaryTheme,
          ),
        ));
  }

  Widget _cancelButton({required BuildContext context}) {
    return TextButton(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: TextWidget(
            "Cancel",
            textAlign: TextAlign.center,
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w400,
            color: AppColor.grey,
          ),
        ),
        onPressed: () => Navigator.pop(context));
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
