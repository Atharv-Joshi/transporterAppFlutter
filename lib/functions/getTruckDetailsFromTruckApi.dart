import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import 'getDriverDetailsFromDriverApi.dart';

Future<List> getTruckDetailsFromTruckApi(BuildContext context) async {
  var providerData = Provider.of<ProviderData>(context,listen: false);
  List driverDetailsList = [];
  // List truckNoList = [];
  List driverIdList = [];
  List<TruckModel> truckDetailsList = [];
  List truckAndDriverList = [];
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
      providerData.updateTruckNoList(newValue: truckModel.truckNo.toString());
      // if (truckNoList.isEmpty) {
      //   truckNoList.add(truckModel.truckNo);
      // }
      // for (int i = 0; i < truckNoList.length; i++) {
      //   if (truckNoList[i] == truckModel.truckNo) {
      //     print("has already added");
      //     break;
      //   } else if (i == truckNoList.length - 1)
      //     truckNoList.add(truckModel.truckNo);
      // }
      driverIdList.add(truckModel.driverId);
    }
  } catch (e) {
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
  }

  // if (truckNoList.isEmpty) {
  //   truckNoList.add("Add Truck");
  // }
  // for (int i = 0; i < truckNoList.length; i++) {
  //   if (truckNoList[i] == "Add Truck") {
  //     print("has already added");
  //     break;
  //   } else if (i == truckNoList.length - 1) truckNoList.add("Add Truck");
  // }

  // truckAndDriverList.add(truckNoList);
  truckAndDriverList.add(truckDetailsList);

  driverDetailsList = await getDriverDetailsFromDriverApi(context,driverIdList);

  truckAndDriverList.add(driverDetailsList);

  return truckAndDriverList;
}
