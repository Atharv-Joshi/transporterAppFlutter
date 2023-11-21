import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/providerClass/providerData.dart';

class BookingApiCallsOrders {
  //TransporterIdController will be used as postId in Transporter App
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  ProviderData providerData = ProviderData();

  //BookingApiUrl
  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  //to hold list of dataModels retrieved from Api
  List<BookingModel> modelList = [];

  //GET ------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByTransporterIdOnGoing() async {
    modelList = [];

    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$bookingApiUrl?transporterId=${transporterIdController.transporterId.value}&completed=false&cancel=false&pageNo=$i'));

      var jsonData = json.decode(response.body);
      if (jsonData.isEmpty) {
        break;
      }

      for (var json in jsonData) {
        BookingModel bookingModel = BookingModel();
        bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : 'NA';
        bookingModel.loadId = json['loadId'] != null ? json['loadId'] : 'NA';
        bookingModel.transporterId =
            json['transporterId'] != null ? json['transporterId'] : 'NA';
        bookingModel.truckId = json['truckId'] != null ? json['truckId'] : 'NA';
        bookingModel.cancel = json['cancel'] != null ? json['cancel'] : false;
        bookingModel.completed =
            json['completed'] != null ? json['completed'] : false;
        bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : 'NA';
        bookingModel.postLoadId =
            json['postLoadId'] != null ? json['postLoadId'] : 'NA';
        bookingModel.bookingId =
            json['bookingId'] != null ? json['bookingId'] : 'NA';
        bookingModel.rateString =
            json['rate'] != null ? json['rate'].toString() : 'NA';
        bookingModel.unitValue =
            json['unitValue'] != null ? json['unitValue'] : 'NA';

        modelList.add(bookingModel);
      }
    }
    return modelList;
  }

  //----------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByTransporterIdDelivered() async {
    modelList = [];
    try {
      for (int i = 0;; i++) {
        http.Response response = await http.get(Uri.parse(
            '$bookingApiUrl?transporterId=${transporterIdController.transporterId.value}&completed=true&cancel=false&pageNo=$i'));
        var jsonData = json.decode(response.body);
        print("$jsonData -------------------ORDER COMPLETE-----------");

        if (jsonData.isEmpty) {
          break;
        }
        for (var json in jsonData) {
          BookingModel bookingModel = BookingModel();
          bookingModel.bookingDate =
              json['bookingDate'] != null ? json['bookingDate'] : 'NA';
          bookingModel.loadId = json['loadId'] != null ? json['loadId'] : 'NA';
          bookingModel.transporterId =
              json['transporterId'] != null ? json['transporterId'] : 'NA';
          bookingModel.truckId =
              json['truckId'] != null ? json['truckId'] : 'NA';
          bookingModel.cancel = json['cancel'] != null ? json['cancel'] : false;
          bookingModel.completed =
              json['completed'] != null ? json['completed'] : false;
          bookingModel.completedDate =
              json['completedDate'] != null ? json['completedDate'] : 'NA';
          bookingModel.postLoadId =
              json['postLoadId'] != null ? json['postLoadId'] : 'NA';
          bookingModel.rateString =
              json['rate'] != null ? json['rate'].toString() : 'NA';
          bookingModel.unitValue =
              json['unitValue'] != null ? json['unitValue'] : 'NA';
          // added on 24-07-2023 -----
          bookingModel.loadingPointCity = json['loadingPointCity'] != null
              ? json['loadingPointCity']
              : 'NA';
          bookingModel.unloadingPointCity = json['unloadingPointCity'] != null
              ? json['unloadingPointCity']
              : 'NA';
          bookingModel.bookingId =
              json['bookingId'] != null ? json['bookingId'] : 'NA';
          bookingModel.truckNo =
              json['truckNo'] != null ? json['truckNo'] : 'NA';
          bookingModel.driverName =
              json['driverName'] != null ? json['driverName'] : 'NA';
          bookingModel.driverPhoneNum =
              json['driverPhoneNum'] != null ? json['driverPhoneNum'] : 'NA';
          // --------

          modelList.add(bookingModel);
        }
      }
    } catch (e) {}
    return modelList;
  }

  Future<String?> updateBookingApi(completedDate, bookingId) async {
    try {
      print(bookingId);
      Map data = {
        "completed": true,
        "completedDate": completedDate,
        "cancel": false,
      };
      String body = json.encode(data);
      final response = await http.put(Uri.parse("$bookingApiUrl/$bookingId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200) {
        return "completed";
      }
      return null;
    } catch (e) {
      print(e.toString());
      return "error";
    }
  }
}

//----------------------------------------------------------------------------
