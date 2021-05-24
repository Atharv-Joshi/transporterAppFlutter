import 'package:get/get.dart';
import 'package:liveasy/controller/tokenMMIController.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//TODO: has to be in environment file
String clientIdMapMyIndia =
    "33OkryzDZsJmp0siGnK04TeuQrg3DWRxswnTg_VBiHew-2D1tA3oa3fthrGnx4vwbwlbF_xT2T4P9dykuS1GUNmbRb8e5CUgz-RgWDyQspeDCXkXK5Nagw==";
String clientSecretMapMyIndia =
    "lrFxI-iSEg9xHXNZXiqUoprc9ZvWP_PDWBDw94qhrze0sUkn7LBDwRNFscpDTVFH7aQT4tu6ycN0492wqPs-ewpjObJ6xuR7iRufmSVcnt9fys5dp0F5jlHLxBEj7oqq";

Future<String> getMapMyIndiaToken() async {
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
  tokenMMIController.updateTokenMMI(token);
  return token;
}