import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

updateDriverIdInTruckApi(selectedTruckId, selectedDriverId) async {
  final String truckApiUrl = dotenv.get("truckApiUrl").toString();
  Map data = {"driverId": selectedDriverId};
  String body = json.encode(data);
  final response = await http.put(Uri.parse("$truckApiUrl/$selectedTruckId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  print(response.body);
}
