import 'package:liveasy/functions/postLoadIdApiCalls.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

final LoadApiCalls loadApiCalls = LoadApiCalls();

final PostLoadIdApiCalls postLoadIdApiCalls = PostLoadIdApiCalls();

final TruckApiCalls truckApiCalls = TruckApiCalls();

final DriverApiCalls driverApiCalls = DriverApiCalls();

Future<Map> loadAllDataOrders(BookingModel bookingModel) async {

  Map loadDetails;
  Map postLoadIdData;


  if(bookingModel.loadId != 'NA'){
     loadDetails = await loadApiCalls.getDataByLoadId(bookingModel.loadId!);
  }
  else{
     loadDetails = {
      'loadingPointCity' : 'NA',
      'unloadingPointCity' : 'NA',
      'truckType' : 'NA',
      'productType' : 'NA',
      'noOfTrucks' : 'NA',
    };
  }


  if(bookingModel.postLoadId != 'NA'){
    postLoadIdData = bookingModel.postLoadId![0] == "t"
        ? await postLoadIdApiCalls.getDataByTransporterId(bookingModel.postLoadId!)
        : await postLoadIdApiCalls.getDataByShipperId(bookingModel.postLoadId!);
  }
  else{
    postLoadIdData = {
      'companyName': 'NA',
      'posterPhoneNum': '',
      'posterName': 'NA',
      "posterLocation": 'NA',
      "companyApproved": false
    };
  }


  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId![0]);


  DriverModel driverModel =
      await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);

  Map cardDataModel = {
    'unitValue': bookingModel.unitValue,
    'startedOn': bookingModel.bookingDate,
    'endedOn': bookingModel.completedDate,
    'loadingPoint': loadDetails['loadingPointCity'],
    'unloadingPoint': loadDetails['unloadingPointCity'],
    'truckType': loadDetails['truckType'],
    'productType': loadDetails['productType'],
    'noOfTrucks': loadDetails['noOfTrucks'],
    'rate': bookingModel.rateString,
    'bookingId': bookingModel.bookingId,
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
