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
  String unitValue = bookingModel.unitValue;
  print("load All data $bookingId");
  print(bookingDate);
  int rate = bookingModel.rate;
  String completedDate = bookingModel.completedDate;
  bookingModel.completedDate == null || bookingModel.completedDate == ""
      ? "NA"
      : bookingModel.completedDate;
  print(completedDate);
  Map loadDetails = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  print(loadDetails);
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
    'unitValue': unitValue,
    'startedOn': bookingDate,
    'endedOn': completedDate,
    'loadingPoint': loadDetails['loadingPointCity'],
    'unloadingPoint': loadDetails['unloadingPointCity'],
    'truckType': loadDetails['truckType'],
    'productType': loadDetails['productType'],
    'noOfTrucks': loadDetails['noOfTrucks'],
    'rate': rate,
    'bookingId': bookingId,
    // 'transporterName' : transporterData['transporterName'],
    'posterPhoneNum': postLoadIdData['posterPhoneNum'],
    'posterLocation': postLoadIdData['posterLocation'],
    'companyName': postLoadIdData['companyName'],
    "companyApproved": postLoadIdData['companyApproved'],
    'posterName': postLoadIdData['posterName'],
    'truckNo': truckData['truckNo'],
    'imei': "truckData['imei']",
    'driverName': driverModel.driverName,
    'driverPhoneNum': driverModel.phoneNum
  };

  return cardDataModel;
}
