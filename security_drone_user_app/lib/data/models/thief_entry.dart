import 'package:flutter/cupertino.dart';
import 'package:security_drone_user_app/presentation/image_banner.dart';

import 'lat_lng_point.dart';
import 'lat_lng_point.dart';

class ThiefEntry{
  Image image;
  DateTime date;
  LatLngPoint waypoint;

  ThiefEntry(this.image, this.date, this.waypoint);

  static ThiefEntry dummyFetch(){
    return ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(10.0, 10.0));
  }

  static List<ThiefEntry> dummyFetchAll(){
    return [
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(10.0, 10.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(11.0, 11.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0)),
      ThiefEntry(Image.asset('assets/images/thief.jpg',fit: BoxFit.contain), DateTime.now(), LatLngPoint(12.0, 12.0))
    ];
  }
}

