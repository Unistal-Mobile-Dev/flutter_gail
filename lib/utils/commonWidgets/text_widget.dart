import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final int? maxLines;

  const TextWidget(this.text,
      {super.key,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.textDecoration,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? AppFont.font_14,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}
