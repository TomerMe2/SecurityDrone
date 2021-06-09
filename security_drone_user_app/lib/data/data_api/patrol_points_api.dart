import 'dart:convert';
import 'package:security_drone_user_app/config.dart';
import 'package:security_drone_user_app/communication/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/general_api.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';

class PatrolPointsAPI {
  GeneralAPI generalAPI = GeneralAPI();

  Future<bool> sendPatrolPoints(List<LatLngPoint> points, String token) async {
    String request = "update_waypoints";
    String body = jsonEncode(points);
    return jsonDecode(await generalAPI.post(request, body, token));
  }

  Future <List<LatLngPoint>> getPatrolPoints(String token) async {
    String request = "get_patrol_waypoints";

    if (isMockingServer){
      return LatLngPoint.dummyFetchAll();
    }
    else {
      Iterable l = json.decode(await generalAPI.get(request, token));
      List<LatLngPoint> lst = List<LatLngPoint>.from(l.map((e) => LatLngPoint.fromJson(e)));
      return lst;
    }
  }
}