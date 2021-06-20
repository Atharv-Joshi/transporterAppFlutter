import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

Future<String> postAccountVerificationDocuments(
    {File? profilePhoto,
    File? panFront,
    File? panBack,
    File? addressProof,
    File? companyIdProof}) async {
  try {
    final String documentApiUrl =
        FlutterConfig.get("documentApiUrl").toString();
    Map data = {};
    String body = json.encode(data);

    final response = await http.post(Uri.parse(documentApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      return "Error";
    }
  } catch (e) {
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
  }
  return "Success";
}
