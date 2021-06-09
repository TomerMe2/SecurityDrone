part of '../bloc/login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object> get props => [];
}


class LoginSuccessful extends LoginState {}

class LoginDenied extends LoginState {}

class LoginUninitialized extends LoginState {}

