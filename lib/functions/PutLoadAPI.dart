import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:liveasy/controller/postLoadErrorController.dart';
import 'package:flutter_config/flutter_config.dart';

Future<String?> putLoadAPI(
    loadId,
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
  PostLoadErrorController postLoadErrorController =
  Get.put(PostLoadErrorController());
  try {
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

    final String loadApiUrl = FlutterConfig.get('loadApiUrl').toString();
    final response = await http.put(Uri.parse("$loadApiUrl/$loadId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonData["loadId"] != null) {
        String loadId = jsonData["loadId"];
        return loadId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    postLoadErrorController.updatePostLoadError(e.toString());
    return null;
  }
}
