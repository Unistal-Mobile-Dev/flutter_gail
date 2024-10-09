import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {}

class LoginPageLoadingEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginSetEmailEvent extends LoginEvent {
  final String emailId;

  LoginSetEmailEvent({required this.emailId});

  @override
  List<Object?> get props => [emailId];
}

class LoginSetPasswordEvent extends LoginEvent {
  final String password;

  LoginSetPasswordEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

class LoginPasswordHideShowEvent extends LoginEvent {
  final bool isPassword;

  LoginPasswordHideShowEvent({required this.isPassword});

  @override
  List<Object?> get props => [isPassword];
}

class LoginSubmitDataEvent extends LoginEvent {
  final BuildContext context;
  final bool isLoginPage;

  LoginSubmitDataEvent({required this.context, required this.isLoginPage});

  @override
  List<Object?> get props => [context, isLoginPage];
}
