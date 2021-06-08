import 'dart:convert';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/communication/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/general_api.dart';

class MissionAPI {
  GeneralAPI generalAPI = GeneralAPI();

  Future<bool> sendMission(String mission, String token) async {
    String request = "request_" + mission + "_mission";
    return jsonDecode(await generalAPI.post(request, '{}', token));
  }
}