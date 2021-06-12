import 'package:http/http.dart' as http;
import 'package:liveasy/models/truckModel.dart';
import 'dart:convert';

class GetDataFromApi{

  var jsonData;
  List<TruckModel> truckDataList = [];
  Future<List<TruckModel>> getTruckData(int pageNo ) async {
    http.Response response = await http.get(Uri.parse("http://3.7.133.111:9090/truck?transporterId=transporter:3a965fb0-9a33-427d-a0e8-8fd3723839a8&pageNo=$pageNo"));
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