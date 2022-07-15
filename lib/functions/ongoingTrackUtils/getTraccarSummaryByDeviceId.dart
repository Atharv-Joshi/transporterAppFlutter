import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';


getTraccarSummaryByDeviceId({
  int? deviceId,
  String? from,
  String? to,
}) async {

  String traccarUser = FlutterConfig.get("traccarUser");
  String traccarPass = FlutterConfig.get("traccarPass");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String traccarApi = FlutterConfig.get("traccarApi");

  try {
    http.Response response = await http.get(
        Uri.parse(
            "$traccarApi/reports/summary?deviceId=$deviceId&from=${from}Z&to=${to}Z"),
        headers: <String, String>{'authorization': basicAuth});
    print(response.statusCode);
    print(response.body);
    var jsonData = await jsonDecode(response.body);
    print(response.body);
    var LatLongList = [];
    if (response.statusCode == 200) {
      for (var json in jsonData) {
        GpsDataModel gpsDataModel = new GpsDataModel();
        // gpsDataModel.id = json["id"] != null ? json["id"] : 'NA';
        gpsDataModel.deviceId =
        json["deviceId"] != null ? json["deviceId"] : 0;
        gpsDataModel.speed =
        json["averageSpeed"] != null ? json["averageSpeed"] : 0;
        gpsDataModel.distance =
        json["distance"] != null ? json["distance"] : 0;

        gpsDataModel.startTime =
        json["startTime"] != null ? json["startTime"] : 'NA';
        gpsDataModel.endTime =
        json["endTime"] != null ? json["endTime"] : 'NA';

        // print("Device time : ${gpsDataModel.deviceTime}");

        LatLongList.add(gpsDataModel);
      }
      print("TDSummary $LatLongList");
      return LatLongList;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}