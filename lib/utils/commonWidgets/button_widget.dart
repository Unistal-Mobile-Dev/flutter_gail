import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? fontSize;
  final bool? isSideBoard;
  final Color? backgroundColor;
  final double? height;
  final bool? isLockIcon;
  final BoxDecoration? gradientDecorationColor;

  const ButtonWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      this.fontSize,
      this.gradientDecorationColor,
      this.isSideBoard,
      this.backgroundColor,
      this.height,
      this.isLockIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height ?? MediaQuery.of(context).size.height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? EnvironmentConfig.of(context)!.primaryTheme,
          side: isSideBoard == true
              ? BorderSide(
                  width: 1,
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLockIcon == true
                    ? Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColor.white,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      )
                    : const SizedBox.shrink(),
                TextWidget(
                  text,
                  color: isSideBoard == true
                      ? EnvironmentConfig.of(context)!.primaryTheme
                      : AppColor.white,
                  fontSize: fontSize ?? AppFont.font_14,
                  fontWeight: FontWeight.w700,
                ),
              ],
            )),
      ),
    );
  }
}
