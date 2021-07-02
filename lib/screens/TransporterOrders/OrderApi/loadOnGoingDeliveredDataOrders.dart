import 'package:liveasy/screens/TransporterOrders/OrderApi/postLoadIdApiCalls.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import '../../../functions/driverApiCalls.dart';
import '../../../functions/loadApiCalls.dart';

final LoadApiCalls loadApiCalls = LoadApiCalls();

final PostLoadIdApiCalls postLoadIdApiCalls = PostLoadIdApiCalls();

final TruckApiCalls truckApiCalls = TruckApiCalls();

final DriverApiCalls driverApiCalls = DriverApiCalls();

Future<Map> loadAllDataOrders(bookingModel) async {
  String bookingDate = bookingModel.bookingDate;
  String bookingId = bookingModel.bookingId;
  print("load Alll data $bookingId");
  print(bookingDate);
  String completedDate =
      bookingModel.completedDate == null || bookingModel.completedDate == ""
          ? "NA"
          : bookingModel.completedDate;
  print(completedDate);
  Map endpoints = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  print(endpoints);
  Map postLoadIdData = bookingModel.postLoadId[0] == "t"
      ? await postLoadIdApiCalls.getDataByTransporterId(bookingModel.postLoadId)
      : await postLoadIdApiCalls.getDataByShipperId(bookingModel.postLoadId);
  /*-------checked-------*/
  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId[0]);
  print(bookingModel.truckId[0]);

  DriverModel driverModel =
      await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);
  print(truckData['driverId']);

  Map cardDataModel = {
    'startedOn': bookingDate,
    'endedOn': completedDate,
    'loadingPoint': endpoints['loadingPointCity'],
    'unloadingPoint': endpoints['unloadingPointCity'],
    'companyName': postLoadIdData['companyName'],
    'bookingId': bookingId,
    // 'transporterName' : transporterData['transporterName'],
    'transporterPhoneNum': postLoadIdData['transporterPhoneNum'],
    'truckNo': truckData['truckNo'],
    'imei': "truckData['imei']",
    'driverName': driverModel.driverName,
    'driverPhoneNum': driverModel.phoneNum
  };

  return cardDataModel;
}
