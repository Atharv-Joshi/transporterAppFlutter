import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

Future<String> getDriverNameFromDriverApi(
    BuildContext context, driverId) async {
  var providerData = Provider.of<ProviderData>(context, listen: false);
  var jsonData;
  String? tempDropDownValue2;
  String driverApiUrl =
      "http://ec2-15-207-113-71.ap-south-1.compute.amazonaws.com:9080/driver";
  try {
    http.Response response =
        await http.get(Uri.parse(driverApiUrl + '/$driverId'));
    jsonData = json.decode(response.body);
    DriverModel driverModel = DriverModel();
    driverModel.phoneNum = jsonData["phoneNum"];
    driverModel.driverName = jsonData["driverName"];
    tempDropDownValue2 = "${driverModel.driverName} - ${driverModel.phoneNum}";
  } catch (e) {
    print("hi getDriverNameFromDriverApi has some error" + " $e");
  }
  providerData.updateDropDownValue2(newValue: tempDropDownValue2.toString());
  return tempDropDownValue2.toString();
}
