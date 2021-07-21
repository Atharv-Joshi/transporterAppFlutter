import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/loadPosterModel.dart';
//duplicate file ig can be deleted later
getLoadPosterDetailsFromApi({required String loadPosterId}) async {

  var jsonData;

  final String transporterApiUrl = FlutterConfig.get('transporterApiUrl').toString();
  final String shipperApiUrl = FlutterConfig.get('shipperApiUrl').toString();

  // loadPosterId = loadPosterId;
  try {
    if (loadPosterId.contains("transporter")) {
      http.Response response =  await http.get(Uri.parse(transporterApiUrl + "/$loadPosterId"));

      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["transporterId"];
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"].toString();
      loadPosterModel.loadPosterLocation = jsonData["transporterLocation"].toString();
      loadPosterModel.loadPosterName = jsonData["transporterName"];
      loadPosterModel.loadPosterCompanyName = jsonData["companyName"];
      loadPosterModel.loadPosterKyc = jsonData["kyc"];
      loadPosterModel.loadPosterCompanyApproved =   jsonData["companyApproved"];
      loadPosterModel.loadPosterApproved = jsonData["transporterApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =  jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
    if (loadPosterId.contains("shipper")) {
      http.Response response =  await http.get(Uri.parse(shipperApiUrl + "/$loadPosterId"));

      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["shipperId"];
      loadPosterModel.loadPosterName = jsonData["shipperName"];
      loadPosterModel.loadPosterCompanyName = jsonData["companyName"];
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"].toString();
      loadPosterModel.loadPosterKyc = jsonData["kyc"];
      loadPosterModel.loadPosterLocation = jsonData["shipperLocation"];
      loadPosterModel.loadPosterCompanyApproved = jsonData["companyApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =  jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
  } catch (e) {
    print(e);
  }
}
