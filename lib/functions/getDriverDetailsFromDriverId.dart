import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/driverModel.dart';

getDriverDetailsFromDriverId(driverId) async {
  var jsonData;
  final String driverApiUrl = FlutterConfig.get("driverApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$driverApiUrl/$driverId"));
  try {
    jsonData = json.decode(response.body);

    DriverModel driverModel = DriverModel();

    driverModel.driverName = jsonData["driverName"].toString();

    return driverModel;
  } catch (e) {
    print(e);
  }
}
