import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

postDocumentApiCall(Map datanew2) async {
  // TransporterIdController tIdController = Get.find<TransporterIdController>();
  // String now = DateFormat("dd-MM-yyyy").format(DateTime.now());
  // String now = DateFormat("dd-MM-yyyy").format(DateTime.now().subtract(Duration(hours: 5, minutes: 30))
  //     .toIso8601String());
  var jsonData;
  try {
    // Map datanew = {
    //   "entityId": bookingId,
    //   "documents": [
    //     {"documentType": documentType, "data": photo64code}
    //   ],
    // };
    // print(datanew2);
    String body = json.encode(datanew2);
    final String documentApiUrl = dotenv.get('documentApiUrl').toString();
    final response = await http.post(Uri.parse("$documentApiUrl"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    // print(response.body);
    jsonData = json.decode(response.body);

    // if (jsonData["bookingId"] != null) {
    //   Get.snackbar('Booking Successful', '', snackPosition: SnackPosition.TOP);
    // } else
    //   Get.snackbar('Booking Unsuccessful', '',
    //       snackPosition: SnackPosition.TOP);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print(response);
      return "successful";
    } else if (response.statusCode == 409) {
      print("conflict");
      return "conflict";
    } else if (response.statusCode == 422) {
      print("already exist");
      return "put";
    } else {
      return "unsuccessful";
    }
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
