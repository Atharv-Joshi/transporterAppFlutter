import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';

TransporterIdController tIdController = Get.find<TransporterIdController>();
var jsonData;
List truckNoList = [];
String truckApiUrl =
    "http://ec2-3-7-133-111.ap-south-1.compute.amazonaws.com:9090/truck";

Future<List> getTruckNoFromTruckApi() async {
  http.Response response = await http.get(
      Uri.parse(truckApiUrl + '?transporterId=tIdController.transporterId'));
  jsonData = json.decode(response.body);

  for (var json in jsonData) {
    truckNoList.add(json["truckNo"]);
  }
  truckNoList.add("Add Truck");
  return truckNoList;
}
