import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/getTruckNoFromTruckApi.dart';
import 'dart:convert';
import 'package:liveasy/models/driverModel.dart';

var jsonData;
List<DriverModel> driverDetailsList = [];
List driverNameList = [];
TransporterIdController tIdController = Get.find<TransporterIdController>();
String driverApiUrl =
    "http://ec2-15-207-113-71.ap-south-1.compute.amazonaws.com:9080/driver";

Future<List> getDriverDetailsFromDriverApi() async {
  for (var i in driverIdList) {
    try {
      http.Response response = await http.get(Uri.parse(driverApiUrl + '/$i'));
      jsonData = json.decode(response.body);
      DriverModel driverModel = DriverModel();
      driverModel.driverId = jsonData["driverId"];
      driverModel.transporterId = jsonData["transporterId"];
      driverModel.phoneNum = jsonData["phoneNum"];
      driverModel.driverName = jsonData["driverName"];
      driverModel.truckId = jsonData["truckId"];
      driverDetailsList.add(driverModel);
      if (driverNameList.isEmpty) {
        driverNameList
            .add("${driverModel.driverName} - ${driverModel.phoneNum}");
      }
      for (int i = 0; i < driverNameList.length; i++) {
        if (driverNameList[i] ==
            "${driverModel.driverName} - ${driverModel.phoneNum}") {
          print("has already added");
          break;
        } else if (i == driverNameList.length - 1)
          driverNameList
              .add("${driverModel.driverName} - ${driverModel.phoneNum}");
      }
    } catch (e) {
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  if (driverNameList.isEmpty) {
    driverNameList.add("Add New Driver");
  }
  for (int i = 0; i < driverNameList.length; i++) {
    if (driverNameList[i] == "Add New Driver") {
      print("has already added");
      break;
    } else if (i == driverNameList.length - 1)
      driverNameList.add("Add New Driver");
  }

  return driverDetailsList;
}
