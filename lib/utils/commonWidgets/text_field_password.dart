import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class TextFieldPasswordWidget extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final bool? isPasswordIcon;
  final TextInputType? inputType;
  final int? maxLength;
  final VoidCallback? passwordOnPressed;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final bool? isRequired;
  final bool? isBoardRemove;

  const TextFieldPasswordWidget({
    super.key,
    required this.labelText,
    this.hintText,
    this.textEditingController,
    this.obscureText,
    this.onChanged,
    this.inputType,
    this.isPasswordIcon,
    this.maxLength,
    this.passwordOnPressed,
    this.onTap,
    this.enabled,
    this.isRequired,
    this.isBoardRemove,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: enabled ?? true,
      maxLength: maxLength,
      onChanged: onChanged,
      keyboardType: inputType ?? TextInputType.text,
      controller: textEditingController,
      obscureText: obscureText ?? false,
      style: TextStyle(
        fontSize: AppFont.font_14,
        color: AppColor.themeSecondary,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: isBoardRemove == true ? 0 : 8,
              vertical: isBoardRemove != true ? 8 : 0),
          label: Text.rich(TextSpan(children: [
            TextSpan(text: labelText),
            TextSpan(
                text: isRequired != null && isRequired == true ? ' *' : "",
                style: const TextStyle(color: Colors.red)),
          ])),
          labelStyle: TextStyle(
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w700,
              color: AppColor.themeColor),
          fillColor: AppColor.themeColor,
          enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColor.themeColor,
            ),
          ),
          border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:  BorderSide(
                    width: 1.0,
                    color: AppColor.themeColor,
                  ),
                ),
          // filled: true,
          suffixIcon: isPasswordIcon != null
              ? IconButton(
                  onPressed: passwordOnPressed,
                  icon: Icon(
                    obscureText == true
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColor.themeSecondary,
                  ),
                )
              : null),
    );
  }
}
