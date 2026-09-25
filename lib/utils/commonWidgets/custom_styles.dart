import 'package:flutter/material.dart';
import 'package:flutter_gail/utils/res/app_color.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class CustomStyleText {
  static TextStyle appBarStyle = TextStyle(
    color: Colors.blue.shade900,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );

  static TextStyle navBarStyle = const TextStyle(
    fontSize: 13.0,
    fontFamily: 'Montserrat',
  );

  static TextStyle checkOutStyle = const TextStyle(
    fontSize: 18,
    color: Colors.pink,
  );

  static TextStyle logOutStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );

  static TextStyle logDialogStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Montserrat',
  );

  static TextStyle logInStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );
  static TextStyle changeCompanyStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );
  static TextStyle changePasswordStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );
  static TextStyle yesNoStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Montserrat',
  );

  static TextStyle loginStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle checkInStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle checkInOutDateInStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
  );

  static TextStyle employeeDetailsStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static TextStyle presentStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static TextStyle userPresentStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle leaveStatusStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static TextStyle leaveReasonStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
  );

  static TextStyle leaveTypeStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static TextStyle showSnackBarStyle = const TextStyle(
    color: Colors.pink,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
  );
  static TextStyle statusStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle updateStatusStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle remakeStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontFamily: 'Montserrat',
  );

  static TextStyle haajriButtonStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle hrmMitraStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );
  static TextStyle logoutTitleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );
  static TextStyle logoutStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Montserrat',
  );

  static TextStyle dataTableStyle = const TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );

  static TextStyle viewStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
  static TextStyle viewDetailsStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    fontFamily: 'Montserrat',
  );
  static TextStyle submitStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );
}

Widget styleAppBar() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFF2D3194), Color(0xFF02A7E7)],
      ),
    ),
  );
}

BoxDecoration gradientDecoration({required BuildContext context}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        EnvironmentConfig.of(context)!.primaryTheme,
        EnvironmentConfig.of(context)!.primaryTheme,
      ],
    ),
  );
}

BoxDecoration gradientGrayColorDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(24),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFEEEDED), Color(0xFF8D8D8D)],
  ),
);

LinearGradient gradientColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[Color(0xFF2D3194), Color(0xFF02A7E7)],
);

BoxDecoration buttonFlat({required BuildContext context}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: EnvironmentConfig.of(context)!.primaryTheme,
      width: 1,
    ),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColor.white],
    ),
  );
}
