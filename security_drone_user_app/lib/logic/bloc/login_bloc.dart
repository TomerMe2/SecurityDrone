import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../event/login_event.dart';
part '../state/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {


  LoginBloc() : super(LoginUninitialized());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if (event is PressedLoginButtonEvent) {
      //TODO; add proper authentication
      if (dummyAuthenticate(event.username, event.password)) {
        yield LoginSuccessful();
      }
      else {
        yield LoginDenied();
        yield LoginUninitialized();
      }
    }
    else {
      throw Exception("Event not found $event");
    }
  }

  bool dummyAuthenticate(String username, String password) {
    return username.length > 3 && password.length > 3;
  }
}