import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GpsDataModel {
  double? speed ;
  double? latitude;
  double? longitude;
  double? endLat;
  double? endLon;
  int? deviceId;
  bool? ignition;
  double? course;
  String? deviceTime;
  String? serverTime;
  String? fixTime;
  double? distance;
  String? id;
  String? address;
  int? duration;
  String? startTime;
  String? endTime;
  bool? motion;


  GpsDataModel(
      {this.speed,
        this.id,
        this.address,
        this.deviceId,
        this.latitude,
        this.longitude,
        this.endLat,
        this.endLon,
        this.course,
        this.deviceTime,
        this.serverTime,
        this.fixTime,
        this.distance,
        this.duration,
        this.startTime,
        this.endTime,
        this.motion,
        this.ignition,
      });
}
