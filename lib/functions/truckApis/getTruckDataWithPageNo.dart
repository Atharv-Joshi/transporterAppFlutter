import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

getTruckDataWithPageNo(int i) async {
  DriverApiCalls driverApiCalls = DriverApiCalls();

  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  // retrieving TRUCKAPIURL  from env file
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');

  http.Response response = await http.get(Uri.parse(
      '$truckApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
  var jsonData = json.decode(response.body);
  var truckDataList = [];
  for (var json in jsonData) {
    TruckModel truckModel = TruckModel();
    truckModel.truckId = json["truckId"] != null ? json["truckId"] : 'NA';
    truckModel.transporterId =
        json["transporterId"] != null ? json["transporterId"] : 'NA';
    truckModel.truckNo = json["truckNo"] != null ? json["truckNo"] : 'NA';
    truckModel.truckApproved =
        json["truckApproved"] != null ? json["truckApproved"] : false;
    truckModel.imei = json["imei"] != null ? json["imei"] : 'NA';
    truckModel.passingWeightString =
        json["passingWeight"] != null ? json["passingWeight"].toString() : 'NA';
    truckModel.truckType = json["truckType"] != null ? json["truckType"] : 'NA';
    truckModel.driverId = json["driverId"] != null ? json["driverId"] : 'NA';
    truckModel.tyres =
        json["tyres"] != null ? json["tyres"].toString() : 'NA';
    truckModel.truckLengthString =
        json["truckLength"] != null ? json["truckLength"].toString() : 'NA';
    //driver data
    DriverModel driverModel =
        await driverApiCalls.getDriverByDriverId(driverId: truckModel.driverId);
    truckModel.driverName = driverModel.driverName;
    truckModel.driverNum = driverModel.phoneNum;
    truckDataList.add(truckModel);
  }
  return truckDataList;
}

getGPSTruckDataWithPageNo(int i) async {
  //TransporterId controller
  TransporterIdController transporterIdController =
  Get.find<TransporterIdController>();

  // retrieving TRUCKAPIURL  from env file
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');

  http.Response response = await http.get(Uri.parse(
      '$truckApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
  var jsonData = json.decode(response.body);
  var truckDataList = [];
  for (var json in jsonData) {
    TruckModel truckModel = TruckModel();
    truckModel.truckId = json["truckId"] != null ? json["truckId"] : 'NA';
    truckModel.transporterId =
    json["transporterId"] != null ? json["transporterId"] : 'NA';
    truckModel.truckNo = json["truckNo"] != null ? json["truckNo"] : 'NA';
    truckModel.truckApproved =
    json["truckApproved"] != null ? json["truckApproved"] : false;
    truckModel.imei = json["imei"] != null ? json["imei"] : 'NA';
    truckModel.passingWeightString =
    json["passingWeight"] != null ? json["passingWeight"].toString() : 'NA';
    truckModel.truckType = json["truckType"] != null ? json["truckType"] : 'NA';
    truckModel.driverId = json["driverId"] != null ? json["driverId"] : 'NA';
    truckModel.tyres =
    json["tyres"] != null ? json["tyres"].toString() : 'NA';
    truckModel.truckLengthString =
    json["truckLength"] != null ? json["truckLength"].toString() : 'NA';
    truckDataList.add(truckModel);
  }
  return truckDataList;
}
