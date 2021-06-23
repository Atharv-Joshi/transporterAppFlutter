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
  try {
    for (var json in jsonData) {
      LoadApiModel cardsModal = LoadApiModel();
      cardsModal.loadId = json["loadId"].toString();
      cardsModal.loadingPoint = json["loadingPoint"].toString();
      cardsModal.loadingPointCity = json["loadingPointCity"].toString();
      cardsModal.loadingPointState = json["loadingPointState"].toString();
      cardsModal.postLoadId = json["postLoadId"].toString();
      cardsModal.unloadingPoint = json["unloadingPoint"].toString();
      cardsModal.unloadingPointCity = json["unloadingPointCity"].toString();
      cardsModal.unloadingPointState = json["unloadingPointState"].toString();
      cardsModal.productType = json["productType"].toString();
      cardsModal.truckType = json["truckType"].toString();
      cardsModal.noOfTrucks = json["noOfTrucks"].toString();
      cardsModal.weight = json["weight"].toString();
      cardsModal.comment = json["comment"].toString();
      cardsModal.status = json["status"].toString();
      cardsModal.loadDate = json["loadDate"].toString();
      cardsModal.rate = json["rate"].toString();
      cardsModal.unitValue = json["unitValue"].toString();
      card.add(cardsModal);
    }
  } catch (e) {
    print(e);
  }
  return card;
}
