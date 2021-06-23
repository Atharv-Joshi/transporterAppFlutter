import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:flutter_config/flutter_config.dart';

class TransporterApiCalls{

  final String transporterApiUrl =  FlutterConfig.get("transporterApiUrl");

  Future<Map> getDataByTransporterId(String transporterId) async  {
    http.Response response = await http.get(Uri.parse('$transporterApiUrl/$transporterId'));
    var jsonData = json.decode(response.body);

    // Map transporterData = jsonData['companyName'];

    Map transporterData = {
      'companyName' : jsonData['companyName'],
      'transporterPhoneNum' : jsonData['phoneNo'].toString(),
      'transporterName' : jsonData['transporterName']
    };

    return transporterData;
  }
}