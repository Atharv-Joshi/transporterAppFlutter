import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';

//TODO:all details not fetched
Future<String> updateTransporterApi(
    {required bool accountVerificationInProgress,
     required bool transporterApproved,
    required String transporterId,required verificationType}) async {
  TransporterIdController transporterIdController =
      Get.put(TransporterIdController());
  final String transporterApiUrl =
      dotenv.get("transporterApiUrl").toString();
  Map data = verificationType=='Immediate'?{"transporterApproved": transporterApproved} :{"accountVerificationInProgress": accountVerificationInProgress};
  String body = json.encode(data);
  final response =
      await http.put(Uri.parse("$transporterApiUrl/$transporterId"),
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
    String mobileNum = decodedResponse["phoneNo"] != null
        ? decodedResponse["phoneNo"].toString()
        : "";
    transporterIdController.updateTransporterId(transporterId);
    transporterIdController.updateTransporterApproved(transporterApproved);
    transporterIdController.updateCompanyApproved(companyApproved);
    transporterIdController.updateMobileNum(mobileNum);
    transporterIdController
        .updateAccountVerificationInProgress(accountVerificationInProgress);
    if (decodedResponse["status"].toString() == "Success") {
      return "Success";
    } else {
      return "Error";
    }
  } else {
    return "Error";
  }
}
