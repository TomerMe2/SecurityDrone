import 'package:security_drone_user_app/logic/bloc/login_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {

  blocTest('Check login - fail',
      build: () => LoginBloc(),
      act: (bloc) => bloc.add(PressedLoginButtonEvent('a','a')),
      expect: [LoginDenied(), LoginUninitialized()]
  );

  blocTest('Check login - success',
      build: () => LoginBloc(),
      act: (bloc) => bloc.add(PressedLoginButtonEvent('Admin', 'Admin')),
      expect: [LoginSuccessful()]
  );
}