import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/functions/traccarCalls/createTraccarUserAndNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

//  String? phoneno;
// class isolateTest extends StatefulWidget {
//   // String? phoneno;
//   // isolateTest({this.phoneno});
//   @override
//   State<isolateTest> createState() => _isolateTestState();
// }

// GetStorage tidstorage = GetStorage('TransporterIDStorage');
TransporterIdController transporterIdController =
    Get.put(TransporterIdController(), permanent: true);
// // FirebaseAuth.instance.currentUser!.phoneNumber;
// String? transporterId2;
bool exe = true;
// late Timer timer;
// // String? pn;
// // late
// var response;
// Map data = {"phoneNo": mobileno};
// Map data2 = {
//   "phoneNo": "FirebaseAuth.instance.currentUser!.phoneNumber.toString()"
// };
// // late
// String body = json.encode(data2);
// late String transporterApiUrl;

// class _isolateTestState extends State<isolateTest> {
var val1;
String? pn;
int count = 0;

late Timer timer;

// @override
// void initState() {
//   super.initState();
isolatedTransporterGetData() {
  exe = true;
  timer = Timer.periodic(
      Duration(seconds: 15), (Timer t) => exe ? apirun2() : timer.cancel());
}

Future<dynamic> apiruntest() async {
  var response =
      await http.get(Uri.parse("http://load.dev.truckseasy.com:8080/load"));
  print(response);
  if (response != null) {
    exe = false;
  }
}

slp() {
  sleep(const Duration(seconds: 15));
  print("sleep over");
  exe = false;
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
    val1 = response;
    // });
  }

  return response;
  // return transporterId2.toString();
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
        FlutterConfig.get("transporterApiUrl").toString();
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

// @override
// void initState() {
//   // TODO: implement initState
//   super.initState();
// widget.phoneno
// WidgetsFlutterBinding.ensureInitialized();
// // Firebase.initializeApp();
// tidstorage = GetStorage('TransporterIDStorage');
// transporterIdController =
//     Get.put(TransporterIdController(), permanent: true);

// setState(() {
//   pn = widget.phoneno.toString();
//   data = {"phoneNo": widget.phoneno};
//   print(widget.phoneno.toString());
//   body = json.encode(data);
//   print(body);
// });
// pn = pn;

// late

// exe = true;
// transporterApiUrl = FlutterConfig.get("transporterApiUrl").toString();
// print(transporterApiUrl);
// // if (body != {"phoneNo": ""}) {
// isolatedcall();
// // res(response);
// }
// }

// Future<String?> fetchUser() async {
//   // String userData = await Api.getUser();
//   return await compute(
//       runTransporterApiPost2, transporterIdController.mobileNum.value);
// }

//   isolatedcall() async {
//     // String v = "";
//     final receivePort = ReceivePort();
// // Isolate.spawn(_isolateTestState())
//     print("isolatedcall");
//     try {
//       var resp2 = await Isolate.spawn(runTransporterApiPost2, widget.phoneno);
//       print(resp2);
//     } catch (e) {
//       print(e);
//       // ignore: unnecessary_statements
//     } finally {
//       if (response != null) print(response.body);
//     }

//     // finally(){
//     //   print(response);
//     // }
//     // (){

//     // }
//     // (
//     // sendPort: receivePort.sendPort, mobileNum: widget.phoneno),
//     // ,receivePort.sendPort
//     // );
//     // if (response != null) {
//     //   res(response);
//     // }
//     // await Isolate.spawn(await runTransporterApiPost(mobileNum: transporterIdController.mobileNum.value),receivePort.sendPort);
//     // receivePort.listen((val) {
//     //   print("val == = = = = = = = ==");
//     //   print(val);
//     //   res(val);

//     //   setState(() {
//     //     val1 = val;
//     //   });
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: val1 == null ? Text("afsdfdsf") : Text(val1.toString()));
//   }
// }

// getData(SendPort sendPort) async {
//   print("getData");

//   String? transporterId;
//   print("before api");

//   var response = await apirun();
//   // transporterId = await
//   // runTransporterApiPost2(mobileNum: transporterIdController.mobileNum.value);
//   print("updated");

//   // sendPort.send(transporterId);
//   sendPort.send(response);
// }

// Future<dynamic> apirun() async {
//   var response = await runTransporterApiPost(
//       mobileNum: transporterIdController.mobileNum.value);
//   print("response = ");
//   print(response);
//   // if(response!=null){
//   //   setSta
//   // }
//   return response;
//   // return transporterId2.toString();
// }

// Future<dynamic>
// Future<String?> runTransporterApiPost2(
//   // required SendPort sendPort,
//   String? mobileNum,
//   // String? userLocation}
// ) async {
//   // data = {"phoneNo": FirebaseAuth.instance.currentUser!.phoneNumber.toString()};

//   // try {
//   print("in the try block of api file");
//   print(body);
//   print(data);
//   print(mobileno);
//   print(mobileNum);
//   print("here is api call started");
//   response = await http.post(
//       Uri.parse("http://transporter.dev.truckseasy.com:9090/transporter"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         // HttpHeaders.authorizationHeader: firebaseToken!
//       },
//       body: mobileNum);
//   // print(Widget(phoneno));
//   print(response.body);
//   print("here api call stopped");
//   return response;
//   // res(response);
//   // return response;
//   // sendPort.send(response);
//   // FirebaseMessaging.instance.getToken().then((value) {
//   //   if (value != null) {
//   //     log("firebase registration token =========> " + value);
//   //   }
//   //   // createTraccarUserAndNotifications2(value, mobileNum);
//   // });
// }

