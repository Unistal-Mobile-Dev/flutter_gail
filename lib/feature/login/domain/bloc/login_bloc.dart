import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/page/home_page.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_gail/utils/commonClass/connectivity_helper.dart';
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

  bool isLoader = false;
  bool isPassword = true;
  bool appLogoLoader = false;

  LoginDataModel loginData = LoginDataModel();

  TextEditingController userNameTextFiledController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();

  String appVersion = "";
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
    isPassword = event.isPassword;
    _eventCompleted(emit);
  }

  _pageLoad(LoginPageLoadingEvent event, emit) async {
    email = "";
    password = "";
    isPassword = true;
    isLoader = false;
    appLogoLoader = true;
    loginType = "1";
    userId = "";
    userNameTextFiledController.text = "";
    passwordTextFieldController.text = "";
    await AppConfig.instanceInit()!.getPackageInfo();
    appVersion = AppConfig.instanceInit()!.appVersion!;
    appLogoLoader = false;
    _eventCompleted(emit);
  }

  _submitLoginData(LoginSubmitDataEvent event, emit) async {
    if (await ConnectivityHelper.allConnectivityCheck(context: event.context) ==
        false) {
      return;
    }
    userId = "";
    loginData = LoginDataModel();
    var textFieldValidationCheck = await LoginHelper.textFieldValidation(
      emilId: email,
      password: password,
      loginType: loginType,
      context: event.context.mounted ? event.context : event.context,
    );
    if (textFieldValidationCheck == true) {
      var res = await LoginHelper.getLoginData(
        emilId: email,
        password: password,
        loginType: loginType,
        context: event.context,
      );
      if (res != null) {
        isLoader = false;
        _eventCompleted(emit);
        loginData = loginResponse(res);
        await AppConfig.instanceInit()?.setUserInfo(newData: loginData);

        String userJson = jsonEncode(res);
        SharedPreferencesUtils.setString(key: PreferencesName.userInfo, value : userJson);
       await SharedPreferencesUtils.setString(key: PreferencesName.token, value:loginData.tokens!.access.toString());
        Navigator.pushAndRemoveUntil(
          !event.context.mounted ? event.context : event.context,
           MaterialPageRoute(builder: (_) => const HomePage()),
         // MaterialPageRoute(builder: (_) => const HpOilDashboardPage()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          !event.context.mounted ? event.context : event.context,
          MaterialPageRoute(builder: (_) => const LoginScreenPage()),
          (route) => false,
        );
      }
      isLoader = false;
      _eventCompleted(emit);
    }
  }

  _loginCheck(LoginCheckEvent event, emit) async {
    var res =  await LoginHelper.checkLogin(context: event.context);
    if(res != null){

      loginData = loginResponse(res);
      await SharedPreferencesUtils.setString(key: PreferencesName.token, value:loginData.tokens!.access.toString());
      Navigator.pushAndRemoveUntil(
        !event.context.mounted ? event.context : event.context,
          MaterialPageRoute(builder: (_) => const HomePage()),
      //  MaterialPageRoute(builder: (_) => const HpOilDashboardPage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        !event.context.mounted ? event.context : event.context,
        MaterialPageRoute(builder: (_) => const LoginScreenPage()),
        (route) => false,
      );
    }
  }

  _eventCompleted(Emitter<LoginState> emit) {
    emit(
      FetchLoginStateData(
        isLoader: isLoader,
        isPassword: isPassword,
        appLogoLoader: appLogoLoader,
        userNameTextFiledController: userNameTextFiledController,
        passwordTextFieldController: passwordTextFieldController,
        appVersion: appVersion,
        loginType: loginType,
      ),
    );
  }
}
