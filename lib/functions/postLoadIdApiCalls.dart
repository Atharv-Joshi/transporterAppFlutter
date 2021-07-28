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
      'companyName': jsonData['companyName'] != null ? jsonData['companyName'] : 'NA',
      'posterPhoneNum': jsonData['phoneNo'] != null ? jsonData['phoneNo'] : 'NA',
      'posterName': jsonData['transporterName'] != null ? jsonData['transporterName'] : 'NA',
      "posterLocation": jsonData['transporterLocation']  != null ? jsonData['transporterLocation'] : 'NA',
      "companyApproved": jsonData['companyApproved'] != null ? jsonData['companyApproved'] :false,
    };
    // print("transporterData-$transporterData");

    return transporterData;
  }

  Future<Map> getDataByShipperId(String shipperId) async {
    http.Response response =
        await http.get(Uri.parse('$shipperApiUrl/$shipperId'));
    var jsonData = json.decode(response.body);

    // Map transporterData = jsonData['companyName'];

    Map shipperData = {
      'companyName': jsonData['companyName'] != null ? jsonData['companyName'] : 'NA',
      'posterPhoneNum': jsonData['phoneNo'] != null ? jsonData['phoneNo'] : 'NA',
      'posterName': jsonData['shipperName'] != null ? jsonData['shipperName'] : 'NA',
      "posterLocation": jsonData['shipperLocation'] != null ? jsonData['shipperLocation'] : 'NA',
      "companyApproved": jsonData['companyApproved'] != null ? jsonData['companyApproved'] : false,
    };

    return shipperData;
  }
}
