import 'dart:convert';

import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:http/http.dart' as http ;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/BookingModel.dart';

class BookingApiCalls{

  //TransporterIdController will be used as postId in Transporter App
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  //BookingApiUrl
  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

  //to hold list of dataModels retrieved from Api
  List<BookingModel> modelList = [];

  //GET ------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdOnGoing() async {
    print('first line of getDataByPostId');
    http.Response response = await  http.get(Uri.parse('$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}'));
    print('after get ');
    var jsonData = json.decode(response.body);

    for( var json in jsonData){
      if(json['cancel'] == false && json['completed'] == false){
        BookingModel bookingModel = BookingModel();
        bookingModel.bookingDate = json['bookingDate'];
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.completedDate = json['completedDate'];
        modelList.add(bookingModel);
      }

    }
    print('length of BookingModel List : ${modelList.length}');
    print(modelList);
    return modelList;
  }

  //----------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdDelivered() async {
    print('first line of getDataByPostId');
    http.Response response = await  http.get(Uri.parse('$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}'));
    print('after get ');
    var jsonData = json.decode(response.body);

    for( var json in jsonData){
      if(json['cancel'] == false && json['completed'] == true){
        BookingModel bookingModel = BookingModel();
        bookingModel.bookingDate = json['bookingDate'];
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.completedDate = json['completedDate'];
        modelList.add(bookingModel);
      }

    }
    print('length of BookingModel List : ${modelList.length}');
    print(modelList);
    return modelList;
  }

  //----------------------------------------------------------------------------
}