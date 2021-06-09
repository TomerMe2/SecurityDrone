
import 'package:security_drone_user_app/data/models/drone_activity.dart';
import 'package:security_drone_user_app/data/models/lat_lng_point.dart';
import 'package:security_drone_user_app/data/models/sub_activity.dart';

class DashBoardEntry {
  DroneActivity activity;
  DateTime startTime;
  DateTime endTime;
  MissionResultType missionResult;
  String startReason;
  String abortReason;

  DashBoardEntry(this.activity, this.startTime, this.endTime, this.missionResult, this.startReason, this.abortReason);

  factory DashBoardEntry.fromJson(Map<String, dynamic> json) {
    return DashBoardEntry(
        DroneActivity.fromJson(json['DroneActivity']),
        json['startTime'],
        json['endTime'],
        json['missionResultType'],
        json['startReason'],
        json['abortReason']);
  }

  static DashBoardEntry dummyFetch() {
    List<SubActivity> subActivities = [
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10))
    ];
    DroneActivity droneActivity = DroneActivity(subActivities);
    return DashBoardEntry(droneActivity,DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.success, 'clock trigger', '');
  }

  static List<DashBoardEntry> dummyFetchAll() {
    List<SubActivity> subActivities = [
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
    ];
    DroneActivity droneActivity = DroneActivity(subActivities);
    return [
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.success, "trigger", ""),
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.success, "trigger", ""),
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.fail, "trigger", "user request"),
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.fail, "trigger", "low battery"),
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.fail, "trigger", "high winds"),
      DashBoardEntry(droneActivity, DateTime.parse("1999-01-12"), DateTime.parse("1999-01-12"), MissionResultType.ongoing, "trigger", ""),
    ];
  }

  @override
  String toString() {
    var abort = "";
    if (abortReason != "") {
      abort = "Abort reason: " + abortReason.toString();
    }

    return activity.toString() + "\n"
    + "Start time: " + startTime.toString() + "\n"
    + "End time: " + endTime.toString() + "\n"
    + "Result: "+ missionResult.toString().split(".").last + "\n"
    + "Start reason: " + startReason.toString() + "\n"
    + abort;
  }

  @override
  bool operator ==(Object other) {
    if (other is DashBoardEntry) {
      return this.startTime.compareTo(other.startTime) == 0
        && this.endTime.compareTo(other.endTime) == 0
        && this.abortReason.compareTo(other.abortReason) == 0
        && this.startReason.compareTo(other.startReason) == 0
        && this.missionResult == other.missionResult
        && this.activity == other.activity;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

enum MissionResultType {success, fail, ongoing}