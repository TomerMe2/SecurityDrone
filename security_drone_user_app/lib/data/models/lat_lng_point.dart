
import 'package:flutter/cupertino.dart';
import 'dart:math';



@immutable
class LatLngPoint {
  final double lat;
  final double lng;


  LatLngPoint(this.lat, this.lng);

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
  // TODO: implement hashCode
  int get hashCode => super.hashCode;


}