import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadApiModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<LoadApiModel>> runSuggestedLoadApi() async {
  String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  var jsonData;
  Uri url = Uri.parse("$loadApiUrl");
  http.Response response = await http.get(url);
  jsonData = await jsonDecode(response.body);
  List<LoadApiModel> data = [];
  for (var json in jsonData) {
    LoadApiModel cardsModal = LoadApiModel();
    cardsModal.loadId = json["loadId"];
    cardsModal.loadingPoint = json["loadingPoint"];
    cardsModal.loadingPointCity = json["loadingPointCity"];
    cardsModal.loadingPointState = json["loadingPointState"];
    cardsModal.postLoadId = json["postLoadId"];
    cardsModal.unloadingPoint = json["unloadingPoint"];
    cardsModal.unloadingPointCity = json["unloadingPointCity"];
    cardsModal.unloadingPointState = json["unloadingPointState"];
    cardsModal.productType = json["productType"];
    cardsModal.truckType = json["truckType"];
    cardsModal.noOfTrucks = json["noOfTrucks"];
    cardsModal.weight = json["weight"];
    cardsModal.comment = json["comment"];
    cardsModal.status = json["status"];
    cardsModal.loadDate = json["loadDate"];
    cardsModal.rate = json["rate"];
    cardsModal.unitValue = json["unitValue"];
    data.add(cardsModal);
  }
  return data;
}
