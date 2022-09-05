import 'package:flutter/material.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/models/transporterModel.dart';
// import 'driverApiCalls.dart';
// import 'loadApiCalls.dart';

//TODO:later on ,put these variables inside the function
// LoadApiCalls loadApiCalls = LoadApiCalls();

TransporterApiCalls transporterApiCalls = TransporterApiCalls();

// TruckApiCalls truckApiCalls = TruckApiCalls();

// DriverApiCalls driverApiCalls = DriverApiCalls();

Future<OngoingCardModel?> loadAllOnGoingOrdersData(
    BookingModel bookingModel) async {
  // Map loadData = await loadApiCalls.getDataByLoadId(bookingModel.loadId!);
  // TransporterModel transporterModel = await transporterApiCalls
  //     .getDataByTransporterId(bookingModel.transporterId);

  TransporterModel transporterModel =
      await transporterApiCalls.getDataByTransporterId(bookingModel.postLoadId);

  OngoingCardModel loadALLDataModel = OngoingCardModel();
  loadALLDataModel.bookingDate = bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.deviceId = bookingModel.deviceId;
  loadALLDataModel.loadingPointCity = bookingModel.loadingPointCity;
  loadALLDataModel.unloadingPointCity = bookingModel.unloadingPointCity;
  loadALLDataModel.companyName = transporterModel.companyName;
  loadALLDataModel.transporterPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.transporterLocation = transporterModel.transporterLocation;
  loadALLDataModel.transporterName = transporterModel.transporterName;
  loadALLDataModel.transporterApproved = transporterModel.transporterApproved;
  loadALLDataModel.companyApproved = transporterModel.companyApproved;
  loadALLDataModel.truckNo = bookingModel.truckNo;
  loadALLDataModel.truckType = 'NA';
  loadALLDataModel.imei = 'NA';
  loadALLDataModel.driverName = bookingModel.driverName;
  loadALLDataModel.driverPhoneNum = bookingModel.driverPhoneNum;
  loadALLDataModel.rate = bookingModel.rate.toString();
  loadALLDataModel.unitValue = bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = 'NA';
  loadALLDataModel.productType = 'NA';

  return loadALLDataModel;
}
