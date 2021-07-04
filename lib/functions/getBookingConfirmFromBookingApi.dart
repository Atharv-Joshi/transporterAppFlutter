import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:flutter_config/flutter_config.dart';

Future<List<BookingModel>> getBookingConfirmFromBookingApi() async {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  var jsonData;
  List<BookingModel> bookingCard = [];
  final String bidApiUrl = FlutterConfig.get("biddingApiUrl").toString();
  http.Response response = await http.get(Uri.parse(
      "$bidApiUrl?transporterId=${transporterIdController.transporterId}"));
  try {
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      BookingModel bookingModel = BookingModel();
      bookingModel.bookingId = json["bookingId"].toString();
      bookingModel.transporterId = json["transporterId"].toString();
      bookingModel.postLoadId = json["postLoadId"].toString();
      bookingModel.rate = json["rate"].toString();
      bookingModel.unitValue = json["unitValue"].toString();
      bookingModel.loadId = json["loadId"].toString();
      bookingModel.bookingDate = json["bookingDate"].toString();
      bookingModel.truckId = json["truckId"];
      bookingModel.cancel = json["cancel"];
      bookingModel.completed = json["completed"];
      bookingModel.completedDate = json["completedDate"].toString();
      bookingCard.add(bookingModel);
    }
  } catch (e) {
    print("getbookingconfirm$e");
  }

  return bookingCard;
}
