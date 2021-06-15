import 'dart:convert';
import 'package:http/http.dart' as http;

postBookingApi(loadId, rate, transporterId, unit, truckId) async {
  Map data = {
    "loadId": loadId,
    "rate": rate,
    "transporterId": transporterId,
    "unit": unit,
    "truckId": truckId
  };
  String body = json.encode(data);
  print(body);
  final response = await http.post(
      Uri.parse(
          "http://ec2-3-7-133-111.ap-south-1.compute.amazonaws.com:8090/booking"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  print(response.body);
}
