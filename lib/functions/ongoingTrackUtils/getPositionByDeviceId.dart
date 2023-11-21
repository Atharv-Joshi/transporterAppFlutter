import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/language/localization_service.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<GpsDataModel>> getPositionByDeviceId(String deviceId) async {
  String? current_lang;
  String traccarUser = dotenv.get("traccarUser");
  String traccarPass = dotenv.get("traccarPass");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
  String traccarApi = dotenv.get("traccarApi");

  try {
    http.Response response = await http.get(
        Uri.parse("$traccarApi/positions?deviceId=$deviceId"),
        headers: <String, String>{
          'Authorization': basicAuth,
          'Accept': 'application/json'
        });
    print(response.statusCode);
    print(response.body);
    var jsonData = await jsonDecode(response.body);
    print("Positions BODY IS${response.body}");
    List<GpsDataModel> LatLongList = [];
    if (response.statusCode == 200) {
      for (var json in jsonData) {
        GpsDataModel gpsDataModel = new GpsDataModel();
        // gpsDataModel.id = json["id"] != null ? json["id"] : 'NA';
        gpsDataModel.deviceId =
            json["deviceId"] != null ? json["deviceId"] : 'NA';
        gpsDataModel.rssi = json["attributes"]["rssi"] != null
            ? json["attributes"]["rssi"]
            : -1;
        gpsDataModel.result = json["attributes"]["result"] != null
            ? json["attributes"]["result"]
            : 'NA';
        gpsDataModel.latitude = json["latitude"] != null ? json["latitude"] : 0;
        gpsDataModel.longitude =
            json["longitude"] != null ? json["longitude"] : 0;
        print(
            "LAT : ${gpsDataModel.latitude}, LONG : ${gpsDataModel.longitude} ");
        gpsDataModel.distance = json["attributes"]["totalDistance"] != null
            ? json["attributes"]["totalDistance"]
            : 0;
        gpsDataModel.motion = json["attributes"]["motion"] != null
            ? json["attributes"]["motion"]
            : false;
        print("Motion : ${gpsDataModel.motion}");
        gpsDataModel.ignition = json["attributes"]["ignition"] != null
            ? json["attributes"]["ignition"]
            : false;
        gpsDataModel.speed =
            json["speed"] != null ? json["speed"] * 1.85 : 'NA';
        gpsDataModel.course = json["course"] != null ? json["course"] : 'NA';
        gpsDataModel.deviceTime =
            json["deviceTime"] != null ? json["deviceTime"] : 'NA';
        gpsDataModel.serverTime =
            json["serverTime"] != null ? json["serverTime"] : 'NA';
        gpsDataModel.fixTime = json["fixTime"] != null ? json["fixTime"] : 'NA';
        //   gpsDataModel.attributes = json["fixTime"] != null ? json["fixTime"] : 'NA';
        var latn = gpsDataModel.latitude =
            json["latitude"] != null ? json["latitude"] : 0;
        var lngn = gpsDataModel.longitude =
            json["longitude"] != null ? json["longitude"] : 0;
        String? addressstring;
        try {
          List<Placemark> newPlace;
          current_lang = LocalizationService().getCurrentLang();
          if (current_lang == 'Hindi') {
            newPlace = await placemarkFromCoordinates(latn, lngn,
                localeIdentifier: "hi_IN");
          } else {
            newPlace = await placemarkFromCoordinates(latn, lngn,
                localeIdentifier: "en_US");
          }
          var first = newPlace.first;

          if (first.subLocality == "")
            addressstring =
                " ${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
          else if (first.locality == "")
            addressstring =
                "${first.street}, ${first.subLocality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
          else if (first.administrativeArea == "")
            addressstring =
                "${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}";
          else
            addressstring =
                "${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
          print("ADD $addressstring");
        } catch (e) {
          print(e);

          addressstring = "";
        }
        gpsDataModel.address = "$addressstring";
        LatLongList.add(gpsDataModel);
      }
      return LatLongList;
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
