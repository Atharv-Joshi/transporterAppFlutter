import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liveasy/functions/googleAutoCorrectionApi.dart';
import 'package:liveasy/models/autoFillMMIModel.dart';
import '../googleAutoCorrectionApi.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

String kGoogleApiKey = dotenv.get('mapKey').toString();

Future<List<AutoFillMMIModel>> fillCityGoogle(
    String cityName, Position position) async {
  var request = http.Request(
      'GET',
      Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=$cityName&location=${position.latitude},${position.longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey'));

  http.StreamedResponse response = await request.send();
  List<AutoFillMMIModel> card = [];
  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    var res = await response.stream.bytesToString();
    var address = json.decode(res);
    address = address["predictions"];
    //print(address);
    for (var json in address) {
      print(json["description"]);
      List<String> result = json["description"]!.split(",");
      //print(result);
      int resultLength = 0;
      for (var r in result) {
        resultLength++;
        r = r.trimLeft();
        r = r.trimRight();
        //print(r);
      }
      if (resultLength == 2) {
        AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
            placeName: "${result[0].toString()}",
            placeCityName: "${result[0].toString()}",
            // placeStateName: json["placeAddress"]\
            placeStateName: "${result[0].toString()}");
        card.add(locationCardsModal);
      } else if (resultLength == 3) {
        AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
            placeName: "${result[0].toString()}",
            placeCityName: "${result[0].toString()}",
            // placeStateName: json["placeAddress"]\
            placeStateName: "${result[1].toString()}");
        card.add(locationCardsModal);
      } else {
        AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
            placeName: "${result[0].toString()}",
            addresscomponent1: "${result[1].toString()}",
            placeCityName: "${result[resultLength - 3].toString()}",
            // placeStateName: json["placeAddress"]\
            placeStateName: "${result[resultLength - 2].toString()}");
        card.add(locationCardsModal);
        print(card[0]);
      }
    }
    return card;
  } else {
    List<AutoFillMMIModel> card = [];
    return card;
  }
}
