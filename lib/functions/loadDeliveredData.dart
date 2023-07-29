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

  DeliveredCardModel loadALLDataModel = DeliveredCardModel();
  loadALLDataModel.bookingDate= bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.loadingPointCity = bookingModel.loadingPointCity;
  loadALLDataModel.unloadingPointCity = bookingModel.unloadingPointCity;
  loadALLDataModel.companyName =  transporterModel.companyName;
  loadALLDataModel.transporterPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.transporterLocation = transporterModel.transporterLocation;
  loadALLDataModel.transporterName = transporterModel.transporterName;
  loadALLDataModel.transporterApproved = transporterModel.transporterApproved;
  loadALLDataModel.companyApproved=transporterModel.companyApproved;
  loadALLDataModel.truckNo = bookingModel.truckNo; // truckData['truckNo'];
  loadALLDataModel.truckType= 'NA'; // truckData['truckType'];
  loadALLDataModel.imei = 'NA'; // truckData['imei'];
  loadALLDataModel.driverName= bookingModel.driverName;
  loadALLDataModel.driverPhoneNum= bookingModel.driverPhoneNum;
  loadALLDataModel.rate= bookingModel.rate.toString();
  loadALLDataModel.unitValue =  bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = loadData['noOfTrucks'];
  loadALLDataModel.productType = loadData['productType'];

  // Added on 24-07-2023 :--
  loadALLDataModel.deviceId = bookingModel.deviceId;
  // ----------

  return loadALLDataModel;
}