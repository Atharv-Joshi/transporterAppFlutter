import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/gpsDataController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/screens/displayMap.dart';
import 'package:liveasy/screens/displayMapUsingImei.dart';
import 'package:liveasy/screens/historyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:logger/logger.dart';


// ignore: must_be_immutable
class TrackButton extends StatefulWidget {
  bool truckApproved = false;
  String? phoneNo;
  Position? userLocation;
  String? TruckNo;
  String? imei;
  String? DriverName;
  var gpsData;
  // TrackButton({required this.truckApproved, this.phoneNo, this.userLocation, this.TruckNo, this.imei});
  TrackButton({
    required this.truckApproved,
    this.gpsData,
    this.phoneNo,
    this.userLocation,
    this.TruckNo,
    this.DriverName,
    this.imei
  });

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  String? transporterIDImei;
  final TransporterApiCalls transporterApiCalls = TransporterApiCalls();
  final TruckApiCalls truckApiCalls = TruckApiCalls();

  var truckData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var endTimeParam;
  var startTimeParam;
  MapUtil mapUtil = MapUtil();
  bool loading=false;
  late String from;
  late String to;
  var totalDistance;
  @override
  void initState() {
    super.initState();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30)); //from param
    from = yesterday.toIso8601String();
    DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30)); //to param
    to = now.toIso8601String();

    setState(() {
      loading = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    MapUtil mapUtil = MapUtil();
    return Container(
      height: 31,
      width: 90,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: () async{
            EasyLoading.instance
              ..indicatorType = EasyLoadingIndicatorType.ring
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..maskColor = darkBlueColor
              ..userInteractions = false
              ..backgroundColor = darkBlueColor
              ..dismissOnTap = false;
            EasyLoading.show(
              status: "Loading...",
            );
            gpsDataHistory = await getDataHistory(widget.gpsData.last.deviceId, from , to);
            gpsStoppageHistory = await getStoppageHistory(widget.gpsData.last.deviceId, from , to);
            gpsRoute = await getRouteStatusList(widget.gpsData.last.deviceId, from , to);

            if (gpsRoute!= null) {
              EasyLoading.dismiss();
              Get.to(
                TrackScreen(
                  deviceId:  truckData.deviceId,
                  gpsData: widget.gpsData,
                  // position: position,
                  TruckNo:  truckData.truckNo,
                //  driverName: truckData.driverName,
                //  driverNum: truckData.driverNum,
               //   gpsDataHistory: gpsDataHistory,
                //  gpsStoppageHistory: gpsStoppageHistory,
                //  routeHistory: gpsRoute,
                //  truckId: truckData.truckId,
                  totalDistance: totalDistance,
                ),
              );
            }
            else{
              EasyLoading.dismiss();
              print("gpsData null");
            }
        },
        child: Container(
          margin: EdgeInsets.only(left: space_2),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: space_1),
                child: widget.truckApproved
                    ? Container()
                    : Image(
                        height: 16,
                        width: 11,
                        image: AssetImage('assets/icons/lockIcon.png')),
              ),
              Text(
                'Track',
                style: TextStyle(
                  letterSpacing: 0.7,
                  fontWeight: normalWeight,
                  color: white,
                  fontSize: size_7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}