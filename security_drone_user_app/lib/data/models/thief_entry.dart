import 'package:flutter/cupertino.dart';
import 'lat_lng_point.dart';


class ThiefEntry{
  Image image;
  DateTime date;
  LatLngPoint waypoint;

  ThiefEntry(this.image, this.date, this.waypoint);

  static ThiefEntry dummyFetch(){
    return ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(10.0, 10.0));
  }

  static List<ThiefEntry> dummyFetchAll(){
    return [
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(10.0, 10.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(11.0, 11.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.parse("1999-01-12"), LatLngPoint(12.0, 12.0))
    ];
  }

  @override
  bool operator ==(Object other) {
    if (other is ThiefEntry){
      return this.date.compareTo(other.date) == 0 && other.waypoint == this.waypoint;
    }
    return false;
  }
 @override
  String toString() {
    return this.date.toString() + this.waypoint.toString();
  }
}

