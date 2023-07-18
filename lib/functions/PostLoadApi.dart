import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:liveasy/constants/urlGetter.dart';
import 'package:liveasy/controller/postLoadErrorController.dart';
import 'package:flutter_config/flutter_config.dart';

Future<String?> postLoadAPi(
    loadDate,
    postLoadId,
    loadingPoint,
    loadingPointCity,
    loadingPointState,
    loadingPoint2,
    loadingPointCity2,
    loadingPointState2,
    noOfTyre,
    productType,
    truckType,
    unloadingPoint,
    unloadingPointCity,
    unloadingPointState,
    unloadingPoint2,
    unloadingPointCity2,
    unloadingPointState2,
    weight,
    unitValue,
    rate) async {
  PostLoadErrorController postLoadErrorController =
  Get.put(PostLoadErrorController());

  // Changing unit_Values in the string the way it's accepted by API
  String? unit_value;
  if (unitValue == "Per Ton") {
    unit_value = "PER_TON";
  }
  if (unitValue == "Per Truck") {
    unit_value = "PER_TRUCK";
  }


  try {
    Map data = {
      "loadDate": loadDate,
      "postLoadId": postLoadId,
      "loadingPoint": loadingPoint,
      "loadingPointCity": loadingPointCity,
      "loadingPointState": loadingPointState,
      "loadingPoint2": loadingPoint2,
      "loadingPointCity2":loadingPointCity2,
      "loadingPointState2":loadingPointState2,
      "noOfTyres": noOfTyre,
      "productType": productType,
      "truckType": truckType,
      "unloadingPoint": unloadingPoint,
      "unloadingPointCity": unloadingPointCity,
      "unloadingPointState": unloadingPointState,
      "unloadingPoint2":unloadingPoint2,
      "unloadingPointCity2":unloadingPointCity2,
      "unloadingPointState2":unloadingPointState2,
      "weight": weight,
      "unitValue": unit_value,
      "rate": rate
    };
    String body = json.encode(data);
    var jsonData;

    String loadApiUrl = await UrlGetter.get('loadApiUrl');

    print(body + "----------------------------------");

    final response = await http.post(Uri.parse(loadApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    jsonData = json.decode(response.body);

    if (response.statusCode == 201) {
      print("LOAD API Response-->$jsonData");
      if (jsonData["loadId"] != null) {
        String loadId = jsonData["loadId"];
        return loadId;
      } else {
        return null;
      }
    } else {
      print(response.statusCode);
      return null;
    }
  } catch (e) {
    postLoadErrorController.updatePostLoadError(e.toString());
    print(e.toString());
    return null;
  }
}
