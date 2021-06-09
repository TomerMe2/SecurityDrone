import 'dart:convert';
import 'package:security_drone_user_app/communication/general_api.dart';
import 'package:security_drone_user_app/config.dart';
import 'package:crypto/crypto.dart';


class LoginAPI {
  GeneralAPI generalAPI = GeneralAPI();

  Future<String> login(String username, String password) async {

    if (isMockingServer) {
      if (dummyAuthenticate(username, password)) {
        return "ok";
      }
      else {
        return "";
      }

    }

    var passBytes = utf8.encode(password);
    var digest = sha256.convert(passBytes);
    
    String request = "login";
    String body = jsonEncode({'username':username, 'password':digest});
    
    String token = jsonDecode(await generalAPI.post(request, body, ""));
    return token;
  }

  bool dummyAuthenticate(String username, String password) {
    return username == 'Admin' && password == 'Admin';
  }


}