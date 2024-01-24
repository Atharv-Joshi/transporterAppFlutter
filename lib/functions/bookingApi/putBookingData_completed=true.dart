import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//Put booking apis to update the booking status completed = true
Future<String> updateBookingId({
  required String? bookingId,
}) async {
  final String bookingApiUrl = dotenv.get('bookingApiUrl').toString();
  final String apiUrl = '$bookingApiUrl/$bookingId';

  final Map<String, dynamic> requestBody = {"completed": true};

  final response = await http.put(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    print('Booking updated successfully');
    return response.body;
  } else {
    print('Failed to update booking. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return "API Request Failed";
  }
}
