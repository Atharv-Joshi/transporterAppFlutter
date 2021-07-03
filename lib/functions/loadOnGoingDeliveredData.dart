import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/transporterModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

final LoadApiCalls loadApiCalls = LoadApiCalls();

final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

final TruckApiCalls truckApiCalls = TruckApiCalls();

final DriverApiCalls driverApiCalls = DriverApiCalls();

Future<Map> loadAllData(bookingModel) async {
  print('load all data in');
  String bookingDate = bookingModel.bookingDate;
  print(bookingDate);
  String completedDate = bookingModel.completedDate;
  print(completedDate);
  Map endpoints = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  print(endpoints);
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);

  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId[0]);
  DriverModel driverModel =
      await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);

  Map cardDataModel = {
    'startedOn': bookingDate,
    'endedOn': completedDate,
    'loadingPoint': endpoints['loadingPointCity'],
    'unloadingPoint': endpoints['unloadingPointCity'],
    'companyName': transporterModel.companyName,
    'transporterPhoneNum': transporterModel.transporterPhoneNum,
    'truckNo': truckData['truckNo'],
    'imei': truckData['imei'],
    'driverName': driverModel.driverName,
    'driverPhoneNum': driverModel.phoneNum,
  };
  print('load all data out');
  return cardDataModel;
}
