import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/functions/encryptDecrypt.dart';
import 'package:liveasy/models/gpsDataModel.dart';

getTraccarStoppagesByDeviceId({
  int? deviceId,
  String? from,
  String? to,
}) async {
  String traccarUser = dotenv.get("traccarUser");
  String traccarPass = decrypt(dotenv.get('traccarPass'));
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String traccarApi = dotenv.get("traccarApi");

  try {
    http.Response response = await http.get(
        Uri.parse(
            "$traccarApi/reports/stops?deviceId=$deviceId&from=${from}Z&to=${to}Z"),
        headers: <String, String>{
          'authorization': basicAuth,
          'Accept': 'application/json'
        });
    print(response.statusCode);
    print(response.body);
    var jsonData = await jsonDecode(response.body);
    print(response.body);
    var LatLongList = [];
    if (response.statusCode == 200) {
      for (var json in jsonData) {
        GpsDataModel gpsDataModel = new GpsDataModel();
        // gpsDataModel.id = json["id"] != null ? json["id"] : 'NA';
        gpsDataModel.deviceId = json["deviceId"] != null ? json["deviceId"] : 0;
        gpsDataModel.latitude = json["latitude"] != null ? json["latitude"] : 0;
        gpsDataModel.longitude =
            json["longitude"] != null ? json["longitude"] : 0;

        gpsDataModel.startTime =
            json["startTime"] != null ? json["startTime"] : 'NA';
        gpsDataModel.endTime = json["endTime"] != null ? json["endTime"] : 'NA';
        gpsDataModel.duration = json["duration"] != null ? json["duration"] : 0;

        LatLongList.add(gpsDataModel);
      }
      print("TDS $LatLongList");
      return LatLongList;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
