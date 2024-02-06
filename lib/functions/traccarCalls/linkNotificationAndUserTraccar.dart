import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/functions/encryptDecrypt.dart';

void linkNotificationAndUserTraccar(String? userId, List<String?>? id) async {
  String traccarUser = dotenv.get("traccarUser");
  String traccarPass = decrypt(dotenv.get('traccarPass'));
  String traccarApi = dotenv.get("traccarApi");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

  for (int i = 0; i < id!.length; i++) {
    if (id[i] != null) {
      int notificationId = int.parse(id[i]!);
      Map data = {
        "userId": int.parse(userId!),
        "notificationId": notificationId
      };
      String body = json.encode(data);
      var response = await http.post(Uri.parse("$traccarApi/permissions"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': basicAuth,
          },
          body: body);
      print(response.body);
    }
  }
}
