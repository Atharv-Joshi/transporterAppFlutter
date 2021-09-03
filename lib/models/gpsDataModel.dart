import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GpsDataModel {
  String? speed;
  double? lat;
  double? lng;
  String? imei;
  String? deviceName;
  String? powerValue;
  String? direction;

  GpsDataModel(
      {this.speed,
      this.imei,
      this.lat,
      this.deviceName,
      this.lng,
      this.powerValue,
      this.direction});
}
