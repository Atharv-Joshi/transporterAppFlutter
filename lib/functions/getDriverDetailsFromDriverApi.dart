import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

Future<List> getDriverDetailsFromDriverApi(
    BuildContext context, driverIdList) async {
  var providerData = Provider.of<ProviderData>(context, listen: false);
  var jsonData;
  final String driverApiUrl = FlutterConfig.get('driverApiUrl').toString();
  List<DriverModel> driverDetailsList = [];
  for (var i in driverIdList) {
    try {
      http.Response response = await http.get(Uri.parse("$driverApiUrl/$i"));
      jsonData = json.decode(response.body);
      DriverModel driverModel = DriverModel();
      driverModel.driverId = jsonData["driverId"];
      driverModel.transporterId = jsonData["transporterId"];
      driverModel.phoneNum = jsonData["phoneNum"];
      driverModel.driverName = jsonData["driverName"];
      driverModel.truckId = jsonData["truckId"];
      driverDetailsList.add(driverModel);
      providerData.updateDriverNameList(
          newValue: "${driverModel.driverName} - ${driverModel.phoneNum}");
    } catch (e) {
      print(e);
    }
  }
  return driverDetailsList;
}
