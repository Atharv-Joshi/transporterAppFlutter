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
    this.imei});

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
  var endTimeParam;
  var startTimeParam;
  MapUtil mapUtil = MapUtil();
  bool loading=false;

  @override
  void initState() {
    super.initState();

    // getTruckHistory();
    setState(() {
      loading = true;
    });
    // getUserLocation();
  }

  getTruckHistory() async{
    var logger = Logger();
    logger.i("in truck history function");

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var nowTime = dateFormat.format(DateTime.now()).split(" ");
    var timestamp = nowTime[0].replaceAll("-", "");
    var year = timestamp.substring(0, 4);
    var month = int.parse(timestamp.substring(4, 6));
    var day = timestamp.substring(6, 8);
    var date = "$day-$month-$year";
    var time = nowTime[1];
    endTimeParam = "$date $time";

    // var yesterday2 = DateTime.now().subtract(Duration(days: 1));
    var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1))).split(" ");
    var timestamp2 = yesterday[0].replaceAll("-", "");
    var year2 = timestamp2.substring(0, 4);
    var month2 = int.parse(timestamp2.substring(4, 6));
    var day2 = timestamp2.substring(6, 8);
    var date2 = "$day2-$month2-$year2";
    var time2 = yesterday[1];
    startTimeParam = "$date2 $time2";
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
            print("LAD $loading");
          // if (loading) {
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
            getTruckHistory();

            gpsDataHistory =
            await mapUtil.getLocationHistoryByImei(
                imei: widget.imei,
                starttime: startTimeParam,
                endtime: endTimeParam,
                choice: "deviceTrackList");
            gpsStoppageHistory =
            await mapUtil.getLocationHistoryByImei(
                imei: widget.imei,
                starttime: startTimeParam,
                endtime: endTimeParam,
                choice: "stoppagesList");
            if (gpsStoppageHistory!= null) {
              EasyLoading.dismiss();
              Get.to(
                TrackScreen(
                  imei:  widget.imei,
                  gpsData: widget.gpsData,
                  // position: position,
                  TruckNo:  widget.TruckNo,
                  driverName: widget.DriverName,
                  driverNum: widget.phoneNo,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
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