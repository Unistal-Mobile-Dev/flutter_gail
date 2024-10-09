import 'package:flutter/material.dart';

class AppColor {
  static dynamic theme_Color = 0xFFE63746;
  static dynamic theme_LightColor = 0xFFE74957;
  static dynamic theme_NormalLightColor = 0xFFE74957;

  AppColor({required dynamic themeColor, required dynamic themeLightColor}) {
    theme_Color = themeColor;
    theme_LightColor = themeLightColor;
  }

  static get themeColor => Color(theme_Color);

  static get themeLightColor => Color(theme_LightColor);

  static get themeNormalLightColor => Color(theme_NormalLightColor);

  static get grey => Colors.grey;

  static get lightGrey => Colors.black12;

  static get black => Colors.black;

  static get appBackgroundColor => Colors.white;

  static get white => Colors.white;

  static get red => const Color(0xFFD32F2F);

  static get cardBlue => const Color(0xFF48A9F8);

  static get cardGreen => const Color(0xFF1BD084);

  static get green => const Color(0xFF43A047);

  static get orange => const Color(0xFFea8e11);

  static get cardLightGreen => const Color(0xFF8BC740);

  static get themeSecondary => const Color(0xFFFFC107);

// static get themeSecondary => const Color(0xff60af62);
}
