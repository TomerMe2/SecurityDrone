import 'dart:convert';
import 'dart:io';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/communication/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/general_api.dart';
import 'package:security_drone_user_app/data/models/dashboard_entry.dart';

class DashboardAPI {
  GeneralAPI generalAPI = GeneralAPI();

  Future<List<DashBoardEntry>> getDashboardEntries(String token) async {
    // TODO: not implemented on server side
    String request = "";
    if (isMockingServer){
      sleep(Duration(seconds: 3));
      return DashBoardEntry.dummyFetchAll();
    }
    else {
      Iterable l = json.decode(await generalAPI.get(request, token));
      List<DashBoardEntry> lst = List<DashBoardEntry>.from(l.map((e) => DashBoardEntry.fromJson(e)));
      return lst;
    }
  }


}