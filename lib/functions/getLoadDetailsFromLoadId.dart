import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadApiModel.dart';

getLoadDetailsFromLoadId(loadId) async {
  var jsonData;
  final String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$loadApiUrl/$loadId"));

  jsonData = json.decode(response.body);

  LoadApiModel loadApiModel = LoadApiModel();
  loadApiModel.loadId = jsonData["loadId"].toString();
  loadApiModel.loadingPoint = jsonData["loadingPoint"].toString();
  loadApiModel.loadingPointCity = jsonData["loadingPointCity"].toString();
  loadApiModel.loadingPointState = jsonData["loadingPointState"].toString();
  loadApiModel.postLoadId = jsonData["postLoadId"].toString();
  loadApiModel.unloadingPoint = jsonData["unloadingPoint"].toString();
  loadApiModel.unloadingPointCity = jsonData["unloadingPointCity"].toString();
  loadApiModel.unloadingPointState = jsonData["unloadingPointState"].toString();
  loadApiModel.productType = jsonData["productType"].toString();
  loadApiModel.truckType = jsonData["truckType"].toString();
  loadApiModel.noOfTrucks = jsonData["noOfTrucks"].toString();
  loadApiModel.weight = jsonData["weight"].toString();
  loadApiModel.comment = jsonData["comment"].toString();
  loadApiModel.status = jsonData["status"].toString();
  loadApiModel.loadDate = jsonData["loadDate"].toString();
  loadApiModel.rate = jsonData["rate"].toString();
  loadApiModel.unitValue = jsonData["unitValue"].toString();

  return loadApiModel;
}
