import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

// These apis are used to find the operator of particular mobile number
Future<Map<String, dynamic>> validateMobileNumber(
    {String? mobileNumber}) async {
  final String numVerifyApiUrl =
      FlutterConfig.get('numVerifyApiUrl').toString();
  final String accessKey = FlutterConfig.get('accessKey').toString();
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
