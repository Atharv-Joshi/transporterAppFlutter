import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';
import 'package:liveasy/models/truckModel.dart';
/*
TransporterIdController tIdController = Get.find<TransporterIdController>();
var jsonData;
List truckDetailsList = [];

String truckApiUrl =
    "http://ec2-3-7-133-111.ap-south-1.compute.amazonaws.com:9090/truck";

Future <List> getTruckDetailsFromTruckApi() async {
  try {
    http.Response response = await http.get(
        Uri.parse(
            truckApiUrl + '?transporterId=${tIdController.transporterId}'));
    jsonData = json.decode(response.body);
    for (var i in jsonData) {
      TruckModel truckModel = TruckModel();
      truckModel.truckId = i["truckId"];
      truckModel.transporterId = i["transporterId"];
      truckModel.truckNo = i["truckNo"];
      truckModel.truckApproved = i["truckApproved"];
      truckModel.imei = i["imei"];
      truckModel.passingWeight = i["passingWeight"];
      truckModel.driverId = i["driverId"];
      truckModel.truckType = i["truckType"];
      truckModel.tyres = i["tyres"];
      truckDetailsList.add(truckModel);*//*
    }
  }
  catch(e){print(e);}
  return truckDetailsList;
}
*/