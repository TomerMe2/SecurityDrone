import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/data/data_api/login_api.dart';

part '../event/login_event.dart';
part '../state/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginAPI api = LoginAPI();

  LoginBloc() : super(LoginUninitialized());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if (event is PressedLoginButtonEvent) {
      yield LoginUninitialized();
      String token = await api.login(event.username, event.password);
      if (token != "") {
        yield LoginSuccessful();
        yield LoginUninitialized();
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


}