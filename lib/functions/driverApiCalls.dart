import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/driverModel.dart';
import "package:flutter/material.dart";
class DriverApiCalls {
  List<DriverModel> driverList = [];

  List? jsonData;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  final String driverApiUrl = FlutterConfig.get('driverApiUrl');

  //GET DRIVERS BY TRANSPORTER ID-----------------------------------------------

  Future<List> getDriversByTransporterId() async {
    http.Response response = await http.get(Uri.parse(
        '$driverApiUrl?transporterId=${transporterIdController.transporterId.value}'));

    jsonData = json.decode(response.body);

    for (var json in jsonData!) {
      DriverModel driverModel = DriverModel();
      driverModel.driverId = json["driverId"];
      driverModel.transporterId = json["transporterId"];
      driverModel.phoneNum = json["phoneNum"];
      driverModel.driverName = json["driverName"];
      driverModel.truckId = json["truckId"];
      driverList.add(driverModel);
    }

    print(driverList);
    return driverList;
  }

  //----------------------------------------------------------------------------

  Future<dynamic> getDriverByDriverId({String? driverId, TruckModel? truckModel}) async {

    Map? jsonData;

    if (driverId != null) {
      http.Response response =
          await http.get(Uri.parse('$driverApiUrl/$driverId'));
      print(response.body);
      Map jsonData = json.decode(response.body);
      DriverModel driverModel = DriverModel();
      driverModel.driverId = jsonData["driverId"] != null ? jsonData["driverId"] : 'NA';
      driverModel.transporterId = jsonData["transporterId"] != null ? jsonData["transporterId"] : 'NA';
      driverModel.phoneNum = jsonData["phoneNum"] != null ? jsonData["phoneNum"] : 'NA';
      driverModel.driverName = jsonData["driverName"] != null ? jsonData["driverName"] : 'NA';
      driverModel.truckId = jsonData["truckId"] != null ? jsonData["truckId"] : 'NA';
      return driverModel;
    }

    if (truckModel!.driverId != null) {
      try {
        http.Response response =
        await http.get(Uri.parse('$driverApiUrl/${truckModel.driverId}'))
            .timeout(
            Duration(seconds: 1),
            onTimeout: () {
              throw TimeoutException(
                  'The connection has timed out, Please try again!');
            });
        jsonData = json.decode(response.body);
      }catch(e){
          jsonData = {
            'driverName' : 'NA',
            'phoneNum' : 'NA'
          };
      }
      TruckModel truckModelFinal = TruckModel(truckApproved: false);
      truckModelFinal.driverName =
      truckModel.driverId != null ? jsonData!['driverName'] : 'NA';
      truckModelFinal.truckApproved = truckModel.truckApproved;
      truckModelFinal.truckId = truckModel.truckId;
      truckModelFinal.truckNo = truckModel.truckNo;
      truckModelFinal.truckType = truckModel.truckType;
      truckModelFinal.tyres = truckModel.tyres;
      truckModelFinal.driverNum =
      truckModel.driverId != null ? jsonData!['phoneNum'] : 'NA';
      truckModelFinal.imei = truckModel.imei;
      return truckModelFinal;
      }
    else{
      jsonData = {
        'driverName' : 'NA',
        'phoneNum' : 'NA'
      };
      TruckModel truckModelFinal = TruckModel(truckApproved: false);
      truckModelFinal.driverName =
      truckModel.driverId != null ? jsonData['driverName'] : 'NA';
      truckModelFinal.truckApproved = truckModel.truckApproved;
      truckModelFinal.truckNo = truckModel.truckNo;
      truckModelFinal.truckId = truckModel.truckId;
      truckModelFinal.truckType = truckModel.truckType;
      truckModelFinal.tyres = truckModel.tyres;
      truckModelFinal.driverNum =
      truckModel.driverId != null ? jsonData['phoneNum'] : 'NA';
      truckModelFinal.imei = truckModel.imei;
      return truckModelFinal;

    }

  }

  //POST DRIVER-----------------------------------------------------------------


  postDriverApi(driverName, phoneNum, transporterId) async {
    try {
      Map data = {
        "driverName": driverName,
        "phoneNum": phoneNum,
        "transporterId": transporterId
      };
      String body = json.encode(data);
      // final String driverApiUrl = FlutterConfig.get('driverApiUrl').toString();
      final response = await http.post(Uri.parse("$driverApiUrl"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      print("driver Api response : ${response.body}");
      var decodedData = json.decode(response.body);
      if (decodedData["driverId"] != null) {
        Get.defaultDialog(content: Scaffold(
          body: Container(child: Column(
            children: [
              Text("Success!"),
              Text("${decodedData["status"]}")
            ],
          ),),
        ),);
        // Get.snackbar("Success!", "${decodedData["status"]}");
        return decodedData["driverId"];
      } else{
        Get.defaultDialog(content: Scaffold(
          body: Container(child: Column(
            children: [
              Text("Failed!"),
              Text("${decodedData["status"]}")
            ],
          ),),
        ),);
        // Get.snackbar("Error", "${decodedData["status"]}");
        return null;}
    } catch (e) {
      print(e);
      Get.snackbar("Error", "$e");
      return null;
    }
  }
}

