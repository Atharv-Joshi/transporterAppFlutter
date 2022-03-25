import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TruckScreens/myTrucksScreen.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/alertDialog/truckLockDialog.dart';

class TruckLockScreen extends StatefulWidget {
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var routeHistory;
  final String? TruckNo;
  int? deviceId;
  final String? driverNum;
  final String? driverName;
  var truckId;

  TruckLockScreen(
      {required this.gpsData,
      required this.gpsDataHistory,
      required this.gpsStoppageHistory,
      required this.routeHistory,
      // required this.position,
      this.TruckNo,
      this.driverName,
      this.driverNum,
      this.deviceId,
      this.truckId});

  @override
  _TruckLockScreenState createState() => _TruckLockScreenState();
}

class _TruckLockScreenState extends State<TruckLockScreen> {
  var value = ["Unlock", "Lock"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          //padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.fromLTRB(space_18, space_26, space_18, space_0),
                child: Text.rich(
                  TextSpan(
                      text: "Abhi aapka truck ",
                      style: TextStyle(fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: "locked",
                            style: TextStyle(
                                fontWeight: boldWeight, fontSize: 20)),
                        TextSpan(text: " Hai", style: TextStyle(fontSize: 20)),
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: space_12,
              ),
              Container(
                  margin:
                      EdgeInsets.fromLTRB(space_18, space_0, space_18, space_0),
                  child: Image.asset("assets/icons/lockTruckDarkIcon.png")),
              SizedBox(height: space_7),
              Container(
                margin:
                    EdgeInsets.fromLTRB(space_16, space_0, space_16, space_0),
                child: Text.rich(
                  TextSpan(
                      text: "Truck ",
                      style: TextStyle(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: "unlock",
                            style: TextStyle(fontWeight: boldWeight)),
                        TextSpan(
                            text: " krne ke liye button press kijiye!",
                            style: TextStyle(fontSize: 18)),
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: space_10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: activeButtonColor,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: darkBlueColor)))),
                      child: Text(
                        "Unlock Kijiye",

                        // AppLocalizations.of(context)!.next,

                        style: TextStyle(
                          color: white,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => TruckLockDialog(
                                  deviceId: widget.deviceId,
                                  gpsData: widget.gpsData,
                                  // position: position,
                                  TruckNo: widget.TruckNo,
                                  driverName: widget.driverName,
                                  driverNum: widget.driverNum,
                                  gpsDataHistory: widget.gpsDataHistory,
                                  gpsStoppageHistory: widget.gpsStoppageHistory,
                                //  routeHistory: widget.routeHistory,
                                  truckId: widget.truckId,
                                  value: value[0],
                                ));
                      }),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: calendarColor,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: darkBlueColor)))),
                      child: Text(
                        'cancel'.tr,
                        // AppLocalizations.of(context)!.next,
                        style: TextStyle(
                          color: darkBlueColor,
                        ),
                      ),
                      onPressed: () {
                        print("GPSSDATA${widget.truckId}");
                        // Get.to(() => TrackScreen(
                        //       deviceId: widget.deviceId,
                        //       gpsData: widget.gpsData,
                        //       // position: position,
                        //       TruckNo: widget.TruckNo,
                        //       driverName: widget.driverName,
                        //       driverNum: widget.driverNum,
                        //       gpsDataHistory: widget.gpsDataHistory,
                        //       gpsStoppageHistory: widget.gpsStoppageHistory,
                        //       routeHistory: widget.routeHistory,
                        //       truckId: widget.truckId,
                        //     ));
                        Get.to(() => MyTrucks());
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
