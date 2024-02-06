import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/functions/encryptDecrypt.dart';
import 'package:liveasy/models/deviceModel.dart';

Future<List<DeviceModel>> getDeviceByDeviceId(String deviceId) async {
  String traccarUser = dotenv.get("traccarUser");
  String traccarPass = decrypt(dotenv.get('traccarPass'));
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String traccarApi = dotenv.get("traccarApi");
  try {
    http.Response response = await http.get(
        Uri.parse("$traccarApi/devices/$deviceId"),
        headers: <String, String>{
          'Authorization': basicAuth,
          'Accept': 'application/json'
        });
    var json = await jsonDecode(response.body);
    List<DeviceModel> devicesList = [];
    if (response.statusCode == 200) {
      DeviceModel deviceModel = new DeviceModel();
      deviceModel.deviceId = json["id"] != null ? json["id"] : 0;
      deviceModel.truckno = json["name"] != null ? json["name"] : 'NA';
      deviceModel.imei = json["uniqueId"] != null ? json["uniqueId"] : 'NA';
      deviceModel.status = json["status"] != null ? json["status"] : 'NA';
      deviceModel.lastUpdate =
          json["lastUpdate"] != null ? json["lastUpdate"] : 'NA';

      devicesList.add(deviceModel);
    }
    return devicesList;
    // } else {
    //   return null;
    // }
  } catch (e) {
    print(e);
    return [];
  }
}
