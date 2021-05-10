import 'lat_lng_point.dart';

class SubActivity{
  DroneActivityType type;
  DateTime date;
  LatLngPoint location;

  SubActivity(this.type, this.date, this.location);

  @override
  String toString() {
    // TODO: implement toString
    return "Activity: ${type.toString().split('.').last} \nDate: ${date.toString()} \n${location.toString()} ";
  }

}

enum DroneActivityType{fly, land, takepic, pursue}
  // TODO: what types of sub activities do we support

