import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/page/home_page.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_gail/feature/otp/presentation/page/otp_page.dart';
import 'package:flutter_gail/utils/commonClass/connectivity_helper.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginStateInit()) {
    on<LoginPageLoadingEvent>(_pageLoad);
    on<SelectLoginTypeEvent>(_selectLoginType);
    on<LoginSetEmailEvent>(_setEmailId);
    on<LoginSetPasswordEvent>(_setPassword);
    on<LoginPasswordHideShowEvent>(_passwordHideShow);
    on<LoginSubmitDataEvent>(_submitLoginData);
    on<LoginCheckEvent>(_loginCheck);
  }

  String email = "";
  String password = "";

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  bool _isPassword = true;

  bool get isPassword => _isPassword;

  bool _appLogoLoader = false;

  bool get appLogoLoader => _appLogoLoader;

  String _appLogo = "";

  String get appLogo => _appLogo;

  LoginDataModel _loginData = LoginDataModel();

  LoginDataModel get loginData => _loginData;

  TextEditingController userNameTextFiledController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();

  String _appVersion = "";

  String get appVersion => _appVersion;

  String loginType = "1";
  String userId = "";

  _selectLoginType(SelectLoginTypeEvent event, emit) {
    loginType = event.loginType;
    _eventCompleted(emit);
  }

  _setEmailId(LoginSetEmailEvent event, emit) {
    email = event.emailId.replaceAll("", "");
  }

  _setPassword(LoginSetPasswordEvent event, emit) {
    password = event.password.replaceAll(" ", "");
  }

  _passwordHideShow(LoginPasswordHideShowEvent event, emit) {
    _isPassword = event.isPassword;
    _eventCompleted(emit);
  }

  _pageLoad(LoginPageLoadingEvent event, emit) async {
    email = "";
    password = "";
    _isPassword = true;
    _isLoader = false;
    _appLogoLoader = true;
    loginType = "1";
    userId = "";
    _appLogo =
        "https://unistal.hrmmitra.in/uploads/logo/signin/signin_logo_1569825597.png";
    userNameTextFiledController.text = "";
    passwordTextFieldController.text = "";

    await AppConfig.instanceInit()!.getPackageInfo();

    _appVersion = AppConfig.instanceInit()!.appVersion!;

    _eventCompleted(emit);
    _appLogoLoader = false;

   // await DashboardHelper.checkAppVersion(!event.context.mounted ? event.context : event.context);

    _eventCompleted(emit);
  }

  _submitLoginData(LoginSubmitDataEvent event, emit) async {
    if (await ConnectivityHelper.allConnectivityCheck(context: event.context) ==
        false) {
      return;
    }
    userId = "";
    _loginData = LoginDataModel();
    var textFieldValidationCheck = await LoginHelper.textFieldValidation(
        emilId: email,
        password: password,
        loginType: loginType,
        context: event.context.mounted ? event.context : event.context);
    if (textFieldValidationCheck == true) {
      _isLoader = true;
      _eventCompleted(emit);

        var otpRes = await LoginHelper.sendOtp(
            emailId: email,
            password: password,
            loginType: loginType,
            context: !event.context.mounted ? event.context : event.context);
        if (otpRes == null) {
          _isLoader = false;
          _eventCompleted(emit);
            return ;
        }
      _isLoader = false;
      _eventCompleted(emit);
        userId =  otpRes;
        Navigator.push(
            !event.context.mounted ? event.context : event.context,
            MaterialPageRoute(
                builder: (_) => OtpPage(
                  emailId: email,
                  password: password,
                )
            )
        );

    }
  }

  _loginCheck(LoginCheckEvent event, emit) async {
    var res =  await LoginHelper.checkLogin(context: event.context);
    if(res != null){
      LoginDataModel _loginData = LoginDataModel();
      _loginData = loginResponse(res);
      UserInfo.instanceInit()?.userData = _loginData;
      await SharedPreferencesUtils.setString(key: PreferencesName.token, value: UserInfo.instanceInit()!.userData!.tokens!.access.toString());
      Navigator.pushAndRemoveUntil(
          !event.context.mounted ? event.context : event.context,
          MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
    }
    else
    {
      Navigator.pushAndRemoveUntil(
          !event.context.mounted ? event.context : event.context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
              (route) => false);
    }

  }

  _eventCompleted(Emitter<LoginState> emit) {
    emit(FetchLoginStateData(
      isLoader: isLoader,
      isPassword: isPassword,
      appLogoLoader: appLogoLoader,
      appLogo: appLogo,
      userNameTextFiledController: userNameTextFiledController,
      passwordTextFieldController: passwordTextFieldController,
      appVersion: appVersion,
      loginType: loginType,
    ));
  }
}
