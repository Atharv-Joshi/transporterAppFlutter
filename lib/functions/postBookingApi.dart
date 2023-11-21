import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

postBookingApi(loadId, currentBid, unit, truckId, postLoadId, rate) async {
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  var jsonData;
  try {
    Map data = {
      "loadId": loadId,
      "transporterId": tIdController.transporterId.toString(),
      "truckId": [truckId],
      "postLoadId": postLoadId,
      "bookingDate": now,
      "rate": rate == "NA" ? null : rate,
      "unitValue": rate == "NA" ? null : unit
    };
    String body = json.encode(data);
    final String bookingApiUrl = dotenv.get('bookingApiUrl').toString();
    final response = await http.post(Uri.parse("$bookingApiUrl"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    print(response.body);
    jsonData = json.decode(response.body);

    // if (jsonData["bookingId"] != null) {
    //   Get.snackbar('Booking Successful', '', snackPosition: SnackPosition.TOP);
    // } else
    //   Get.snackbar('Booking Unsuccessful', '',
    //       snackPosition: SnackPosition.TOP);
    if (response.statusCode == 201) {
      return "successful";
    } else if (response.statusCode == 409) {
      print("conflict");
      return "conflict";
    } else {
      return "unsuccessful";
    }
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
