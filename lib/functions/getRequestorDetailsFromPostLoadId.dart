import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadPosterModel.dart';

getLoadPosterDetailsFromPostLoadId(postLoadId) async {
  var jsonData;
  final String transporterApiUrl = dotenv.get("transporterApiUrl").toString();
  final String shipperApiUrl = dotenv.get('shipperApiUrl').toString();

  try {
    if (postLoadId.contains("Company")) {
      final DocumentReference documentRef =
          FirebaseFirestore.instanceFor(app: Firebase.app('second_instance'))
              .collection('/Companies')
              .doc(postLoadId);

      final doc = await documentRef.get();
      if (doc.exists) {
        Map jsonData = doc.data() as Map;
        LoadPosterModel loadPosterModel = LoadPosterModel();
        loadPosterModel.loadPosterId =
            jsonData["company_uuid"] != null ? jsonData["company_uuid"] : 'NA';
        loadPosterModel.loadPosterPhoneNo =
            jsonData["company_details"]["contact_info"]["company_phone"] != null
                ? jsonData["company_details"]["contact_info"]["company_phone"]
                : 'NA';
        loadPosterModel.loadPosterLocation = jsonData["company_details"]
                    ["company_address"]["company_address"] !=
                null
            ? jsonData["company_details"]["company_address"]["company_address"]
            : 'NA';
        loadPosterModel.loadPosterName =
            jsonData["company_details"]["company_name"] != null
                ? jsonData["company_details"]["company_name"]
                : 'NA';
        loadPosterModel.loadPosterCompanyName =
            jsonData["company_details"]["company_name"] != null
                ? jsonData["company_details"]["company_name"]
                : 'NA';
        loadPosterModel.loadPosterKyc =
            jsonData["company_details"]["gst_no"] != null
                ? jsonData["company_details"]["gst_no"]
                : 'NA';
        loadPosterModel.loadPosterCompanyApproved = true;
        loadPosterModel.loadPosterApproved = true;
        loadPosterModel.loadPosterAccountVerificationInProgress = false;

        print(jsonData);
        return loadPosterModel;
      }
    }
    if (postLoadId.contains("transporter")) {
      http.Response response =
          await http.get(Uri.parse("$transporterApiUrl/$postLoadId"));
      jsonData = json.decode(response.body);
      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId =
          jsonData["transporterId"] != null ? jsonData["transporterId"] : 'NA';
      loadPosterModel.loadPosterPhoneNo =
          jsonData["phoneNo"] != null ? jsonData["phoneNo"] : 'NA';
      loadPosterModel.loadPosterLocation =
          jsonData["transporterLocation"] != null
              ? jsonData["transporterLocation"]
              : 'NA';
      loadPosterModel.loadPosterName = jsonData["transporterName"] != null
          ? jsonData["transporterName"]
          : 'NA';
      loadPosterModel.loadPosterCompanyName =
          jsonData["companyName"] != null ? jsonData["companyName"] : 'NA';
      loadPosterModel.loadPosterKyc =
          jsonData["kyc"] != null ? jsonData["kyc"] : 'NA';
      loadPosterModel.loadPosterCompanyApproved = jsonData["companyApproved"];
      loadPosterModel.loadPosterApproved = jsonData["transporterApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =
          jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
    if (postLoadId.contains("shipper")) {
      http.Response response =
          await http.get(Uri.parse("$shipperApiUrl/$postLoadId"));
      jsonData = json.decode(response.body);
      LoadPosterModel loadPosterModel = LoadPosterModel();
      loadPosterModel.loadPosterId =
          jsonData["shipperId"] != null ? jsonData["shipperId"] : 'NA';
      loadPosterModel.loadPosterName =
          jsonData["shipperName"] != null ? jsonData["shipperName"] : 'NA';
      loadPosterModel.loadPosterCompanyName =
          jsonData["companyName"] != null ? jsonData["companyName"] : 'NA';
      loadPosterModel.loadPosterPhoneNo =
          jsonData["phoneNo"] != null ? jsonData["phoneNo"] : 'NA';
      loadPosterModel.loadPosterKyc =
          jsonData["kyc"] != null ? jsonData["kyc"] : 'NA';
      loadPosterModel.loadPosterLocation = jsonData["shipperLocation"] != null
          ? jsonData["shipperLocation"]
          : 'NA';
      loadPosterModel.loadPosterCompanyApproved = jsonData["companyApproved"];
      loadPosterModel.loadPosterAccountVerificationInProgress =
          jsonData["accountVerificationInProgress"];
      return loadPosterModel;
    }
  } catch (e) {
    print(e);
  }
}
