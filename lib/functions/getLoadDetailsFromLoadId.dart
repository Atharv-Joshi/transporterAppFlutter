import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadDetailsScreenModel.dart';

getLoadDetailsFromLoadId(loadId) async {
  //canm be deleted later
  var jsonData;
  final String loadApiUrl = dotenv.get("loadApiUrl").toString();
  http.Response response = await http.get(Uri.parse("$loadApiUrl/$loadId"));
  try {
    jsonData = json.decode(response.body);

    LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
    loadDetailsScreenModel.loadId = jsonData["loadId"].toString();
    loadDetailsScreenModel.loadingPoint = jsonData["loadingPoint"].toString();
    loadDetailsScreenModel.loadingPointCity =
        jsonData["loadingPointCity"].toString();
    loadDetailsScreenModel.loadingPointState =
        jsonData["loadingPointState"].toString();
    loadDetailsScreenModel.postLoadId = jsonData["postLoadId"].toString();
    loadDetailsScreenModel.unloadingPoint =
        jsonData["unloadingPoint"].toString();
    loadDetailsScreenModel.unloadingPointCity =
        jsonData["unloadingPointCity"].toString();
    loadDetailsScreenModel.unloadingPointState =
        jsonData["unloadingPointState"].toString();
    loadDetailsScreenModel.productType = jsonData["productType"].toString();
    loadDetailsScreenModel.truckType = jsonData["truckType"].toString();
    loadDetailsScreenModel.noOfTyres = jsonData["noOfTyres"].toString();
    loadDetailsScreenModel.weight = jsonData["weight"].toString();
    loadDetailsScreenModel.comment = jsonData["comment"].toString();
    loadDetailsScreenModel.status = jsonData["status"].toString();
    loadDetailsScreenModel.loadDate = jsonData["loadDate"].toString();
    loadDetailsScreenModel.rate = jsonData["rate"];
    loadDetailsScreenModel.unitValue = jsonData["unitValue"].toString();
    return loadDetailsScreenModel;
  } catch (e) {
    print(e);
  }
}
