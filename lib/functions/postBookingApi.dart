import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/controller/transporterIdController.dart';

postBookingApi(loadId, rate, unit, truckId, postLoadId,
    BuildContext context) async {
  TransporterIdController tIdController =
  Get.find<TransporterIdController>();
  String now = DateFormat("dd-MM-yyyy").format(DateTime.now());

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
  var jsonData = json.decode(response.body);

  for (var json in jsonData) {
    print(json["bookingId"]);
    // ignore: unnecessary_null_comparison
    if (json["bookingId"].toString() != null ||
        json["bookingId"].toString() != "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful')),
      );
    }
  }
}
