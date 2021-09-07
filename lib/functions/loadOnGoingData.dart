import 'package:flutter/material.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/models/transporterModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

//TODO:later on ,put these variables inside the function
LoadApiCalls loadApiCalls = LoadApiCalls();

TransporterApiCalls transporterApiCalls = TransporterApiCalls();

TruckApiCalls truckApiCalls = TruckApiCalls();

DriverApiCalls driverApiCalls = DriverApiCalls();

Future<OngoingCardModel> loadAllOngoingData(BookingModel bookingModel) async {
  DriverModel driverModel = DriverModel();
  Map truckData = {};
  Map loadData = await loadApiCalls.getDataByLoadId(bookingModel.loadId!);
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);
  if (!bookingModel.truckId![0].contains("truck")) {
    truckData = {
      'driverId': 'NA',
      'truckNo': 'NA',
      'imei': 'NA',
      'truckType': 'NA',
    };
  } else {
    truckData = await truckApiCalls.getDataByTruckId(bookingModel.truckId![0]);
  }

  if (truckData['driverId'] != "NA") {
    driverModel = await getDriverByDriverId(driverId: truckData['driverId']);
  } else {
    driverModel.driverId = 'NA';
    driverModel.transporterId = 'NA';
    driverModel.phoneNum = 'NA';
    driverModel.driverName = 'NA';
    driverModel.truckId = 'NA';
  }

  OngoingCardModel loadALLDataModel = OngoingCardModel();
  loadALLDataModel.bookingDate = bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.loadingPointCity = loadData['loadingPointCity'];
  loadALLDataModel.unloadingPointCity = loadData['unloadingPointCity'];
  loadALLDataModel.companyName = transporterModel.companyName;
  loadALLDataModel.transporterPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.transporterLocation = transporterModel.transporterLocation;
  loadALLDataModel.transporterName = transporterModel.transporterName;
  loadALLDataModel.transporterApproved = transporterModel.transporterApproved;
  loadALLDataModel.companyApproved = transporterModel.companyApproved;
  loadALLDataModel.truckNo = truckData['truckNo'];
  loadALLDataModel.truckType = truckData['truckType'];
  loadALLDataModel.imei = truckData['imei'];
  loadALLDataModel.driverName = driverModel.driverName;
  loadALLDataModel.driverPhoneNum = driverModel.phoneNum;
  loadALLDataModel.rate = bookingModel.rate.toString();
  loadALLDataModel.unitValue = bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = loadData['noOfTrucks'];
  loadALLDataModel.productType = loadData['productType'];

  return loadALLDataModel;
}
