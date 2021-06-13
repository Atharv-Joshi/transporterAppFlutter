import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:liveasy/models/loadPosterModel.dart';


getLoadPosterDetailsFromApi({required String loadPosterId}) async {
  print(loadPosterId);
  var loadPosterDetails;
  var jsonData;

  String transporterApiUrl =
      "http://ec2-65-0-138-10.ap-south-1.compute.amazonaws.com:9090/transporter";
  String shipperApiUrl =
      "http://ec2-65-0-138-10.ap-south-1.compute.amazonaws.com:8080/shipper";

  loadPosterId = loadPosterId.toString();
  try{
    if (loadPosterId.contains("transporter")) {
      http.Response response =
      await http.get(Uri.parse(transporterApiUrl + "/$loadPosterId"));
      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["id"].toString();
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"].toString();
      loadPosterModel.loadPosterLocation =
          jsonData["transporterLocation"].toString();
      loadPosterModel.loadPosterName = jsonData["name"].toString();
      loadPosterModel.loadPosterCompanyName =
          jsonData["companyName"].toString();
      loadPosterModel.loadPosterKyc = jsonData["kyc"].toString();
      loadPosterModel.loadPosterCompanyApproved =
          jsonData["companyApproved"].toString();
      loadPosterModel.loadPosterApproved =
          jsonData["transporterApproved"].toString();
      return loadPosterModel;
    }
    if (loadPosterId.contains("shipper")) {
      http.Response response =
      await http.get(Uri.parse(shipperApiUrl + "/$loadPosterId"));
      jsonData = json.decode(response.body);

      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId = jsonData["id"].toString();
      loadPosterModel.loadPosterName = jsonData["name"].toString();
      loadPosterModel.loadPosterCompanyName = jsonData["companyName"].toString();
      loadPosterModel.loadPosterPhoneNo = jsonData["phoneNo"];
      loadPosterModel.loadPosterKyc = jsonData["kyc"].toString();
      loadPosterModel.loadPosterApproved = jsonData["approved"].toString();
      loadPosterDetails.add(loadPosterModel);
      return loadPosterModel;
    }
  }
  catch(e){print(e);}

}