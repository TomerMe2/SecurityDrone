
import 'package:flutter/cupertino.dart';
import 'dart:math';



@immutable
class LatLngPoint {
  final double lat;
  final double lng;


  LatLngPoint(this.lat, this.lng);

  factory LatLngPoint.fromJson(Map<String, dynamic> json) {
    return LatLngPoint(
        json['latitude'],
        json['longitude']);
  }

  static LatLngPoint dummyFetch(){
    return LatLngPoint(10.0, 10.0);
  }

  static List<LatLngPoint> dummyFetchAll(){
    List<LatLngPoint> lst = [];
    for (int i=0; i<10; i++) {
      lst.add(LatLngPoint(10.0 + i, 10.0 + i));
    }
    return lst;
  }

  l2Distance(LatLngPoint other) {
    double latDiff = pow(lat - other.lat, 2);
    double lngDiff = pow(lng - other.lng, 2);

    return sqrt(latDiff + lngDiff);
  }

  Map<String, dynamic> toJson() =>
      {
        'latitude': lat,
        'longitude': lng,
      };

  @override
  String toString() {
    return "latitude: ${lat.toString()} longitude: ${lng.toString()}";
  }
  @override
  bool operator == (Object other) {
    const double EPSILON = 0.001;

    if (other is LatLngPoint){
      var lat = other.lat - this.lat;
      var lng = other.lng - this.lng;
      return lat.abs() < EPSILON && lng.abs() < EPSILON;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;

}