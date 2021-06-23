import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';

postBookingApi(loadId, rate, transporterId, unit, truckId, postLoadId) async {
  String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  Map data = {
    "loadId": loadId,
    "rate": rate,
    "transporterId": transporterId,
    "unitValue": unit,
    "truckId": truckId,
    "postLoadId": postLoadId,
    "bookingDate": now
  };
  String body = json.encode(data);
  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl').toString();
  final response = await http.post(Uri.parse("$bookingApiUrl"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
}
