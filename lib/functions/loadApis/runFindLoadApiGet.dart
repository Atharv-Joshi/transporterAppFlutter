import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadApiModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<LoadApiModel>> runFindLoadApiGet(
    String loadingPointCity, String unloadingPointCity) async {
  String additionalQuery = "";
  if (loadingPointCity != "" && unloadingPointCity != "") {
    additionalQuery =
        "?unloadingPointCity=$unloadingPointCity&loadingPointCity=$loadingPointCity";
  } else if (loadingPointCity != "") {
    additionalQuery = "?loadingPointCity=$loadingPointCity";
  } else if (unloadingPointCity != "") {
    additionalQuery = "?unloadingPointCity=$unloadingPointCity";
  } else if (loadingPointCity == "" && unloadingPointCity == "") {
    additionalQuery = "";
  }

  var jsonData;
  List<LoadApiModel> card = [];

  final String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  http.Response response =
      await http.get(Uri.parse("$loadApiUrl$additionalQuery"));

  jsonData = json.decode(response.body);
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
    card.add(cardsModal);
  }
  return card;
}
