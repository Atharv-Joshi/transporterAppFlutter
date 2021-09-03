import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';

class MapUtil {
  String gpsApiUrl = FlutterConfig.get("gpsApiUrl");

  getLocationByImei({String? imei}) async {
    print("getLocationByImei got called with imei : $imei");
    try {
      print("$gpsApiUrl/$imei");
      http.Response response = await http.get(Uri.parse("$gpsApiUrl/$imei"));
      print(response.statusCode);
      print(response.body);
      var jsonData = await jsonDecode(response.body);
      var LatLongList = [];
      if (response.statusCode == 200) {
        for (var json in jsonData) {
          GpsDataModel gpsDataModel = new GpsDataModel();
          gpsDataModel.imei = json["imei"] != null ? json["imei"] : 'NA';
          gpsDataModel.lat = double.parse(json["lat"] != null ? json["lat"] : 0);
          gpsDataModel.lng = double.parse(json["lng"] != null ? json["lng"] : 0);
          gpsDataModel.speed = json["speed"] != null ? json["speed"] : 'NA';
          gpsDataModel.deviceName = json["deviceName"] != null ? json["deviceName"] : 'NA';
          print("Device Name is ${gpsDataModel.deviceName}");
          gpsDataModel.powerValue = json["powerValue"] != null ? json["powerValue"] : 'NA';
          gpsDataModel.direction = json["direction"] != null ? json["direction"] : 'NA';
          LatLongList.add(gpsDataModel);
        }
        return LatLongList;
      }
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}