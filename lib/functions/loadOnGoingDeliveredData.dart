import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

final LoadApiCalls loadApiCalls = LoadApiCalls();

final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

final TruckApiCalls truckApiCalls = TruckApiCalls();

final DriverApiCalls driverApiCalls = DriverApiCalls();

Future<Map> loadAllData(bookingModel) async {
  String bookingDate = bookingModel.bookingDate;
  String completedDate = bookingModel.completedDate;
  Map endpoints = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  String companyName = await transporterApiCalls.getDataByTransporterId(bookingModel.transporterId);
  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId);
  DriverModel driverModel = await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);

  Map cardDataModel = {
    'startedOn': bookingDate,
    'endedOn' : completedDate,
    'loadingPoint' : endpoints['loadingPoints'],
    'unloadingPoints' : endpoints['unloadingPoints'],
    'companyName' : companyName,
    'truckNo' : truckData['truckNo'],
    'imei' : truckData['imei'],
    'driverName' : driverModel.driverName,
    'phoneNum' : driverModel.phoneNum
  };

  return cardDataModel;
}