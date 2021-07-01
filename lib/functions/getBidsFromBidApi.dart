import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<BidsModel>> getBidsFromBidApi() async {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  var jsonData;
  List<BidsModel> bidsCard = [];
  final String bidApiUrl = FlutterConfig.get("biddingApiUrl").toString();
  http.Response response = await http.get(Uri.parse(
      "$bidApiUrl?transporterId=${transporterIdController.transporterId}"));

  jsonData = json.decode(response.body);
  for (var json in jsonData) {
    BidsModel bidsModel = BidsModel();
    bidsModel.bidId = json["bidId"].toString();
    bidsModel.transporterId = json["transporterId"].toString();
    bidsModel.rate = json["rate"].toString();
    bidsModel.unitValue = json["unitValue"].toString();
    bidsModel.loadId = json["loadId"].toString();
    bidsModel.biddingDate = json["biddingDate"].toString();
    bidsModel.truckId = json["truckId"].toString();
    bidsModel.shipperApproval= json["shipperApproval"];
    bidsCard.add(bidsModel);
  }

  return bidsCard;
}
