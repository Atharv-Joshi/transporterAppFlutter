import 'package:flutter/material.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/transporterModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';


//TODO:later on ,put these variables inside the function
final LoadApiCalls loadApiCalls = LoadApiCalls();

final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

final TruckApiCalls truckApiCalls = TruckApiCalls();

final DriverApiCalls driverApiCalls = DriverApiCalls();

Future<Map> loadAllData(bookingModel) async {

  DriverModel driverModel = DriverModel();

  Map loadData = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);

  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId[0]);
  if(truckData['driverId'] != "NA"){
     driverModel = await driverApiCalls.getDriverByDriverId(driverId: truckData['driverId']);
  }
  else{
    driverModel.driverId =  'NA';
    driverModel.transporterId =  'NA';
    driverModel.phoneNum =  'NA';
    driverModel.driverName =  'NA';
    driverModel.truckId =  'NA';
  }


  Map loadALLDataModel = {
    'bookingDate': bookingModel.bookingDate,
    'bookingId' : bookingModel.bookingId,
    'completedDate':  bookingModel.completedDate,
    'loadingPoint': loadData['loadingPointCity'],
    'unloadingPoint': loadData['unloadingPointCity'],
    'companyName': transporterModel.companyName,
    'transporterPhoneNum': transporterModel.transporterPhoneNum,
    'transporterLocation' : transporterModel.transporterLocation,
    'transporterName' : transporterModel.transporterName,
    'transporterApproved' : transporterModel.transporterApproved,
    'companyApproved' : transporterModel.companyApproved,
    'truckNo': truckData['truckNo'],
    'truckType' : truckData['truckType'],
    'imei': truckData['imei'],
    'driverName': driverModel.driverName,
    'driverPhoneNum': driverModel.phoneNum,
    'rate' : bookingModel.rate.toString(),
    'unitValue' : bookingModel.unitValue,
    'noOfTrucks' : loadData['noOfTrucks'],
    'productType' : loadData['productType'],

  };

  return loadALLDataModel;
}
