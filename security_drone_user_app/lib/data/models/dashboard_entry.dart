
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

  static DashBoardEntry dummyFetch() {
    List<SubActivity> subActivities = [
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.pursue, DateTime.parse("1999-01-12"), LatLngPoint(10,10))
    ];
    DroneActivity droneActivity = DroneActivity(subActivities);
    return DashBoardEntry(droneActivity,DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.success, 'clock trigger', '');
  }

  static List<DashBoardEntry> dummyFetchAll() {
    List<SubActivity> subActivities = [
      SubActivity(DroneActivityType.fly, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
      SubActivity(DroneActivityType.land, DateTime.parse("1999-01-12"), LatLngPoint(10,10)),
    ];
    DroneActivity droneActivity = DroneActivity(subActivities);
    return [
      DashBoardEntry(droneActivity, DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.success, "trigger", ""),
      DashBoardEntry(droneActivity, DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.success, "trigger", ""),
      DashBoardEntry(droneActivity, DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.fail, "trigger", ""),
      DashBoardEntry(droneActivity, DateTime.now(), DateTime.parse("1999-01-12"), MissionResultType.fail, "trigger", ""),
    ];
  }

  @override
  String toString() {
    var abort = "";
    if (abortReason != ""){
      abort = "Abort reason: " + abortReason.toString();
    }

    return activity.toString() + "\n"
    + "Start time: " + startTime.toString() + "\n"
    + "End time: " + endTime.toString() + "\n"
    + "Result: "+ missionResult.toString().split(".").last + "\n"
    + "Start reason: " + startReason.toString() + "\n"
    + abort;
  }

  String entryMinimalDescription(){
    return "Start time: " + startTime.toString() + "\n"
        + "End time: " + endTime.toString()  + "\n"
        + "Result: "+ missionResult.toString().split(".").last + "\n";
  }
}

enum MissionResultType {success, fail}