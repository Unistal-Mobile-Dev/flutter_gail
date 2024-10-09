import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class MessageBoxPopWidget extends StatelessWidget {
  final String message;

  const MessageBoxPopWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width / 1.2,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _closeButton(context: context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: TextWidget(
                    message,
                    color: AppColor.black,
                    textAlign: TextAlign.center,
                    fontSize: AppFont.font_12,
                  ),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: ButtonWidget(
                      text: "Ok",
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _closeButton({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextWidget(
            "     Alert",
            fontSize: AppFont.font_16,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            color: AppColor.themeColor,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: AppColor.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
