import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/onGoingCardModel.dart';

//Pu tbooking apis to update the truckNo, driverPhoneNo and driverName
Future<String> updateBooking({
  required String? truckId,
  required int? selectedDeviceId,
  required String? selectedDriverName,
  required String? selectedDriverPhoneno,
  required String? bookingId,
  required OngoingCardModel loadAllDataModel,
}) async {
  final String bookingApiUrl = dotenv.get('bookingApiUrl').toString();
  final String apiUrl = '$bookingApiUrl/$bookingId';

  final Map<String, dynamic> requestBody = {
    "truckNo": truckId,
    "driverName": selectedDriverName,
    "driverPhoneNum": selectedDriverPhoneno,
    "truckId": [truckId],
    "deviceId": selectedDeviceId,
  };

  final response = await http.put(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    print('Booking updated successfully');
    loadAllDataModel.bookingId = bookingId;
    loadAllDataModel.truckNo = truckId;
    loadAllDataModel.driverName = selectedDriverName;
    loadAllDataModel.driverPhoneNum = selectedDriverPhoneno;
    loadAllDataModel.deviceId = selectedDeviceId;
    return response.body;
  } else {
    print('Failed to update booking. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return "API Request Failed";
  }
}
