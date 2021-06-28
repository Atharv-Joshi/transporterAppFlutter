import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<GpsDataModel> getLocationByImei({String? imei}) async {
  var jsonData;
  String gpsApiUrl = FlutterConfig.get("gpsApiUrl");
  http.Response response = await http.get(Uri.parse("$gpsApiUrl/$imei"));
  jsonData = await jsonDecode(response.body);
  print(response.statusCode);
  print(jsonData);
  GpsDataModel gpsDataModel = new GpsDataModel();
  gpsDataModel.imei = jsonData["imei"];
  gpsDataModel.lat = double.parse(jsonData["lat"]);
  gpsDataModel.lng = double.parse(jsonData["lng"]);
  gpsDataModel.speed = jsonData["speed"];
  gpsDataModel.deviceName = jsonData["deviceName"];
  gpsDataModel.powerValue = jsonData["powerValue"];
  return gpsDataModel;
}
