import 'dart:async';

import 'package:get/get.dart';
import 'package:liveasy/controller/tokenMMIController.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

Future<String> getMapMyIndiaToken() async {
  String? clientIdMapMyIndia;
  String? clientSecretMapMyIndia;
  await FirebaseDatabase.instance
      .reference()
      .child('clientSecretMapMyIndia')
      .once()
      .then((DataSnapshot snapshot) {
    clientSecretMapMyIndia = snapshot.value as String?;
    print("clientSecretMapMyIndia = $clientSecretMapMyIndia");
  } as FutureOr Function(DatabaseEvent value));
  await FirebaseDatabase.instance
      .reference()
      .child('clientIdMapMyIndia')
      .once()
      .then((DataSnapshot snapshot) {
    clientIdMapMyIndia = snapshot.value as String?;
    print("clientIdMapMyIndia = $clientIdMapMyIndia");
  } as FutureOr Function(DatabaseEvent value));
  // if(clientIdMapMyIndia != null && clientSecretMapMyIndia != null){

  TokenMMIController tokenMMIController = Get.find<TokenMMIController>();
  Uri tokenUrl = Uri(
      scheme: "https",
      host: "outpost.mapmyindia.com",
      path: 'api/security/oauth/token',
      queryParameters: {
        "grant_type": "client_credentials",
        "client_id": "$clientIdMapMyIndia",
        "client_secret": "$clientSecretMapMyIndia"
      });
  http.Response tokenGet = await http.post(tokenUrl);
  var body = jsonDecode(tokenGet.body);
  var token = body["access_token"];
  print("token = $token");
  tokenMMIController.updateTokenMMI(token);
  return token;
}
