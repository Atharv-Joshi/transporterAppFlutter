import 'dart:developer';

import 'package:liveasy/functions/postLoadIdApiCalls.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'loadApiCalls.dart';

final LoadApiCalls loadApiCalls = LoadApiCalls();

final PostLoadIdApiCalls postLoadIdApiCalls = PostLoadIdApiCalls();

Future<Map> loadAllDataOrders(BookingModel bookingModel) async {
  Map loadDetails;
  Map postLoadIdData;

  if (bookingModel.loadId != 'NA') {
    loadDetails = await loadApiCalls.getDataByLoadId(bookingModel.loadId!);
  } else {
    loadDetails = {
      'loadingPointCity': 'NA',
      'unloadingPointCity': 'NA',
      'truckType': 'NA',
      'productType': 'NA',
      'noOfTrucks': 'NA',
    };
  }

  if (bookingModel.postLoadId != 'NA') {
    postLoadIdData = bookingModel.postLoadId![0] == "t"
        ? await postLoadIdApiCalls
            .getDataByTransporterId(bookingModel.postLoadId!)
        : await postLoadIdApiCalls.getDataByShipperId(bookingModel.postLoadId!);
  } else {
    postLoadIdData = {
      'companyName': 'NA',
      'posterPhoneNum': '',
      'posterName': 'NA',
      "posterLocation": 'NA',
      "companyApproved": false
    };
  }

  Map cardDataModel = {
    'unitValue': bookingModel.unitValue == null ? "NA" : bookingModel.unitValue,
    'startedOn': bookingModel.bookingDate,
    'endedOn': bookingModel.completedDate,
    'loadingPoint': bookingModel.loadingPointCity,
    'unloadingPoint': bookingModel.unloadingPointCity,
    'truckType':
        "NA", // truckData['truckType'] == null ? "NA" : truckData['truckType'],
    'productType':
        loadDetails['productType'] == null ? "NA" : loadDetails['productType'],
    'noOfTrucks':
        loadDetails['noOfTrucks'] == null ? "NA" : loadDetails['noOfTrucks'],
    'rate': bookingModel.rateString,
    'bookingId': bookingModel.bookingId,
    // 'transporterName' : transporterData['transporterName'],
    'posterPhoneNum': postLoadIdData['posterPhoneNum'] == null
        ? "NA"
        : postLoadIdData['posterPhoneNum'],
    'posterLocation': postLoadIdData['posterLocation'] == null
        ? "NA"
        : postLoadIdData['posterLocation'],
    'companyName': postLoadIdData['companyName'] == null
        ? "NA"
        : postLoadIdData['companyName'],
    "companyApproved": postLoadIdData['companyApproved'] == null
        ? false
        : postLoadIdData['companyApproved'],
    'posterName': postLoadIdData['posterName'] == null
        ? "NA"
        : postLoadIdData['posterName'],
    'truckNo':
        bookingModel.truckNo, // truckData['truckNo'] == null ? "NA" : truckData['truckNo'],
    'imei': "NA",
    'driverName': bookingModel.driverName,
    'driverPhoneNum': bookingModel.driverPhoneNum
  };

  return cardDataModel;
}
