import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/controller/transporterIdController.dart';

void runTransporterApiPost(
    {required String mobileNum, String? userLocation}) async {
  TransporterIdController transporterIdController =
      Get.put(TransporterIdController());

  final String transporterApiUrl =
      FlutterConfig.get("transporterApiUrl").toString();
  Map data = userLocation != null
      ? {"phoneNo": mobileNum, "transporterLocation": userLocation}
      : {"phoneNo": mobileNum};
  String body = json.encode(data);
  final response = await http.post(Uri.parse(transporterApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  if (response.statusCode == 200) {
    print(response.body);
    var decodedResponse = json.decode(response.body);
    String transporterId = decodedResponse["transporterId"];
    bool transporterApproved =
        decodedResponse["transporterApproved"].toString() == "true";
    bool companyApproved =
        decodedResponse["companyApproved"].toString() == "true";
    bool accountVerificationInProgress =
        decodedResponse["accountVerificationInProgress"].toString() == "true";
    String transporterLocation = decodedResponse["transporterLocation"];
    String name = decodedResponse["transporterName"];
    String companyName = decodedResponse["companyName"];
    transporterIdController.updateTransporterId(transporterId);
    transporterIdController.updateTransporterApproved(transporterApproved);
    transporterIdController.updateCompanyApproved(companyApproved);
    transporterIdController.updateMobileNum(mobileNum);
    transporterIdController
        .updateAccountVerificationInProgress(accountVerificationInProgress);
    transporterIdController.updateTransporterLocation(transporterLocation);
    transporterIdController.updateName(name);
    transporterIdController.updateCompanyName(companyName);
  }
}
