part of '../bloc/login_bloc.dart';


@immutable
abstract class LoginEvent {}


class PressedLoginButtonEvent extends LoginEvent {
  final String username;
  final String password;

  PressedLoginButtonEvent(this.username, this.password);
}

class DisplayLoginPage extends LoginEvent {}



