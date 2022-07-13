import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/BackgroundAndLocation.dart';
import 'package:liveasy/language/localization_service.dart';
import 'package:liveasy/models/deviceModel.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/gpsDataModelForHistory.dart';
import 'package:geocoding/geocoding.dart';


getDeviceByDeviceId(String deviceId) async {
  String traccarUser = FlutterConfig.get("traccarUser");
  String traccarPass = FlutterConfig.get("traccarPass");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String traccarApi = FlutterConfig.get("traccarApi");
  try {
    http.Response response = await http.get(Uri.parse("$traccarApi/devices/$deviceId"),
        headers: <String, String>{
          'authorization': basicAuth,
          'Accept': 'application/json'
        });
    print(response.statusCode);
    print("traccar device api response: "+response.body);
    print("done till here");
    var json = await jsonDecode(response.body);
    print(json);
    var devicesList = [];
    if (response.statusCode == 200) {
        DeviceModel devicemodel = new DeviceModel();
        // gpsDataModel.id = json["id"] != null ? json["id"] : 'NA';
        devicemodel.deviceId = json["id"] != null ? json["id"] : 0;
        devicemodel.truckno = json["name"] != null ? json["name"] : 'NA';
        devicemodel.imei = json["uniqueId"] != null ? json["uniqueId"] : 'NA';
        devicemodel.status = json["status"] != null ? json["status"] : 'NA';
        devicemodel.lastUpdate =
        json["lastUpdate"] != null ? json["lastUpdate"] : 'NA';

        devicesList.add(devicemodel);

      }
      return devicesList;
    // } else {
    //   return null;
    // }
  } catch (e) {
    print(e);
    return null;
  }
}