import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';

Future<String> getDriverNameFromDriverApi(driverId) async {
  var jsonData;
  String? tempDropdownvalue2;
  String driverApiUrl =
      "http://ec2-15-207-113-71.ap-south-1.compute.amazonaws.com:9080/driver";
  try {
    http.Response response =
        await http.get(Uri.parse(driverApiUrl + '/$driverId'));
    jsonData = json.decode(response.body);
    DriverModel driverModel = DriverModel();
    driverModel.phoneNum = jsonData["phoneNum"];
    driverModel.driverName = jsonData["driverName"];
    tempDropdownvalue2 = "${driverModel.driverName} - ${driverModel.phoneNum}";
  } catch (e) {
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
  }
  return tempDropdownvalue2.toString();
}
