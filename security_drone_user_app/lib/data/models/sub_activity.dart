import 'lat_lng_point.dart';

class SubActivity{
  DroneActivityType type;
  DateTime date;
  LatLngPoint location;

  SubActivity(this.type, this.date, this.location);

  @override
  String toString() {
    return "Activity: ${type.toString().split('.').last} \nDate: ${date.toString()} \n${location.toString()} ";
  }

  @override
  bool operator ==(Object other) {
    if (other is SubActivity) {
      return this.type == other.type
          && this.date.compareTo(other.date) == 0
          && this.location == other.location;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}

enum DroneActivityType{fly, land, take_pic, pursue}


