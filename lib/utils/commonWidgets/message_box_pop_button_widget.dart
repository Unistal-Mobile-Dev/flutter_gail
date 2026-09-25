import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class MessageBoxPopButtonWidget extends StatelessWidget {
  final String message;
  final String title;
  final String? buttonText;
  final VoidCallback onPressed;

  const MessageBoxPopButtonWidget(
      {super.key,
      required this.message,
      required this.title,
      this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _closeButton(context: context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: TextWidget(
                        message,
                        color: AppColor.black,
                        textAlign: TextAlign.center,
                        fontSize: AppFont.font_13,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[350],
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.015),
                      child: TextButton(
                        onPressed: onPressed,
                        child: TextWidget(
                          buttonText?? "OK",
                          fontWeight: FontWeight.w700,
                          color: EnvironmentConfig.of(context)!.primaryTheme,
                          fontSize: AppFont.font_16,
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _closeButton({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 0.05,
            ),
            child: TextWidget(
              title,
              fontSize: AppFont.font_18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }
}
