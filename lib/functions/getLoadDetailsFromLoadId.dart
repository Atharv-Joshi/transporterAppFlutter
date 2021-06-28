import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadApiModel.dart';

getLoadDetailsFromLoadId(loadId) async {
  var jsonData;
  final String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$loadApiUrl/$loadId"));
  try {
    jsonData = json.decode(response.body);

    LoadApiModel loadScreenCardsModel = LoadApiModel();
    loadScreenCardsModel.loadId = jsonData["loadId"].toString();
    loadScreenCardsModel.loadingPoint = jsonData["loadingPoint"].toString();
    loadScreenCardsModel.loadingPointCity =
        jsonData["loadingPointCity"].toString();
    loadScreenCardsModel.loadingPointState =
        jsonData["loadingPointState"].toString();
    loadScreenCardsModel.postLoadId = jsonData["postLoadId"].toString();
    loadScreenCardsModel.unloadingPoint = jsonData["unloadingPoint"].toString();
    loadScreenCardsModel.unloadingPointCity =
        jsonData["unloadingPointCity"].toString();
    loadScreenCardsModel.unloadingPointState =
        jsonData["unloadingPointState"].toString();
    loadScreenCardsModel.productType = jsonData["productType"].toString();
    loadScreenCardsModel.truckType = jsonData["truckType"].toString();
    loadScreenCardsModel.noOfTrucks = jsonData["noOfTrucks"].toString();
    loadScreenCardsModel.weight = jsonData["weight"].toString();
    loadScreenCardsModel.comment = jsonData["comment"].toString();
    loadScreenCardsModel.status = jsonData["status"].toString();
    loadScreenCardsModel.loadDate = jsonData["loadDate"].toString();
    loadScreenCardsModel.rate = jsonData["rate"];
    loadScreenCardsModel.unitValue = jsonData["unitValue"].toString();
    return loadScreenCardsModel;
  } catch (e) {
    print(e);
  }
}
