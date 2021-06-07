import 'package:http/http.dart' as http;
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

class GetDataFromApi{

  var jsonData;
  List<TruckModel> truckDataList = [];
  final String truckApiUrl = FlutterConfig.get('truckApiUrl').toString();

  Future<List<TruckModel>> getTruckData() async {
    http.Response response = await http.get(Uri.parse(truckApiUrl));
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
}