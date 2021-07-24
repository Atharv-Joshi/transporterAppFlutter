import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class PostLoadIdApiCalls {
  final String transporterApiUrl = FlutterConfig.get("transporterApiUrl");
  final String shipperApiUrl = FlutterConfig.get("shipperApiUrl");

  Future<Map> getDataByTransporterId(String transporterId) async {
    http.Response response =
        await http.get(Uri.parse('$transporterApiUrl/$transporterId'));
    var jsonData = json.decode(response.body);

    // Map transporterData = jsonData['companyName'];

    Map transporterData = {
      'companyName': jsonData['companyName'],
      'posterPhoneNum': jsonData['phoneNo'].toString(),
      'posterName': jsonData['transporterName'],
      "posterLocation": jsonData['transporterLocation'],
      "companyApproved": jsonData['companyApproved']
    };
    print("transporterData-$transporterData");

    return transporterData;
  }

  Future<Map> getDataByShipperId(String shipperId) async {
    http.Response response =
        await http.get(Uri.parse('$shipperApiUrl/$shipperId'));
    var jsonData = json.decode(response.body);

    // Map transporterData = jsonData['companyName'];

    Map shipperData = {
      'companyName': jsonData['companyName'],
      'posterPhoneNum': jsonData['phoneNo'].toString(),
      'posterName': jsonData['shipperName'],
      "posterLocation": jsonData['shipperLocation'],
      "companyApproved": jsonData['companyApproved']
    };

    return shipperData;
  }
}
