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
      if (response.statusCode == 200) {
        GpsDataModel gpsDataModel = new GpsDataModel();
        gpsDataModel.imei = jsonData["imei"];
        gpsDataModel.lat = double.parse(jsonData["lat"]);
        gpsDataModel.lng = double.parse(jsonData["lng"]);
        gpsDataModel.speed = jsonData["speed"];
        gpsDataModel.deviceName = jsonData["deviceName"];
        gpsDataModel.powerValue = jsonData["powerValue"];
        gpsDataModel.direction = jsonData["direction"];
        return gpsDataModel;
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