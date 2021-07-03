import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';

postBidAPi(loadId, rate, transporterIdController, unit) async {
  String now = DateFormat("dd-MM-yyyy").format(DateTime.now());

  if (unit == "RadioButtonOptions.PER_TON") {
    unit = "PER_TON";
  }
  if (unit == "RadioButtonOptions.PER_TRUCK") {
    unit = "PER_TRUCK";
  }
  Map data = {
    "transporterId": transporterIdController.toString(),
    "loadId": loadId.toString(),
    "rate": rate.toString(),
    "unitValue": unit.toString(),
    "biddingDate": now.toString(),
    // "transporterApproval": true,
    // "shipperApproval": false,
    // "truckId": []
  };
  String body = json.encode(data);
  final String bidApiUrl = FlutterConfig.get('biddingApiUrl').toString();
  final response = await http.post(Uri.parse("$bidApiUrl"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  print(response.body);
}

putBidForAccept(String? bidId) async {

  final String bidApiUrl = FlutterConfig.get('biddingApiUrl');
  print('putBidUrl: $bidApiUrl/$bidId');

  Map<String , bool> data = {
    'shipperApproval' : true
  };

  String body = json.encode(data);

  final response = await http.put(Uri.parse("$bidApiUrl/$bidId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);

  print(response.body);
}

putBidForNegotiate(String? bidId , String? rate , String? unitValue) async {


  //TODO: This can be done in a better way later on
  if (unitValue == "RadioButtonOptions.PER_TON") {
    unitValue = "PER_TON";
  }
  if (unitValue == "RadioButtonOptions.PER_TRUCK") {
    unitValue = "PER_TRUCK";
  }

  final String bidApiUrl = FlutterConfig.get('biddingApiUrl');

  Map<String , dynamic> data = {
    "rate" : rate,
    "unitValue" : unitValue,
    'shipperApproval' : true
  };

  String body = json.encode(data);

  final response = await http.put(Uri.parse("$bidApiUrl/$bidId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);

  print(response.body);
}