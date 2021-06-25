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
  Map transporterData = await transporterApiCalls.getDataByTransporterId(bookingModel.transporterId);
  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId[0]);
  DriverModel driverModel = await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);

  Map cardDataModel = {
    'startedOn': bookingDate,
    'endedOn' : completedDate,
    'loadingPoint' : endpoints['loadingPointCity'] != null ? endpoints['loadingPointCity'] : 'NA',
    'unloadingPoint' :endpoints['unloadingPointCity'] != null ? endpoints['unloadingPointCity'] : 'NA',
    'companyName' : transporterData['companyName'] != null ? transporterData['companyName'] : 'NA',
    // 'transporterName' : transporterData['transporterName'],
    'transporterPhoneNum' : transporterData['transporterPhoneNum'] != null ? transporterData['transporterPhoneNum'] : '',
    'truckNo' : truckData['truckNo'] != null ? truckData['truckNo'] : 'NA',
    'imei' : truckData['imei'] != null ?  truckData['imei'] : 'NA' ,
    'driverName' : driverModel.driverName != null ? driverModel.driverName : 'NA',
    'driverPhoneNum' : driverModel.phoneNum != null ? driverModel.phoneNum : ''
  };

  return cardDataModel;
}