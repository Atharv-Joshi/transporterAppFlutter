import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/loadOnGoingData.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/onGoingCardModel.dart';

getOngoingDataWithPageNo(int i) async {
  final String bookingApiUrl = dotenv.get('bookingApiUrl');
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  List<OngoingCardModel> modelList = [];
  http.Response response = await http.get(Uri.parse(
      '$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}&completed=false&cancel=false&pageNo=$i'));

  var jsonData = json.decode(response.body);
  print(response.body);
  for (var json in jsonData) {
    BookingModel bookingModel = BookingModel(truckId: []);
    bookingModel.bookingDate =
        json['bookingDate'] != null ? json['bookingDate'] : "NA";
    bookingModel.bookingId = json['bookingId'];
    bookingModel.postLoadId = json['postLoadId'];
    bookingModel.loadId = json['loadId'];
    bookingModel.transporterId = json['transporterId'];
    bookingModel.truckId = json['truckId'];
    bookingModel.cancel = json['cancel'];
    bookingModel.completed = json['completed'];
    bookingModel.completedDate =
        json['completedDate'] != null ? json['completedDate'] : "NA";
    bookingModel.rate = json['rate'] != null ? json['rate'].toString() : 'NA';
    bookingModel.unitValue =
        json['unitValue'] != null ? json['unitValue'] : 'PER_TON';
    bookingModel.deviceId = json['deviceId'] != null
        ? json['deviceId'] == 'NA'
            ? 80
            : int.parse(json["deviceId"])
        : 80;
    bookingModel.unloadingPointCity =
        json['unloadingPointCity'] != null ? json['unloadingPointCity'] : 'NA';
    bookingModel.loadingPointCity =
        json['loadingPointCity'] != null ? json['loadingPointCity'] : 'NA';
    bookingModel.truckNo = json['truckNo'] != null ? json['truckNo'] : 'NA';
    bookingModel.driverPhoneNum =
        json['driverPhoneNum'] != null ? json['driverPhoneNum'] : 'NA';
    bookingModel.driverName =
        json['driverName'] != null ? json['driverName'] : 'NA';

    var loadAllDataModel = await loadAllOngoingData(bookingModel);
    modelList.add(loadAllDataModel!);
  }
  return modelList;
}
