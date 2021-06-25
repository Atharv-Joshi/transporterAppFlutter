import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/truckModel.dart';

getTruckDetailsFromTruckId(truckId) async {
  var jsonData;
  final String truckApiUrl = FlutterConfig.get("truckApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$truckApiUrl/$truckId"));
  try {
    jsonData = json.decode(response.body);

    TruckModel truckModel = TruckModel(truckApproved: false);

    truckModel.driverId = jsonData["driverId"].toString();

    return truckModel;
  } catch (e) {
    print(e);
  }
}
