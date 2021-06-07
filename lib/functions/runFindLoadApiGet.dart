import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadApiModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<LoadScreenCardsModal>>  runFindLoadApiGet(String loadingPointCity, String unloadingPointCity) async{
  String additionalQuery = "";
  if (loadingPointCity != "" && unloadingPointCity != "") {
    additionalQuery =
    "?unloadingPointCity=$unloadingPointCity&loadingPointCity=$loadingPointCity";
  }
  else if (loadingPointCity != "")
  {
    additionalQuery = "?loadingPointCity=$loadingPointCity";
  }
  else if (unloadingPointCity != "")
  {
    additionalQuery = "?unloadingPointCity=$unloadingPointCity";
  }

  var jsonData;
  List<LoadScreenCardsModal> card = [];

  final String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$loadApiUrl$additionalQuery"));
  jsonData = json.decode(response.body);

  for (var json in jsonData) {
    LoadScreenCardsModal cardsModal = LoadScreenCardsModal();
    cardsModal.loadingPoint = json["loadingPoint"];
    cardsModal.unloadingPoint = json["unloadingPoint"];
    cardsModal.productType = json["productType"];
    cardsModal.truckType = json["truckType"];
    cardsModal.noOfTrucks = json["noOfTrucks"];
    cardsModal.weight = json["weight"];
    cardsModal.comment = json["comment"];
    cardsModal.status = json["status"];
    card.add(cardsModal);
  }
  return card;
}