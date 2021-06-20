import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/suggestedLoadApiModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<SuggestLoadApiDataModel>> runSuggestedLoadApi() async {
  String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  var jsonData;
  Uri url = Uri.parse("$loadApiUrl");
  http.Response response = await http.get(url);
  jsonData = await jsonDecode(response.body);
  List<SuggestLoadApiDataModel> data = [];
  for (var json in jsonData) {
    SuggestLoadApiDataModel cardsModal = new SuggestLoadApiDataModel();
    cardsModal.loadId = json["loadId"];
    cardsModal.loadingPoint = json["loadingPoint"];
    cardsModal.loadingPointCity = json["loadingPointCity"];
    cardsModal.loadingPointState = json["loadingPointState"];
    cardsModal.id = json["id"];
    cardsModal.unloadingPoint = json["unloadingPoint"];
    cardsModal.unloadingPointCity = json["unloadingPointCity"];
    cardsModal.unloadingPointState = json["unloadingPointState"];
    cardsModal.productType = json["productType"];
    cardsModal.truckType = json["truckType"];
    cardsModal.noOfTrucks = json["noOfTrucks"];
    cardsModal.weight = json["weight"];
    cardsModal.comment = json["comment"];
    cardsModal.status = json["status"];
    cardsModal.date = json["date"];
    data.add(cardsModal);
  }
  return data.reversed
      .toList(); //TODO: remove reversed when database is cleared
}
