import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/driverModel.dart';

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

  Future<dynamic> getDriverByDriverId(
      {String? driverId, TruckModel? truckModel}) async {
    print('in getDriverByDriverId');
    print(driverId);
    Map? jsonData;

    if (driverId != null) {
      print('driver id not equal to null');
      print('$driverApiUrl/$driverId');
      http.Response response =
      await http.get(Uri.parse('$driverApiUrl/$driverId'));
      print(response.body);
      Map jsonData = json.decode(response.body);
      print('driver json : $jsonData');
      DriverModel driverModel = DriverModel();
      driverModel.driverId = jsonData["driverId"] != null ? jsonData["driverId"] : 'NA';
      driverModel.transporterId = jsonData["transporterId"] != null ? jsonData["transporterId"] : 'NA';
      driverModel.phoneNum = jsonData["phoneNum"] != null ? jsonData["phoneNum"] : '';
      driverModel.driverName = jsonData["driverName"] != null ? jsonData["driverName"] : 'NA';
      driverModel.truckId = jsonData["truckId"] != null ? jsonData["truckId"] : 'NA';

      return driverModel;
    }

    if (truckModel!.driverId != null) {
      http.Response response =
      await http.get(Uri.parse('$driverApiUrl/${truckModel.driverId}'));

      jsonData = json.decode(response.body);
    }

    TruckModel truckModelFinal = TruckModel(truckApproved: false);
    truckModelFinal.driverName =
    truckModel.driverId != null ? jsonData!['driverName'] : 'NA';
    truckModelFinal.truckApproved = truckModel.truckApproved;
    truckModelFinal.truckNo = truckModel.truckNo;
    truckModelFinal.truckType = truckModel.truckType;
    truckModelFinal.tyres = truckModel.tyres;
    truckModelFinal.driverNum =
    truckModel.driverId != null ? jsonData!['phoneNum'] : 'NA';
    truckModelFinal.imei = truckModel.imei;

    return truckModelFinal;
  }

  //POST DRIVER-----------------------------------------------------------------

  postDriverApi(driverName, phoneNum, transporterId, truckId) async {
    Map data = {
      "driverName": driverName,
      "phoneNum": phoneNum,
      "transporterId": transporterId,
      "truckId": truckId
    };
    String body = json.encode(data);
    // final String driverApiUrl = FlutterConfig.get('driverApiUrl').toString();
    final response = await http.post(Uri.parse("$driverApiUrl"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    print(response.body);
  }

}
