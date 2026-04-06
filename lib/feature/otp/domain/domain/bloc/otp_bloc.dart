import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/page/home_page.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  bool isLoader = false;
  String email = "";
  String password = "";
  bool isResendOtp = false;
  String timer = "";
  List<TextEditingController> controls = [];
  String _otp = "";

  String get otp => _otp;
  bool clearText = false;
  bool isForgetPasswordPage = false;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisibility = true;

  bool get isNewPasswordVisibility => _isNewPasswordVisibility;
  bool _isConfirmPasswordVisibility = true;

  bool get isConfirmPasswordVisibility => _isConfirmPasswordVisibility;

  OtpType otpPageConfig = OtpType.login;


  OtpBloc() : super(OtpInitial()) {
    on<OtpPageLoadEvent>(_pageLoad);
    on<OtpUpdateTimeEvent>(_updateTime);
    on<OtpResendEvent>(_resendOtp);
    on<OtpValueEvent>(_otpValue);
    on<NewPasswordVisibility>(_newPasswordVisibility);
    on<ConfirmPasswordVisibility>(_confirmPasswordVisibility);
    on<OtpSubmitEvent>(_submit);
  }

  _pageLoad(OtpPageLoadEvent event, emit) async {
    emit(OtpPageLoadState());
    isLoader = false;
    isResendOtp = false;
    email = "";
    password =  "";
    controls = [];
    clearText = false;
    _otp = "";
    _isConfirmPasswordVisibility = true;
    _isNewPasswordVisibility = true;
    newPasswordController.text = "";
    confirmPasswordController.text = "";
    email = event.email;
    password = event.password;

    _eventComplete(emit);
  }

  _updateTime(OtpUpdateTimeEvent event, emit) {
    if (event.count == 0) {
      timer = "";
    } else {
      if (event.count.toString().length == 1) {
        String value = "00:0${event.count}";
        timer = value;
      } else {
        String value = "00:${event.count}";
        timer = value;
      }
    }
    _eventComplete(emit);
  }

  _resendOtp(OtpResendEvent event, emit) async {
    isResendOtp = true;
    isLoader = false;
    clearText = true;
    _eventComplete(emit);
    String loginType =  BlocProvider.of<LoginBloc>(!event.context.mounted ? event.context : event.context).loginType;
    var otpRes = await LoginHelper.sendOtp(
        emailId: email,
        password: password,
        loginType: loginType,
        context: !event.context.mounted ? event.context : event.context);
    if (otpRes == null) {
      return ;
    }

    isResendOtp = false;
    isLoader = false;
    clearText = false;
    _eventComplete(emit);
  }

  _otpValue(OtpValueEvent event, emit) {
    _otp = event.otpValue.toString();
  }

  _newPasswordVisibility(NewPasswordVisibility event, emit) {
    _isNewPasswordVisibility = event.isNewPasswordVisibility;
    _eventComplete(emit);
  }

  _confirmPasswordVisibility(ConfirmPasswordVisibility event, emit) {
    _isConfirmPasswordVisibility = event.isConfirmPasswordVisibility;
    _eventComplete(emit);
  }

  _submit(OtpSubmitEvent event, emit) async {
    if (otp.toString().length != 6) {
      SnackBarErrorWidget(
              !event.context.mounted ? event.context : event.context)
          .show(message: "Please enter correct otp");
      return;
    }

    isResendOtp = false;
    isLoader = true;
    _eventComplete(emit);

    String loginType =  BlocProvider.of<LoginBloc>(!event.context.mounted ? event.context : event.context).loginType;
    String userId =  BlocProvider.of<LoginBloc>(!event.context.mounted ? event.context : event.context).userId;
    var res = await LoginHelper.getLoginOTPData(
        userId: userId,
        otp: otp,
        loginType: loginType,
        context: event.context.mounted ? event.context : event.context);
    isLoader = false;
    _eventComplete(emit);
    if (res != null) {
      LoginDataModel _loginData = LoginDataModel();
      _loginData = loginResponse(res);
      UserInfo.instanceInit()?.userData = _loginData;
      await SharedPreferencesUtils.setString(key: PreferencesName.token, value: UserInfo.instanceInit()!.userData!.tokens!.access.toString());
      await SharedPreferencesUtils.setString(key: PreferencesName.otpVerified, value: "1");
      Navigator.pushAndRemoveUntil(
          !event.context.mounted ? event.context : event.context,
          MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
    }

    isLoader = false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<OtpState> emit) {
    emit(FetchOtpDataState(
      isLoader: isLoader,
      mobileNumber: email,
      clearText: clearText,
      isResendOtp: isResendOtp,
      timer: timer,
      controls: controls,
      newPasswordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      isConfirmPasswordVisibility: isConfirmPasswordVisibility,
      isNewPasswordVisibility: isNewPasswordVisibility,
      isForgetPasswordPage: isForgetPasswordPage,
      otpPageConfig: otpPageConfig,
    ));
  }
}
