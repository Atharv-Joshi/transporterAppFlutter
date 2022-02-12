import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/gpsDataModelForHistory.dart';
import 'package:liveasy/models/responseModel.dart';
import 'package:liveasy/screens/truckLockScreen.dart';
import 'package:liveasy/screens/truckUnlockScreen.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

String traccarUser = FlutterConfig.get("traccarUser");
String traccarPass = FlutterConfig.get("traccarPass");
String traccarApi = FlutterConfig.get("traccarApi");
String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

//TRACCAR API CALLS------------------------------------------------------------
Future<String> postCommandsApi(
  final List gpsData,
  var gpsDataHistory,
  var gpsStoppageHistory,
  var routeHistory,
  final String? TruckNo,
  final String? driverNum,
  final String? driverName,
  var truckId,
  int? deviceId,
  String? type,
  String? description,
) async {
  try {
    Map data = {"deviceId": deviceId, "type": type, "description": description};
    String body = json.encode(data);

    final response = await http.post(Uri.parse("$traccarApi/commands/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': basicAuth,
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 202) {
      print(response.body);
      Get.back();
      // if (type == "engineResume") {
      //   Get.back();
      //   Get.to(() => TruckUnlockScreen(
      //         deviceId: deviceId,
      //         gpsData: gpsData,
      //         // position: position,
      //         TruckNo: TruckNo,
      //         driverName: driverName,
      //         driverNum: driverNum,
      //         gpsDataHistory: gpsDataHistory,
      //         gpsStoppageHistory: gpsStoppageHistory,
      //         routeHistory: routeHistory,
      //         truckId: truckId,
      //       ));
      // } else if (type == "engineStop") {
      //   Get.back();
      //   Get.to(() => TruckLockScreen(
      //         deviceId: deviceId,
      //         gpsData: gpsData,
      //         // position: position,
      //         TruckNo: TruckNo,
      //         driverName: driverName,
      //         driverNum: driverNum,
      //         gpsDataHistory: gpsDataHistory,
      //         gpsStoppageHistory: gpsStoppageHistory,
      //         routeHistory: routeHistory,
      //         truckId: truckId,
      //       ));
      // }
      return "Success";
    } else {
      return "Error ${response.statusCode} \n Printing Response ${response.body}";
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}
