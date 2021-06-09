import 'dart:convert';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/communication/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/general_api.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';

class HomePointAPI {
  GeneralAPI generalAPI = GeneralAPI();
  
  Future<bool> sendHomePoint(LatLngPoint point, String token) async {
    String request = "update_home_waypoint";
    String body = jsonEncode(point.toJson());
    return jsonDecode(await generalAPI.post(request, body, token));
  }

  Future<LatLngPoint> getHomePoint(String token) async {
    String request = "get_home_waypoint";

    if (isMockingServer){
      return LatLngPoint.dummyFetch();
    }
    else {
      return LatLngPoint.fromJson(jsonDecode(await generalAPI.get(request, token)));
    }
  }
}