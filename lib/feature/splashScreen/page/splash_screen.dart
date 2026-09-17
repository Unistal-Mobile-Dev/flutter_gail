import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/page/home_page.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_gail/utils/commonWidgets/message_box_two_button_pop.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    pageOpen();
    super.initState();
  }

  Future<void> pageOpen() async {
    try {
    final appConfig = AppConfig.instanceInit();
    await appConfig?.getPackageInfo();

    /// ✅ Step 1: Restore user session (independent of build mode)
    String? userJson = await SharedPreferencesUtils.getString(
      key: PreferencesName.userInfo ?? "",
    );

    if (userJson != "" && userJson.isNotEmpty) {
      try {
        final userMap = jsonDecode(userJson);
        final loginModel = LoginDataModel.fromJson(userMap);

        print("userMap --> $userMap");

        await appConfig?.setUserInfo(newData: loginModel);
      } catch (e) {
        print("User parse error: $e");
      }
    }

    /// ✅ Step 2: Check mounted BEFORE any navigation
    if (!context.mounted) return;

    /// ✅ Step 3: Developer mode check (ONLY ONCE)
    if (kReleaseMode) {
      final isDevMode = await LoginHelper.isDeveloperModeEnabled();

      if (isDevMode) {
        final exit = await _onWillPop();

        if (exit) {
          await LoginHelper.openDevSettings();
        } else {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
        return;
      }
    }

    /// ✅ Step 4: Token check
    String token = AppConfig.instanceInit()?.userData.tokens?.access.toString() ?? "";

    if (!context.mounted) return;

    if (token.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreenPage()),
            (_) => false,
      );
    } else {
      /// ✅ Step 5: Trigger BLoC login check
      context.read<LoginBloc>().add(
        LoginCheckEvent(context: context),
      );
    }
    } catch (e) {
      print("SplashScreen error: $e");
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (_) => false,
        );
      }
    }
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "We found developer option enabled",
            okButtonText: "Open Setting",
            onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body:Align(
        alignment: Alignment.center,
        child:  Image.asset(
          AppConfig.instanceInit()!.client == Client.hpoil
              ? AppIcon.hpOILLogo
              : AppIcon.hpOILLogo,
          height: MediaQuery.of(context).size.width * 0.40,
          width: MediaQuery.of(context).size.width * 0.40,
        ),
      ),
    );
  }
}
