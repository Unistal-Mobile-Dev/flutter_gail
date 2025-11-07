import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
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

  pageOpen() async {
    await AppConfig.instanceInit()!.getPackageInfo();
    String token =
        await SharedPreferencesUtils.getString(key: PreferencesName.token);
    if(kReleaseMode){
      if(await LoginHelper.isDeveloperModeEnabled() == true){
        if(await _onWillPop() == true){
          await LoginHelper.openDevSettings();
        } else {
          Navigator.of(!context.mounted ? context : context).pop();
        }
        return;
      }
    }

    if (token.isEmpty) {
      Navigator.pushAndRemoveUntil(
          !context.mounted ? context : context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (route) => false);
    } else {
      // Navigator.pushAndRemoveUntil(
      //     !context.mounted ? context : context,
      //     MaterialPageRoute(builder: (_) => const LoginScreenPage()),
      //         (route) => false);
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context)
          .add(LoginCheckEvent(context: !context.mounted ? context : context));
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
          AppConfig.instanceInit()!.client == Client.oil
              ? AppIcon.oilLogo
              : AppIcon.oilLogo,
          height: MediaQuery.of(context).size.width * 0.40,
          width: MediaQuery.of(context).size.width * 0.40,
        ),
      ),
    );
  }
}
