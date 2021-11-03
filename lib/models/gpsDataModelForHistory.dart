class GpsDataModelForHistory {
  String? gpsSpeed;
  String? satellite;
  double? lat;
  double? lng;
  String? gpsTime;
  String? direction;
  String? posType;
  String? address;
  String? duration;
  String? startTime;
  String? endTime;

  GpsDataModelForHistory(
      {
        this.gpsSpeed,
        this.satellite,
        this.lat,
        this.lng,
        this.gpsTime,
        this.direction,
        this.posType
      });
}