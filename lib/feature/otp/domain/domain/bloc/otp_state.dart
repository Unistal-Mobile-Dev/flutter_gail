part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();
}

final class OtpInitial extends OtpState {
  @override
  List<Object> get props => [];
}

final class OtpPageLoadState extends OtpInitial {
  @override
  List<Object> get props => [];
}

final class FetchOtpDataState extends OtpInitial {
  final bool isLoader;
  final bool clearText;
  final bool isResendOtp;
  final String mobileNumber;
  final String timer;
  final List<TextEditingController?> controls;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isNewPasswordVisibility;
  final bool isConfirmPasswordVisibility;
  final bool isForgetPasswordPage;
  final OtpType otpPageConfig;

  FetchOtpDataState({
    required this.isLoader,
    required this.clearText,
    required this.isResendOtp,
    required this.timer,
    required this.controls,
    required this.mobileNumber,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isConfirmPasswordVisibility,
    required this.isNewPasswordVisibility,
    required this.isForgetPasswordPage,
    required this.otpPageConfig,
  });


  @override
  List<Object> get props => [
    isLoader,
    clearText,
    isResendOtp,
    timer,
    controls,
    mobileNumber,
    newPasswordController,
    confirmPasswordController,
    isNewPasswordVisibility,
    isConfirmPasswordVisibility,
    isForgetPasswordPage,
    otpPageConfig,
  ];
}