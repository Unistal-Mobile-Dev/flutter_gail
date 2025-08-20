part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();
}

class OtpPageLoadEvent extends OtpEvent {
  final BuildContext context;
  final String email;
  final String password;

  const OtpPageLoadEvent({required this.context,
  required this.email,
  required this.password,
  });
  @override
  List<Object?> get props => [context, email, password];
}

class OtpResendEvent extends OtpEvent {
  final BuildContext context;
  const OtpResendEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class OtpUpdateTimeEvent extends OtpEvent {
  final int count;
  const OtpUpdateTimeEvent({required this.count});
  @override
  List<Object?> get props => [count];
}

class OtpValueEvent extends OtpEvent {
  final String otpValue;
  const OtpValueEvent({required this.otpValue});
  @override
  List<Object?> get props => [otpValue];
}

class NewPasswordVisibility extends OtpEvent {
  final bool isNewPasswordVisibility;
  const NewPasswordVisibility({required this.isNewPasswordVisibility});
  @override
  List<Object?> get props => [isNewPasswordVisibility];
}

class ConfirmPasswordVisibility extends OtpEvent {
  final bool isConfirmPasswordVisibility;
  const ConfirmPasswordVisibility({required this.isConfirmPasswordVisibility});

  @override
  List<Object?> get props => [isConfirmPasswordVisibility];
}

class OtpSubmitEvent extends OtpEvent {
  final BuildContext context;
  const OtpSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
