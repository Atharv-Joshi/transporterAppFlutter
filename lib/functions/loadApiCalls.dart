import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadApiModel.dart';

class LoadApiCalls {
  List<LoadApiModel> loadList = [];

  final String loadApiUrl = FlutterConfig.get("loadApiUrl");

  Future<Map> getDataByLoadId(String loadId) async {
    print('in get data by load id');
    http.Response response = await http.get(Uri.parse('$loadApiUrl/$loadId'));
    print(response.body);
    var jsonData = json.decode(response.body);
    print(jsonData);
    Map data = {
      'loadingPointCity': jsonData['loadingPointCity'] != null
          ? jsonData['loadingPointCity']
          : 'NA',
      'unloadingPointCity': jsonData['unloadingPointCity'] != null
          ? jsonData['unloadingPointCity']
          : 'NA',
    };
    print(data);
    print('getDataByLoadId out');
    return data;
  }

  Future<List<LoadApiModel>> getDataByPostLoadId(String postLoadId) async {
    http.Response response =
        await http.get(Uri.parse('$loadApiUrl?postLoadId=$postLoadId'));
    var jsonData = json.decode(response.body);

    for (var json in jsonData) {
      LoadApiModel loadScreenCardsModel = LoadApiModel();
      loadScreenCardsModel.loadId = json['loadId'];
      loadScreenCardsModel.loadingPointCity = json['loadingPointCity'];
      loadScreenCardsModel.unloadingPointCity = json['unloadingPointCity'];
      loadScreenCardsModel.truckType = json['truckType'];
      loadScreenCardsModel.weight = json['weight'];
      loadScreenCardsModel.productType = json['productType'];
      loadList.add(loadScreenCardsModel);
    }
    return loadList;
  }
} //class end
