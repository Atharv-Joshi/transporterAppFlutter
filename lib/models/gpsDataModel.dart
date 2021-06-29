
class GpsDataModel {
  String? speed;
  double? lat;
  double? lng;
  String? imei;
  String? deviceName;
  String? powerValue;

  GpsDataModel(
      {this.speed,
        this.imei,
        this.lat,
        this.deviceName,
        this.lng,
        this.powerValue});
}