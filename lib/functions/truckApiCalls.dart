import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

class TruckApiCalls{
  final String truckApiUrl = FlutterConfig.get('truckApiUrl').toString();

  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  var jsonData;
  List<TruckModel> truckDataList = [];

//GET---------------------------------------------------------------------------
  Future<List<TruckModel>> getTruckData() async {
    http.Response response = await http.get(Uri.parse(truckApiUrl+ '?transporterId=${transporterIdController.transporterId.value}'));
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      TruckModel truckModel = TruckModel( truckApproved: false);
      truckModel.truckId = json["truckId"];
      truckModel.transporterId = json["transporterId"];
      truckModel.truckNo = json["truckNo"];
      truckModel.truckApproved = json["truckApproved"];
      truckModel.imei = json["imei"];
      truckModel.passingWeight = json["passingWeight"];
      truckModel.truckType = json["truckType"];
      truckModel.driverId = json["driverId"];
      truckModel.tyres = json["tyres"];
      truckDataList.add(truckModel);
    }
    return truckDataList;
  }

  //POST------------------------------------------------------------------------
  void postTruckData({required String truckNo}) async {

    Map<String,dynamic> data = {
      "driverId" : null,
      "imei" : null,
      "passingWeight" : 0,
      "transporterId" : transporterIdController.transporterId.value,
      "truckApproved" : false,
      "truckNo" : truckNo,
      "truckType" : null,
      "tyres" : null
    };

    String body = json.encode(data);


      http.Response response = await http.post(
          Uri.parse(truckApiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body
      );
    }//post truck data

  //PUT-------------------------------------------------------------------------

void putTruckData({dynamic truckType , dynamic totalTyres , dynamic passingWeight , dynamic truckLength , dynamic driverDetails }){

}

  } //class end
