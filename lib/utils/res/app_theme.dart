// import 'package:flutter/material.dart';
// import 'package:flutter_gail/ExportFile/app_export_file.dart';
//
// ThemeData appTheme() {
//   return ThemeData(
//     colorScheme: ColorScheme.light(
//       primary: AppColor.themeColor,
//       onPrimary: AppColor.white,
//       onSurface: Colors.black,
//     ),
//     checkboxTheme: CheckboxThemeData(
//       fillColor: WidgetStateColor.resolveWith(
//         (states) {
//           if (states.contains(WidgetState.selected)) {
//             return AppColor.themeColor; // the color when checkbox is selected;
//           }
//           return Colors.white; //the color when checkbox is unselected;
//         },
//       ),
//       checkColor: WidgetStateProperty.all<Color>(AppColor.white),
//       side: const BorderSide(color: Color(0xff585858)),
//     ),
//     textButtonTheme: TextButtonThemeData(
//         style: ButtonStyle(
//             foregroundColor: WidgetStateProperty.all<Color>(AppColor.black))),
//     primaryColor: AppColor.themeColor,
//     appBarTheme: AppBarTheme(
//         iconTheme: IconThemeData(color: AppColor.white,),
//         color: AppColor.themeColor,
//     ),
//     datePickerTheme: DatePickerThemeData(
//       headerBackgroundColor: AppColor.themeColor,
//       headerForegroundColor: Colors.white,
//       backgroundColor: Colors.white,
//       confirmButtonStyle: ButtonStyle(
//           foregroundColor:
//               WidgetStateProperty.all<Color>(AppColor.themeColor)),
//       cancelButtonStyle: ButtonStyle(
//           foregroundColor: WidgetStateProperty.all<Color>(AppColor.grey)),
//       surfaceTintColor: Colors.white,
//       dayStyle: TextStyle(color: AppColor.themeColor),
//       weekdayStyle:
//           TextStyle(color: AppColor.themeColor, fontWeight: FontWeight.w700),
//     ),
//     scaffoldBackgroundColor: Colors.white,
//     cardColor: Colors.white,
//     cardTheme:  CardThemeData(color: Colors.white, surfaceTintColor: Colors.white),
//     dialogBackgroundColor: AppColor.white,
//     dialogTheme: DialogThemeData(
//       backgroundColor: AppColor.white,
//       surfaceTintColor: AppColor.white,
//     ),
//     bottomAppBarTheme: const BottomAppBarThemeData(
//         color: Colors.white, surfaceTintColor: Colors.white),
//     navigationBarTheme: const NavigationBarThemeData(
//         backgroundColor: Colors.white, surfaceTintColor: Colors.white),
//     primarySwatch: Colors.pink,
//     fontFamily: AppFont.merriweather,
//   );
// }
//
// Widget appBackGround(
//     {required Widget child,
//     required BuildContext context,
//     bool? isGradientChange,
//     bool? isRemoveBackground}) {
//     return Container(
//   );
// }
//
//


import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    /// 🔹 Colors
    primaryColor: const Color(0xFF1FA34A),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1FA34A),
      onPrimary: Colors.white,
      secondary: Color(0xFF143E7A),
      onSecondary: Colors.white,
      error: Color(0xFFE53935),
      onError: Colors.white,
      background: Color(0xFFF5F7FA),
      onBackground: Color(0xFF1A1A1A),
      surface: Colors.white,
      onSurface: Color(0xFF1A1A1A),
    ),

    /// 🔹 AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1FA34A),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    /// 🔹 Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),

    /// 🔹 Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1FA34A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    /// 🔹 Text Theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF555555),
      ),
    ),
  );
}