import 'dart:convert';
import 'package:http/http.dart' as http;

postDriverApi(driverName,phoneNum,transporterId,truckId) async {
  Map data = {
    "driverName": driverName,
    "phoneNum": phoneNum,
    "transporterId": transporterId,
    "truckId": truckId
  };
  String body = json.encode(data);
  print(body);
  final response = await http.post(
      Uri.parse(
          "http://ec2-15-207-113-71.ap-south-1.compute.amazonaws.com:9080/driver"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  print(response.body);
}
