import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';


class TruckApiCalls {
  // retrieving TRUCKAPIURL  from env file
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');

  // transporterId controller
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  //json data list
  late List jsonData;

  // Truck Model List used to  create cards
  List<TruckModel> truckDataList = [];

  // This variable is used to return truckId to MyTruckScreens
  String? _truckId;



//GET---------------------------------------------------------------------------

  //GET Truck Data by truckId
  Future<Map> getDataByTruckId(String truckId) async  {
    http.Response response = await http.get(Uri.parse('$truckApiUrl/$truckId'));
    var jsonData = json.decode(response.body);

    Map data = {
      'driverId' : jsonData['driverId'],
      'truckNo' : jsonData['truckNo'],
      'imei' : jsonData['imei']
    };

    return data;
  }

  //POST------------------------------------------------------------------------
  Future<String?> postTruckData({required String truckNo}) async {

    print('transporterId : ${transporterIdController.transporterId.value}');
    // json map
    Map<String, dynamic> data = {
      "transporterId": transporterIdController.transporterId.value,
      "truckNo": truckNo,
    };

    String body = json.encode(data);

    //post request
    http.Response response = await http.post(Uri.parse(truckApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    var returnData = json.decode(response.body);

    print(returnData);

    _truckId = returnData['truckId'];

    return _truckId;
  } //post truck data

  //PUT-------------------------------------------------------------------------

  Future<String?> putTruckData(
      {required String truckID,
      required String truckType,
      required int totalTyres,
      required int passingWeight,
      required int truckLength,
      required String driverID}) async {
    //json map
    Map<String, dynamic> data = {
      "driverId": driverID == '' ? null : driverID,
      "imei": null,
      "passingWeight": passingWeight == 0 ? null : passingWeight,
      "transporterId": transporterIdController.transporterId.value,
      "truckApproved": false,
      "truckType": truckType == '' ? null : truckType,
      "truckLength": truckLength == 0 ? null : truckLength,
      "tyres": totalTyres == 0 ? null : totalTyres
    };

    String body = json.encode(data);

    http.Response response = await http.put(Uri.parse('$truckApiUrl/$truckID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    var returnData = json.decode(response.body);
    _truckId = returnData['truckId'];
    return _truckId;
  }
} //class end
