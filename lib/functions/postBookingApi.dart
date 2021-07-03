import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/controller/transporterIdController.dart';

postBookingApi(
    loadId, rate, unit, truckId, postLoadId, BuildContext context) async {
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  var jsonData;
  Map data = {
    "loadId": loadId,
    "rate": rate,
    "transporterId": tIdController.transporterId.toString(),
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
  print(response.body);
  jsonData = json.decode(response.body);

  if (jsonData["bookingId"] != null) {
    Get.snackbar('Booking Successful', '', snackPosition: SnackPosition.TOP);
  } else
    Get.snackbar('Booking Unsuccessful', '', snackPosition: SnackPosition.TOP);
}
