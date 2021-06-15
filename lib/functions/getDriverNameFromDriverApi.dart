import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:liveasy/models/driverModel.dart';

var jsonData;
String? temp_dropdownvalue2;
String driverApiUrl =
    "http://ec2-15-207-113-71.ap-south-1.compute.amazonaws.com:9080/driver";

getDriverNameFromDriverApi(driverId) async {

    try {
      http.Response response = await http.get(Uri.parse(driverApiUrl + '/$driverId'));
      jsonData = json.decode(response.body);
      DriverModel driverModel = DriverModel();
      driverModel.phoneNum = jsonData["phoneNum"];
      driverModel.driverName = jsonData["driverName"];
      temp_dropdownvalue2 ="${driverModel.driverName} - ${driverModel.phoneNum}";
    } catch (e) {
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

