import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/gpsDataModelForHistory.dart';
import 'package:liveasy/models/responseModel.dart';
import 'package:liveasy/screens/truckLockScreen.dart';
import 'package:liveasy/screens/truckUnlockScreen.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
String? traccarUser = transporterIdController.mobileNum.value;
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
      /*   if (type == "engineResume") {
        Get.to(() => TruckUnlockScreen(
              deviceId: deviceId,
              gpsData: gpsData,
              // position: position,
              TruckNo: TruckNo,
              driverName: driverName,
              driverNum: driverNum,
              gpsDataHistory: gpsDataHistory,
              gpsStoppageHistory: gpsStoppageHistory,
              routeHistory: routeHistory,
              truckId: truckId,
            ));
      } else if (type == "engineStop") {
        Get.to(() => TruckLockScreen(
              deviceId: deviceId,
              gpsData: gpsData,
              // position: position,
              TruckNo: TruckNo,
              driverName: driverName,
              driverNum: driverNum,
              gpsDataHistory: gpsDataHistory,
              gpsStoppageHistory: gpsStoppageHistory,
              routeHistory: routeHistory,
              truckId: truckId,
            ));
      }*/
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

Future<String> getCommandsResultApi(
  int? deviceId,
  var timeNow,
) async {
  var timeCurrent = DateTime.now().toIso8601String();
  print("Current time $timeNow");
  print("TO time $timeCurrent");
  try {
    http.Response response = await http.get(
      Uri.parse(
          "$traccarApi/reports/events?from=${timeNow}Z&to=${timeCurrent}Z&deviceId=$deviceId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
    );
    print(response.statusCode);
    print(response.body);
    var jsonData = await jsonDecode(response.body);
    print("The DATA FROM EVENTS $jsonData");
    var store;
    if (response.statusCode == 200) {
      print(response.body);
      for (var json in jsonData) {
        store = json["attributes"]["result"];
      }
      print("THE STORE IS $store");
      if (store == "Restore fuel supply:Success!") {
        print("Restore fuel success");
      } else if (store == "Cut off the fuel supply: Success!") {
        print("Cutoff supply successful");
      }
      return "Success";
    } else {
      return "null";
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}