// void res(var response) {
//   // FirebaseMessaging.instance.getToken().then((value) {
//   //   if (value != null) {
//   //     log("firebase registration token =========> " + value);
//   //   }
//   //   // createTraccarUserAndNotifications2(value, mobileNum);
//   // });
//   print(response.body);
//   if (response.statusCode == 201) {
//     var decodedResponse = json.decode(response.body);
//     if (decodedResponse["transporterId"] != null) {
//       String transporterId = decodedResponse["transporterId"];
//       bool transporterApproved =
//           decodedResponse["transporterApproved"].toString() == "true";
//       bool companyApproved =
//           decodedResponse["companyApproved"].toString() == "true";
//       bool accountVerificationInProgress =
//           decodedResponse["accountVerificationInProgress"].toString() == "true";
//       String transporterLocation =
//           decodedResponse["transporterLocation"] == null
//               ? " "
//               : decodedResponse["transporterLocation"];
//       String name = decodedResponse["transporterName"] == null
//           ? " "
//           : decodedResponse["transporterName"];
//       String companyName = decodedResponse["companyName"] == null
//           ? " "
//           : decodedResponse["companyName"];
//       transporterIdController.updateTransporterId(transporterId);
//       tidstorage
//           .write("transporterId", transporterId)
//           .then((value) => print("Written transporterId"));
//       transporterIdController.updateTransporterApproved(transporterApproved);
//       tidstorage
//           .write("transporterApproved", transporterApproved)
//           .then((value) => print("Written transporterApproved"));
//       transporterIdController.updateCompanyApproved(companyApproved);
//       tidstorage
//           .write("companyApproved", companyApproved)
//           .then((value) => print("Written companyApproved"));
//       transporterIdController
//           .updateMobileNum(transporterIdController.mobileNum.value);
//       tidstorage
//           .write("mobileNum", transporterIdController.mobileNum.value)
//           .then((value) => print("Written mobileNum"));
//       transporterIdController
//           .updateAccountVerificationInProgress(accountVerificationInProgress);
//       tidstorage
//           .write("accountVerificationInProgress", accountVerificationInProgress)
//           .then((value) => print("Written accountVerificationInProgress"));
//       transporterIdController.updateTransporterLocation(transporterLocation);
//       tidstorage
//           .write("transporterLocation", transporterLocation)
//           .then((value) => print("Written transporterLocation"));
//       transporterIdController.updateName(name);
//       tidstorage.write("name", name).then((value) => print("Written name"));
//       transporterIdController.updateCompanyName(companyName);
//       tidstorage
//           .write("companyName", companyName)
//           .then((value) => print("Written companyName"));
//       if (decodedResponse["token"] != null) {
//         transporterIdController
//             .updateJmtToken(decodedResponse["token"].toString());
//       }
//       // return transporterId;
//     } else {
//       return null;
//     }
//   } else {
//     return null;
//   }
// }

// void createTraccarUserAndNotifications2(
//     String? token, String? mobileNum) async {
//   String? traccarId = tidstorage.read("traccarUserId");
//   if (traccarId == null) {
//     String? userId = await createUserTraccar2(token, mobileNum);
//   } else {
//     //do nothing
//   }
// }

// Future<String?> createUserTraccar2(String? token, String? mobileNum) async {
//   String traccarUser = FlutterConfig.get("traccarUser");
//   String traccarPass = FlutterConfig.get("traccarPass");
//   String traccarApi = FlutterConfig.get("traccarApi");
//   String basicAuth =
//       'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

//   Map data = {
//     "name": mobileNum,
//     "password": traccarPass,
//     "email": mobileNum,
//     "phone": mobileNum,
//     "attributes": {"notificationTokens": "$token", "timezone": "Asia/Kolkata"}
//   };
//   String body = json.encode(data);

//   var response = await http.post(Uri.parse("$traccarApi/users"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'authorization': basicAuth,
//       },
//       body: body);
//   if (response.statusCode == 200) {
//     var decodedResponse = json.decode(response.body);
//     String id = decodedResponse["id"].toString();
//     tidstorage
//         .write("traccarUserId", id)
//         .then((value) => print("traccarUserId \" $id \" saved in cache"));
//     return id;
//   } else if (response.statusCode == 400) {
//     //update notification token
//     var response = await http.get(
//       Uri.parse("$traccarApi/users"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'authorization': basicAuth,
//       },
//     );
//     var jsonData = json.decode(response.body);
//     for (var user in jsonData) {
//       if (user["phone"].toString() == mobileNum) {
//         String id = user["id"].toString();
//         data = {
//           "id": id,
//           "name": mobileNum,
//           "password": traccarPass,
//           "email": mobileNum,
//           "phone": mobileNum,
//           "attributes": {
//             "notificationTokens": "$token",
//             "timezone": "Asia/Kolkata"
//           }
//         };
//         body = json.encode(data);

//         var response = await http.put(Uri.parse("$traccarApi/users/$id"),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//               'authorization': basicAuth,
//             },
//             body: body);
//       }
//     }
//     return null;
//   }
//   return null;
// }
