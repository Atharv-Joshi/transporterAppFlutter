import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/playRouteHistoryScreen.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:url_launcher/url_launcher.dart';


class TrackScreenDetails extends StatefulWidget {
  final String? driverNum;
  final String? TruckNo;
  final String? driverName;
  String? dateRange;
  var gpsData;
  var gpsTruckRoute;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var totalDistance;
  var stops;
  var totalRunningTime;
  var totalStoppedTime;
  final String? truckDate;

  TrackScreenDetails({
    required this.gpsData,
    required this.gpsTruckRoute,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    required this.driverNum,
    required this.dateRange,
    required this.TruckNo,
    required this.driverName,
    required this.totalDistance,
    required this.stops,
    required this.truckDate,
    required this.totalRunningTime,
    required this.totalStoppedTime,
  });

  @override
  _TrackScreenDetailsState createState() => _TrackScreenDetailsState();
}

class _TrackScreenDetailsState extends State<TrackScreenDetails> {
  var gpsData;
  var gpsTruckRoute;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var totalDistance;
  var stops;
  var totalRunningTime;
  var totalStoppedTime;

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  initFunction(){
    setState(() {
      gpsData = widget.gpsData;
      gpsTruckRoute = widget.gpsTruckRoute;
      gpsDataHistory = widget.gpsDataHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
      totalDistance = widget.totalDistance;
      stops = widget.stops;
      totalRunningTime = widget.totalRunningTime;
      totalStoppedTime = widget.totalStoppedTime;
    });
    print("New ${totalRunningTime}");

  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
          height:  height/3 + 75,
          width: width,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
              ),
              boxShadow: [
                BoxShadow(
                  color: darkShadow,
                  offset: const Offset(0, -5.0,),
                  blurRadius: 15.0,
                  spreadRadius: 10.0,
                ),
                BoxShadow(
                  color: white,
                  offset: const Offset(0, 1.0),
                  blurRadius: 0.0,
                  spreadRadius: 2.0,
                ),
              ]
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // height: space_11,

                  padding: EdgeInsets.fromLTRB(size_10, size_10, 0, 0),
                  margin: EdgeInsets.only(bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.place_outlined ,
                        color: bidBackground,
                        size: 27
                      ),
                      SizedBox(
                          width: 10
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 260,
                            child: Text(
                              "${gpsData.last.address}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: normalWeight
                              ),
                            ),
                          ),
                          //
                        ],
                      )
                    ],
                  ),

                ),
                  Divider(
                    color: black,
                    // height: size_3,
                    thickness: 0.75,
                    indent: size_10,
                    endIndent: size_10,
                  ),
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(left: 15, right: 15),
                  margin: EdgeInsets.fromLTRB(0, space_2, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "button1",
                            backgroundColor: bidBackground,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.near_me_outlined, size: 30),
                            onPressed: () {
                              openMap(gpsData.last.lat, gpsData.last.lng);
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Navigate",
                            style: TextStyle(
                                color: black,
                                fontSize: size_6,
                                fontStyle: FontStyle.normal,
                                fontWeight: mediumBoldWeight
                            ),
                          ),
                          SizedBox(
                            height: space_5,
                          ),
                          FloatingActionButton(
                            heroTag: "button2",
                            backgroundColor: bidBackground,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.share_outlined, size: 30),
                            onPressed: () {
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                                color: black,
                                fontSize: size_6,
                                fontStyle: FontStyle.normal,
                                fontWeight: mediumBoldWeight
                            ),
                          ),
                          SizedBox(
                            height: space_5,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "button3",
                            backgroundColor: bidBackground,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.play_circle_outline, size: 30),
                            onPressed: () {
                              Get.to(PlayRouteHistory(
                                gpsTruckHistory: gpsDataHistory,
                                truckNo: widget.TruckNo,
                                routeHistory: gpsTruckRoute,
                                gpsData: gpsData,
                                dateRange: widget.dateRange,
                                gpsStoppageHistory: gpsStoppageHistory,
                                totalDistance: totalDistance,
                                totalRunningTime: totalRunningTime,
                                totalStoppedTime: totalStoppedTime,
                              ));
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Play Trip",
                            style: TextStyle(
                                color: black,
                                fontSize: size_6,
                                fontStyle: FontStyle.normal,
                                fontWeight: mediumBoldWeight
                            ),
                          ),
                          SizedBox(
                            height: space_5,
                          ),
                          FloatingActionButton(
                            heroTag: "button4",
                            backgroundColor: bidBackground,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.history, size: 30),
                            onPressed: () {
                              Get.to(TruckHistoryScreen(
                                truckNo: widget.TruckNo,
                                gpsTruckRoute: gpsTruckRoute,
                                dateRange: widget.dateRange,
                                imei: gpsData.last.imei,
                              ));
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "History",
                            style: TextStyle(
                                color: black,
                                fontSize: size_6,
                                fontStyle: FontStyle.normal,
                                fontWeight: mediumBoldWeight
                            ),
                          ),
                          SizedBox(
                            height: space_5,
                          ),
                        ],
                      ),
                    ],
                  )
                )
              ]
          ),
        );
  }
}
