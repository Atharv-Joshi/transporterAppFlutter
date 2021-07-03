import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'dart:convert';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import 'getDriverDetailsFromDriverApi.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List> getTruckDetailsFromTruckApi(BuildContext context) async {
  var providerData = Provider.of<ProviderData>(context, listen: false);
  List driverDetailsList = [];
  List driverIdList = [];
  List<TruckModel> truckDetailsList = [];
  List truckAndDriverList = [];
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  var jsonData;
  final String truckApiUrl = FlutterConfig.get('truckApiUrl').toString();
  try {
    http.Response response = await http.get(Uri.parse(
        truckApiUrl + '?transporterId=${tIdController.transporterId}'));
    jsonData = json.decode(response.body);

    for (var json in jsonData) {
      TruckModel truckModel = TruckModel(truckApproved: false);
      truckModel.truckId = json["truckId"];
      truckModel.transporterId = json["transporterId"];
      truckModel.truckNo = json["truckNo"];
      truckModel.truckApproved = json["truckApproved"];
      truckModel.imei = json["imei"];
      truckModel.driverId = json["driverId"];
      truckDetailsList.add(truckModel);
      providerData.updateTruckNoList(newValue: truckModel.truckNo.toString());
      // driverIdList.add(truckModel.driverId);
    }
  } catch (e) {
    print("hi getTruckDetailsFromApi has some error" + '$e');
  }
  // truckAndDriverList.add(truckDetailsList);

  // driverDetailsList =
  //     await getDriverDetailsFromDriverApi(context, driverIdList);
  //
  // truckAndDriverList.add(driverDetailsList);

  return truckDetailsList;
}
