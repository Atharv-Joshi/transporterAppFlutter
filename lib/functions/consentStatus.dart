import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// To know the status of the apis this function is used.
class StatusAPI {
  Future<String> getStatus(String driverPhoneNum) async {
    final String consentStatus = dotenv.get('consentStatusUrl').toString();

    final response = await http.get(Uri.parse('$consentStatus$driverPhoneNum'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      final responseStatus = data['status'];
      return responseStatus;
    } else {
      return 'Error';
    }
  }
}
