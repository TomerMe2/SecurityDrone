import 'dart:convert';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/communication/data_sender/mock_sender.dart' if (isMockingServer) 'package:security_drone_user_app/communication/data_sender/sender.dart';

Future<bool> sendPatrolWaypoints(List<LatLngPoint> points) async {
  var jsonStr = jsonEncode(points);
  bool isSuccess = await sendWaypoints(jsonStr);
  return isSuccess;
}

Future<bool> sendHomeWaypoint(LatLngPoint point) async {
  var jsonStr = jsonEncode(point);
  // TODO: find a way to distinguish between home and patrol points
  bool isSuccess = await sendWaypoints(jsonStr);
  return isSuccess;
}