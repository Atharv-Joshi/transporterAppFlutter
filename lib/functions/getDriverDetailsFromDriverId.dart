import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/driverModel.dart';

getDriverDetailsFromDriverId(driverId) async {
  var jsonData;
  final String driverApiUrl = dotenv.get("driverApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$driverApiUrl/$driverId"));
  try {
    jsonData = json.decode(response.body);

    DriverModel driverModel = DriverModel();

    driverModel.driverName = jsonData["driverName"].toString();

    driverModel.phoneNum = jsonData['phoneNum'].toString();

    return driverModel;
  } catch (e) {
    print(e);
  }
}
