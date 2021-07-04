import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadPosterModel.dart';

getRequestorDetailsFromPostLoadId(postLoadId) async {
  var jsonData;
  final String transporterApiUrl =
      FlutterConfig.get("transporterApiUrl").toString();
  final String shipperApiUrl = FlutterConfig.get('shipperApiUrl').toString();

  try {
    if (postLoadId.contains("transporter")) {
      http.Response response =
          await http.get(Uri.parse("$transporterApiUrl/$postLoadId"));
      jsonData = json.decode(response.body);
      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["transporterId"].toString();
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"].toString();
      loadPosterModel.loadPosterLocation =
          jsonData["transporterLocation"].toString();
      loadPosterModel.loadPosterName = jsonData["transporterName"].toString();
      loadPosterModel.loadPosterCompanyName =
          jsonData["companyName"].toString();
      loadPosterModel.loadPosterKyc = jsonData["kyc"].toString();
      loadPosterModel.loadPosterCompanyApproved =
          jsonData["companyApproved"].toString();
      loadPosterModel.loadPosterApproved =
          jsonData["transporterApproved"].toString();
      loadPosterModel.loadPosterAccountVerificationInProgress =
          jsonData["accountVerificationInProgress"].toString();
      return loadPosterModel;
    }
    if (postLoadId.contains("shipper")) {
      http.Response response =
          await http.get(Uri.parse("$shipperApiUrl/$postLoadId"));
      jsonData = json.decode(response.body);
      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["shipperId"].toString();
      loadPosterModel.loadPosterName = jsonData["shipperName"].toString();
      loadPosterModel.loadPosterCompanyName =
          jsonData["companyName"].toString();
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"].toString();
      loadPosterModel.loadPosterKyc = jsonData["kyc"].toString();
      loadPosterModel.loadPosterLocation =
          jsonData["shipperLocation"].toString();
      loadPosterModel.loadPosterCompanyApproved =
          jsonData["companyApproved"].toString();
      loadPosterModel.loadPosterAccountVerificationInProgress =
          jsonData["accountVerificationInProgress"].toString();
      return loadPosterModel;
    }
  } catch (e) {
    print(e);
  }
}
