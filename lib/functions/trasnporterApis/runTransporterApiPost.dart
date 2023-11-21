import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/traccarCalls/createTraccarUserAndNotifications.dart';

GetStorage tidstorage = GetStorage('TransporterIDStorage');

Future<String?> runTransporterApiPost(
    {required String mobileNum, String? userLocation}) async {
  try {
    print("-------------RUNNING runTransporterApiPost function-----------------");
    print("${mobileNum}-------------------------------");

    // var mUser = FirebaseAuth.instance.currentUser;
    // String? firebaseToken;
    // print("$mUser ------------USER---");
    // print("${mUser?.getIdToken(true)}-------BBB--");
    // await mUser!.getIdToken(true).then((value) {
    //   print("$value-----value-----");
    //   firebaseToken = value;
    // });

    TransporterIdController transporterIdController =
    Get.put(TransporterIdController(), permanent: true);
    print(transporterIdController.transporterId + "----------------------------");

    final String transporterApiUrl = dotenv.get('transporterApiUrl');

    Map data = userLocation != null
        ? {"phoneNo": mobileNum, "transporterLocation": userLocation}
        : {"phoneNo": mobileNum};
    String body = json.encode(data);
    final response = await http.post(Uri.parse(transporterApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // HttpHeaders.authorizationHeader: firebaseToken!
        },
        body: body);

    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        log("firebase registration token =========> " + value);
      }
      createTraccarUserAndNotifications(value, mobileNum);
    });

    if (response.statusCode == 201) {
      print("STATUS CODE 201 Generating transporter Body ---------------");
      var decodedResponse = json.decode(response.body);
      if (decodedResponse["transporterId"] != null) {
        String transporterId = decodedResponse["transporterId"];
        bool transporterApproved =
            decodedResponse["transporterApproved"].toString() == "true";
        bool companyApproved =
            decodedResponse["companyApproved"].toString() == "true";
        bool accountVerificationInProgress =
            decodedResponse["accountVerificationInProgress"].toString() ==
                "true";
        String transporterLocation =
        decodedResponse["transporterLocation"] == null
            ? " "
            : decodedResponse["transporterLocation"];
        String name = decodedResponse["transporterName"] == null
            ? " "
            : decodedResponse["transporterName"];
        String companyName = decodedResponse["companyName"] == null
            ? " "
            : decodedResponse["companyName"];
        transporterIdController.updateTransporterId(transporterId);
        tidstorage
            .write("transporterId", transporterId)
            .then((value) => print("Written transporterId"));
        transporterIdController.updateTransporterApproved(transporterApproved);
        tidstorage
            .write("transporterApproved", transporterApproved)
            .then((value) => print("Written transporterApproved"));
        transporterIdController.updateCompanyApproved(companyApproved);
        tidstorage
            .write("companyApproved", companyApproved)
            .then((value) => print("Written companyApproved"));
        transporterIdController.updateMobileNum(mobileNum);
        tidstorage
            .write("mobileNum", mobileNum)
            .then((value) => print("Written mobileNum"));
        transporterIdController
            .updateAccountVerificationInProgress(accountVerificationInProgress);
        tidstorage
            .write(
            "accountVerificationInProgress", accountVerificationInProgress)
            .then((value) => print("Written accountVerificationInProgress"));
        transporterIdController.updateTransporterLocation(transporterLocation);
        tidstorage
            .write("transporterLocation", transporterLocation)
            .then((value) => print("Written transporterLocation"));
        transporterIdController.updateName(name);
        tidstorage.write("name", name).then((value) => print("Written name"));
        transporterIdController.updateCompanyName(companyName);
        tidstorage
            .write("companyName", companyName)
            .then((value) => print("Written companyName"));
        if (decodedResponse["token"] != null) {
          transporterIdController
              .updateJmtToken(decodedResponse["token"].toString());
        }
        return transporterId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
