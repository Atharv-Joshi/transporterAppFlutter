import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadDataModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<LoadDataModel>> runSuggestedLoadApi() async {
  String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
  var jsonData;
  Uri url = Uri.parse("$loadApiUrl");
  http.Response response = await http.get(url);
  jsonData = await jsonDecode(response.body);
  List<LoadDataModel> data = [];
  for (var json in jsonData) {
    LoadDataModel loadData = new LoadDataModel(
        ownerId: "",
        id: "",
        loadingPointCity: json["loadingPoint"],
        loadingPointState: "",
        unloadingPointCity: json["unloadingPoint"],
        truckType: "",
        noOfTrucks: "",
        status: "",
        unloadingPointState: "",
        weight: "",
        productType: "",
        comment: "");
    data.add(loadData);
  }
  return data;
}
