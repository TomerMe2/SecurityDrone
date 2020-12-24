
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
}