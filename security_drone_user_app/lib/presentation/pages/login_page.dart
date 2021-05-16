import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_drone_user_app/logic/bloc/login_bloc.dart';
import 'package:security_drone_user_app/presentation/pages/central_page.dart';

import '../../style.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{
  LoginBloc _bloc = LoginBloc();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usernameField = TextField(
      obscureText: false,
      style: Body1TextStyle,
      controller: _username,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        )
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      style: Body1TextStyle,
      controller: _password,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _bloc.add(PressedLoginButtonEvent(_username.text, _password.text)),
        child: Text("Login",
            textAlign: TextAlign.center,
            style: Body1TextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final loginPage = Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    'assets/images/icon.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                usernameField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return BlocConsumer <LoginBloc, LoginState>(
        cubit: _bloc,
        builder: (context, state) {
          if (state is LoginSuccessful) {
            return CentralPage();
          }
          return loginPage;
        },
        listenWhen: (prev, curr) {
          if (curr is LoginDenied){
            return true;
          }
          return false;
        },
        listener: (prev, curr) {
          return showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Login failed"),
                  actions: [
                    TextButton(onPressed: () => {Navigator.of(context).pop()}, child: Text("Ok")),
                  ],
                );
              }
          );
        }
    );
  }

}