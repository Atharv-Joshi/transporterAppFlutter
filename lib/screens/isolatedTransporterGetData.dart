import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/functions/traccarCalls/createTraccarUserAndNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';


TransporterIdController transporterIdController =
    Get.put(TransporterIdController(), permanent: true);
bool exe = true;

int count = 0;

late Timer timer;

isolatedTransporterGetData() {
  exe = true;
  timer = Timer.periodic(
      Duration(seconds: 15), (Timer t) => exe ? apirun2() : timer.cancel());
}


Future<dynamic> apirun2() async {
  var response = await runTransporterApiPostIsolated(
      mobileNum: transporterIdController.mobileNum.value);
  count = count + 1;
  print(count);
  print("response = ");
  print(response);
  if (response != null ||
      count == 5 ||
      FirebaseAuth.instance.currentUser == null) {
    // setState(() {
    exe = false;
    // });
  }

  return response;
}

GetStorage tidstorage = GetStorage('TransporterIDStorage');

Future<String?> runTransporterApiPostIsolated(
    {required String mobileNum, String? userLocation}) async {
  try {
    print("in the try block of api file");
    // var mUser = FirebaseAuth.instance.currentUser;
    // String? firebaseToken;
    // await mUser!.getIdToken(true).then((value) {
    //   // log(value);
    //   firebaseToken = value;
    // });

    TransporterIdController transporterIdController =
        Get.put(TransporterIdController(), permanent: true);

    final String transporterApiUrl =
        dotenv.get("transporterApiUrl").toString();
    Map data = userLocation != null
        ? {"phoneNo": mobileNum, "transporterLocation": userLocation}
        : {"phoneNo": mobileNum};
    String body = json.encode(data);
    print("here is api call started");
    final response = await http.post(Uri.parse(transporterApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // HttpHeaders.authorizationHeader: firebaseToken!
        },
        body: body);
    print(response.body);
    print("here api call stopped");

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseMessaging.instance.getToken().then((value) {
        if (value != null) {
          log("firebase registration token =========> " + value);
        }
        createTraccarUserAndNotifications(value, mobileNum);
      });
    }

    if (response.statusCode == 201 &&
        FirebaseAuth.instance.currentUser != null) {
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

@override
void dispose() {
  timer.cancel();
  // super.dispose();
}
