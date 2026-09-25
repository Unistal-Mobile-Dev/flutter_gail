import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class MessageBoxTwoButtonPopWidget extends StatelessWidget {
  final String message;
  final String? okButtonText;
  final VoidCallback onPressed;
  final double? width;
  final Color? okButtonColour;

  const MessageBoxTwoButtonPopWidget(
      {super.key,
      required this.message,
      required this.onPressed,
      this.okButtonText,
      this.width,
      this.okButtonColour,
      });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          SizedBox(
            width: width ?? MediaQuery.of(context).size.width * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
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
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: TextWidget(
                              "Cancel",
                              color: AppColor.grey,
                              fontSize: AppFont.font_14,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: 1.0,
                          color: Colors.grey[350],
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: onPressed,
                            child: TextWidget(
                              okButtonText ?? "OK",
                              fontWeight: FontWeight.w700,
                              color: okButtonColour ?? EnvironmentConfig.of(context)!.primaryTheme,
                              fontSize: AppFont.font_14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
              "Alert !",
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
