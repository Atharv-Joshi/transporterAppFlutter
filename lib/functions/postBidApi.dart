import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

postBidAPi(loadId, rate, transporterIdController, unit) async {
  if (unit == "RadioButtonOptions.PER_TON") {
    unit = "PER_TON";
  }
  if (unit == "RadioButtonOptions.PER_TRUCK") {
    unit = "PER_TRUCK";
  }
  Map data = {
    "transporterId": transporterIdController,
    "loadId": loadId,
    "rate": rate,
    "unitValue": unit
  };
  String body = json.encode(data);
  final String bidApiUrl = FlutterConfig.get('bidApiUrl').toString();
  final response = await http.post(Uri.parse("$bidApiUrl"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
}
