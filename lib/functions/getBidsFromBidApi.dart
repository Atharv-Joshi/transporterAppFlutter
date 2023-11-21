import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/biddingModel.dart';

Future<List<BiddingModel>> getBidsFromBidApi() async {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  var jsonData;
  List<BiddingModel> biddingModelList = [];
  final String bidApiUrl = dotenv.get("biddingApiUrl").toString();
  http.Response response = await http.get(Uri.parse(
      "$bidApiUrl?transporterId=${transporterIdController.transporterId.value}"));

  jsonData = json.decode(response.body);
  for (var json in jsonData) {
    BiddingModel biddingModel = BiddingModel();
    biddingModel.bidId = json["bidId"];
    biddingModel.transporterId = json["transporterId"];
    biddingModel.loadId = json["loadId"];
    biddingModel.currentBid = json["currentBid"].toString();
    biddingModel.previousBid = json['previousBid'].toString();
    biddingModel.unitValue = json["unitValue"];
    biddingModel.truckIdList = json["truckId"];
    biddingModel.shipperApproval = json["shipperApproval"];
    biddingModel.transporterApproval = json['transporterApproval'];
    biddingModel.biddingDate = json['biddingDate'];
    biddingModelList.add(biddingModel);
  }
  return biddingModelList;
}
