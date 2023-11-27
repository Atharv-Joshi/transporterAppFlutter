import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';

TransporterIdController transporterIdController =
    Get.find<TransporterIdController>();
final String driverApiUrl = dotenv.get('driverApiUrl');
String? traccarUser = transporterIdController.mobileNum.value;
String traccarPass = dotenv.get("traccarPass");
String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
late List jsonData;
late List driverList;

getDriverData() async {
  http.Response response = await http.get(
    Uri.parse("$driverApiUrl/api/drivers"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': basicAuth,
    },
  );
  jsonData = await jsonDecode(response.body);
  for (var json in jsonData) {
    driverList.add(json);
  }
}
