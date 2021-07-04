import 'dart:convert';

import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/BookingModel.dart';

class BookingApiCalls {
  //TransporterIdController will be used as postId in Transporter App
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //BookingApiUrl
  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

  //to hold list of dataModels retrieved from Api
  List<BookingModel> modelList = [];

  //GET ------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdOnGoing() async {
    modelList = [];
    print('getDataByPostLoadIdOnGoing in');
    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}&completed=false&cancel=false&pageNo=$i'));

      var jsonData = json.decode(response.body);

      if (jsonData.isEmpty) {
        break;
      }
      print('on going response : $jsonData');

      for (var json in jsonData) {
        BookingModel bookingModel = BookingModel(truckId: []);
        bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : "NA";
        print(bookingModel.bookingDate);
        bookingModel.loadId = json['loadId'];
        print(bookingModel.loadId);
        bookingModel.transporterId = json['transporterId'];
        print(bookingModel.transporterId);
        bookingModel.truckId = json['truckId'];
        print(bookingModel.truckId);
        bookingModel.cancel = json['cancel'];
        print(bookingModel.cancel);
        bookingModel.completed = json['completed'];
        print(bookingModel.completed);
        bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : "NA";
        print(bookingModel.completedDate);
        modelList.add(bookingModel);
      }
    }
    print('getDataByPostLoadIdOnGoing out');
    return modelList;
  }

  //----------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdDelivered() async {
    modelList = [];
    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}&completed=true&cancel=false&pageNo=$i'));
      var jsonData = json.decode(response.body);

      if (jsonData.isEmpty) {
        break;
      }

      print('delivered response : $jsonData');
      for (var json in jsonData) {
        BookingModel bookingModel = BookingModel(truckId: []);
        bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : "NA";
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : "NA";
        modelList.add(bookingModel);
      }
    }
    return modelList;
  }

  //----------------------------------------------------------------------------
}
