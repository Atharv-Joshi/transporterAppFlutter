import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:flutter_config/flutter_config.dart';

class LoadApiCalls{

  final String loadApiUrl =  FlutterConfig.get("loadApiUrl");

  Future<Map> getDataByLoadId(String loadId) async  {
    http.Response response = await http.get(Uri.parse('$loadApiUrl/$loadId'));
    var jsonData = json.decode(response.body);

    Map data = {
      'loadingPointCity' : jsonData['loadingPointCity'],
      'unloadingPointCity' : jsonData['unloadingPointCity']
    };

    return data;
}
}