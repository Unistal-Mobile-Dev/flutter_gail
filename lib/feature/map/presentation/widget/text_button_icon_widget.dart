import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class TextButtonIconWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  /// Optional customisation
  final Color? iconColor;
  final Color? textColor;
  final Color backgroundColor;
  final double? fontSize;
  final double? iconSize;
  final double? height;
  final double elevation;
  final bool visible;

  const TextButtonIconWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.textColor,
    this.backgroundColor = Colors.white,
    this.fontSize,
    this.iconSize,
    this.height,
    this.elevation = 3.0,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height ?? width * 0.10,
      child: TextButton.icon(
        onPressed: onPressed,
        label: TextWidget(
          label,
          color: textColor ?? AppColor.black,
          fontSize: fontSize ?? AppFont.font_11,
        ),
        icon: Icon(
          icon,
          color: iconColor ?? EnvironmentConfig.of(context)!.primaryTheme,
          size: iconSize ?? width * 0.05,
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          foregroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          elevation: WidgetStateProperty.all<double>(elevation),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }
}