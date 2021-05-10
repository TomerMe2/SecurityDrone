import 'package:security_drone_user_app/data/models/sub_activity.dart';

class DroneActivity{
  List<SubActivity> activities;

  DroneActivity(this.activities);

  @override
  String toString() {
    // TODO: implement toString; what is interesting to present to the user?
    var str = "";

    for(int i=0; i < activities.length; i++){
      str += "Sub-Activity-${i.toString()} : \n" + activities[i].toString() + "\n";
    }
    return str;
  }
}

