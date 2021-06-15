import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';
import 'package:liveasy/models/truckModel.dart';

import 'getDriverDetailsFromDriverApi.dart';

List<TruckModel> truckDetailsList = [];
List truckNoList = [];
List driverIdList = [];

Future<List> getTruckDetailsFromTruckApi() async {
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  var jsonData;

  String truckApiUrl =
      "http://ec2-3-7-133-111.ap-south-1.compute.amazonaws.com:9090/truck";
  try {
    http.Response response = await http.get(Uri.parse(
        truckApiUrl + '?transporterId=${tIdController.transporterId}'));
    jsonData = json.decode(response.body);

    for (var json in jsonData) {
      TruckModel truckModel = TruckModel(truckApproved: false);
      truckModel.truckId = json["truckId"];
      truckModel.transporterId = json["transporterId"];
      truckModel.truckNo = json["truckNo"];
      truckModel.truckApproved = json["truckApproved"];
      truckModel.imei = json["imei"];
      truckModel.driverId = json["driverId"];
      truckDetailsList.add(truckModel);
      if (truckNoList.isEmpty) {
        truckNoList.add(truckModel.truckNo);
      }
      for (int i = 0; i < truckNoList.length; i++) {
        if (truckNoList[i] == truckModel.truckNo) {
          print("has already added");
          break;
        } else if (i == truckNoList.length - 1)
          truckNoList.add(truckModel.truckNo);
      }
      driverIdList.add(truckModel.driverId);
    }
  } catch (e) {
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
  }

  if (truckNoList.isEmpty) {
    truckNoList.add("Add Truck");
  }
  for (int i = 0; i < truckNoList.length; i++) {
    if (truckNoList[i] == "Add Truck") {
      print("has already added");
      break;
    } else if (i == truckNoList.length - 1) truckNoList.add("Add Truck");
  }

  getDriverDetailsFromDriverApi();
  return truckDetailsList;
}
