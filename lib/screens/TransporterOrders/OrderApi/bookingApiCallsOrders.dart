import 'dart:convert';

import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/providerClass/providerData.dart';

class BookingApiCallsOrders {
  //TransporterIdController will be used as postId in Transporter App
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  ProviderData providerData = ProviderData();

  //BookingApiUrl
  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

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
        BookingModel bookingModel = BookingModel(truckId: []);
        bookingModel.bookingDate = json['bookingDate'];
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.completedDate = json['completedDate'];
        bookingModel.postLoadId = json['postLoadId'];
        bookingModel.bookingId = json['bookingId'];
        // providerData.updateBookingId(json['postLoadId']);
        // print(bookingModel.bookingId);

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

        if (jsonData.isEmpty) {
          break;
        }
        print(jsonData);
        for (var json in jsonData) {
          BookingModel bookingModel = BookingModel(truckId: []);
          bookingModel.bookingDate = json['bookingDate'];
          bookingModel.loadId = json['loadId'];
          bookingModel.transporterId = json['transporterId'];
          bookingModel.truckId = json['truckId'];
          bookingModel.cancel = json['cancel'];
          bookingModel.completed = json['completed'];
          bookingModel.completedDate = json['completedDate'];
          bookingModel.postLoadId = json['postLoadId'];

          modelList.add(bookingModel);
        }
      }
    } catch (e) {
      print(e);
    }
    return modelList;
  }

  updateBookingApi(completedDate, bookingId) async {
    Map data = {"completed": true, "completedDate": completedDate};
    String body = json.encode(data);
    final response = await http.put(Uri.parse("$bookingApiUrl/$bookingId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    print(response.body);
  }
}

//----------------------------------------------------------------------------
