import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';

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
    String userName =
        await SharedPreferencesUtils.getString(key: PreferencesName.userName);
    if (userName.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
          !context.mounted ? context : context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (route) => false);
    } else {
      String password =
          await SharedPreferencesUtils.getString(key: PreferencesName.password);
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context)
          .add(LoginSetPasswordEvent(password: password));
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context)
          .add(LoginSetEmailEvent(emailId: userName));
      BlocProvider.of<LoginBloc>(!context.mounted ? context : context).add(
          LoginSubmitDataEvent(
              context: !context.mounted ? context : context,
              isLoginPage: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body:Align(
        alignment: Alignment.center,
        child:  Image.asset(
          AppConfig.instanceInit()!.client == Client.gail
              ? AppIcon.gailLogo
              : AppIcon.gailLogo,
          height: MediaQuery.of(context).size.width * 0.40,
          width: MediaQuery.of(context).size.width * 0.40,
        ),
      ),
    );
  }
}
