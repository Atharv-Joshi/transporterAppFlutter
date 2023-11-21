import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// These apis are used to find the operator of particular mobile number
Future<Map<String, dynamic>> validateMobileNumber(
    {String? mobileNumber}) async {
  final String numVerifyApiUrl =
      dotenv.get('numVerifyApiUrl').toString();
  final String accessKey = dotenv.get('accessKey').toString();
  final String countryCode = "IN";
  final String format = "0";
  final String numAPI =
      "$numVerifyApiUrl?access_key=$accessKey&number=$mobileNumber&country_code=$countryCode&format=$format";
  final response = await http.post(
    Uri.parse(numAPI),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> result = json.decode(response.body);
    print(response.body);
    return result;
  } else {
    throw "Failed to validate mobile number. Status code: ${response.statusCode}";
  }
}
