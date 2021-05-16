import 'package:security_drone_user_app/data/models/sub_activity.dart';

class DroneActivity{
  List<SubActivity> activities;

  DroneActivity(this.activities);

  @override
  String toString() {
    var str = "";

    for(int i=0; i < activities.length; i++) {
      str += "Sub-Activity-${i.toString()} : \n" + activities[i].toString() + "\n";
    }
    return str;
  }

  @override
  bool operator ==(Object other) {
    if (other is DroneActivity) {
      if (other.activities.length != this.activities.length) {
        return false;
      }

      for (int i = 0; i < this.activities.length; i++) {
        if(this.activities[i] != (other.activities[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}

