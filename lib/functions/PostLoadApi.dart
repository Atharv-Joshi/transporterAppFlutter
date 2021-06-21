import 'dart:convert';
import 'package:http/http.dart' as http;

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
      weight) async {
    print(loadDate);
    print(postLoadId);
    print(loadingPoint);
    print(loadingPointCity);
    print(noOfTrucks);
    print(productType);
    print(truckType);
    print(unloadingPoint);
    print(unloadingPointCity);
    print(unloadingPointState);
    print(loadingPointState);

    Map data = {
      "loadDate": loadDate,
      "postLoadId": postLoadId,
      "loadingPoint": loadingPoint,
      "loadingPointCity": loadingPointCity,
      "loadingPointState": loadingPointState,
      "noOfTrucks": noOfTrucks,
      "productType": productType,
      "status": "On-going",
      "truckType": truckType,
      "unloadingPoint": unloadingPoint,
      "unloadingPointCity": unloadingPointCity,
      "unloadingPointState": unloadingPointState,
      "weight": weight
    };
    String body = json.encode(data);
    var jsonData;

    final response = await http.post(Uri.parse("http://65.0.19.187:8080/load"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    jsonData = json.decode(response.body);

    print(jsonData);
  }
}
