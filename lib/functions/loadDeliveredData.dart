import 'package:flutter/material.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/deliveredCardModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/models/transporterModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';


Future<DeliveredCardModel> loadAllDeliveredData(bookingModel) async {
  final LoadApiCalls loadApiCalls = LoadApiCalls();

  final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  final TruckApiCalls truckApiCalls = TruckApiCalls();

  DriverModel driverModel = DriverModel();

  Map loadData = await loadApiCalls.getDataByLoadId(bookingModel.loadId);
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);

  Map truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId[0]);
  if(truckData['driverId'] != "NA"){
    driverModel = await getDriverByDriverId(driverId: truckData['driverId']);
  }
  else{
    driverModel.driverId =  'NA';
    driverModel.transporterId =  'NA';
    driverModel.phoneNum =  'NA';
    driverModel.driverName =  'NA';
    driverModel.truckId =  'NA';
  }

  DeliveredCardModel loadALLDataModel = DeliveredCardModel();
  loadALLDataModel.bookingDate= bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.loadingPointCity = loadData['loadingPointCity'];
  loadALLDataModel.unloadingPointCity = loadData['unloadingPointCity'];
  loadALLDataModel.companyName =  transporterModel.companyName;
  loadALLDataModel.transporterPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.transporterLocation = transporterModel.transporterLocation;
  loadALLDataModel.transporterName = transporterModel.transporterName;
  loadALLDataModel.transporterApproved = transporterModel.transporterApproved;
  loadALLDataModel.companyApproved=transporterModel.companyApproved;
  loadALLDataModel.truckNo =truckData['truckNo'];
  loadALLDataModel.truckType= truckData['truckType'];
  loadALLDataModel.imei = truckData['imei'];
  loadALLDataModel.driverName= driverModel.driverName;
  loadALLDataModel.driverPhoneNum= driverModel.phoneNum;
  loadALLDataModel.rate= bookingModel.rate.toString();
  loadALLDataModel.unitValue =  bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = loadData['noOfTrucks'];
  loadALLDataModel.productType =loadData['productType'];

  return loadALLDataModel;
}