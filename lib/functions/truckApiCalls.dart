import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/controller/truckIdController.dart';
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

class TruckApiCalls{
  // retrieving TRUCKAPI URL  from env file
  final String truckApiUrl = FlutterConfig.get('truckApiUrl');

  // transporterId controller
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  //truckId controller ..used to store truckId for latest truck
  TruckIdController truckIdController = TruckIdController();

  //json data list
  late List jsonData;

  // Truck Model List used to  create cards
  List<TruckModel> truckDataList = [];

  String truckId = '';

//GET---------------------------------------------------------------------------
  Future<List<TruckModel>> getTruckData() async {

    //TODO: implement pagination(remove pseudo)
    for(int i = 0 ; ; i++ ){
      http.Response response = await http.get(Uri.parse(truckApiUrl + '?transporterId=${transporterIdController.transporterId.value}&pageNo=$i'));
      jsonData = json.decode(response.body);
      if(jsonData.isEmpty){
        break;
      }
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
      try{
        if(response.statusCode == 200){
          var returnData = response.body;
          print(json.decode(returnData)['truckId']);
          truckId = json.decode(response.body)['truckId'];
          print('successful');
          truckIdController.updatetruckId(json.decode(returnData)['truckId']);
        }
      }catch(e){
        print(e);
      }
    }//post truck data

  //PUT-------------------------------------------------------------------------

void putTruckData({dynamic truckType , dynamic totalTyres , dynamic passingWeight , dynamic truckLength , dynamic driverDetails}){

}

  } //class end
