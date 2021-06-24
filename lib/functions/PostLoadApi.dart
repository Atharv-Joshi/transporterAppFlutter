import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class LoadApi {
  postLoadAPi(
      loadDate,
      postLoadId,
      loadingPoint,
      loadingPointCity,
      loadingPointState,
      noOfTrucks,
      productType,
      truckType,
      unloadingPoint,
      unloadingPointCity,
      unloadingPointState,
      weight,
      unitValue,
      rate) async {
    Map data = {
      "loadDate": loadDate,
      "postLoadId": postLoadId,
      "loadingPoint": loadingPoint,
      "loadingPointCity": loadingPointCity,
      "loadingPointState": loadingPointState,
      "noOfTrucks": noOfTrucks,
      "productType": productType,
      "truckType": truckType,
      "unloadingPoint": unloadingPoint,
      "unloadingPointCity": unloadingPointCity,
      "unloadingPointState": unloadingPointState,
      "weight": weight,
      "unitValue": unitValue,
      "rate": rate
    };
    String body = json.encode(data);
    var jsonData;
    final String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
    final response = await http.post(Uri.parse(loadApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    jsonData = json.decode(response.body);

    print(jsonData);
  }
}
