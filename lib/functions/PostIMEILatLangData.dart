import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'dart:convert';

final String gpsApiUrl = FlutterConfig.get('gpsApiUrl');

Future<String?> postIMEILatLngData({
  required String? trasnporterID,
  required String? lat,
  required String? lng,
  required String? speed,
  required String? deviceName,
  required String? powerValue,
  required String? direction,}) async {

  // json map
  Map<String, dynamic> data = {
    "imei": trasnporterID,
    "lat": lat,
    "lng": lng,
    "speed": speed,
    "deviceName": deviceName,
    "powerValue": powerValue,
    "direction": direction
  };

  String body = json.encode(data);

  //post request
  http.Response response = await http.post(Uri.parse(gpsApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);

  print("${DateTime.now()} Response is ${response.body}");

  return response.body;
}