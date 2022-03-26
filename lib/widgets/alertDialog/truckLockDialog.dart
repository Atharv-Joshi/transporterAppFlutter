import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/truckApis/truckLockApiCalls.dart';

class TruckLockDialog extends StatefulWidget {
  final List gpsData;
  final List gpsDataHistory;
  final List gpsStoppageHistory;
 // final List routeHistory;
  final String? TruckNo;
  final int? deviceId;
  final String? driverNum;
  final String? driverName;
  final String? truckId;
  String? value;

  TruckLockDialog(
      {required this.gpsData,
      required this.gpsDataHistory,
      required this.gpsStoppageHistory,
    //  required this.routeHistory,
      // required this.position,
      this.TruckNo,
      this.driverName,
      this.driverNum,
      this.deviceId,
      this.truckId,
      this.value});

  @override
  _TruckLockDialogState createState() => _TruckLockDialogState();
}

class _TruckLockDialogState extends State<TruckLockDialog> {
  final lockStorage = GetStorage();
  var lockState;
  var routeHistory;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
            margin: EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Kya aap pakka truck ko ${widget.value} karna chahte hai?".tr,
                    style: TextStyle(fontSize: 20, fontWeight: boldWeight),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Aapke lock karne tak truck unlock hi rahega".tr,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: activeButtonColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: darkBlueColor)))),
                          child: Text(
                            "${widget.value}".tr,
                            // AppLocalizations.of(context)!.next,
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          onPressed: () async {
                            if (widget.value == "Unlock") {
                              await postCommandsApi(
                                      widget.gpsData,
                                      widget.gpsDataHistory,
                                      widget.gpsStoppageHistory,
                                      routeHistory,
                                      widget.driverNum,
                                      widget.TruckNo,
                                      widget.driverName,
                                      widget.truckId,
                                      widget.deviceId,
                                      "engineResume",
                                      "sendingUnlock")
                                  .then((uploadstatus) async {
                                if (uploadstatus == "Success") {
                                  print("SENT UNLOCK TO DEVICE");
                                  lockState = true;
                                  lockStorage.write('lockState', lockState);
                                } else {
                                  print("PROBLEM IN SENDING TO DEVICE");
                                }
                              });
                            } else if (widget.value == "Lock") {
                              await postCommandsApi(
                                      widget.gpsData,
                                      widget.gpsDataHistory,
                                      widget.gpsStoppageHistory,
                                      routeHistory,
                                      widget.driverNum,
                                      widget.TruckNo,
                                      widget.driverName,
                                      widget.truckId,
                                      widget.deviceId,
                                      "engineStop",
                                      "sendingLock")
                                  .then((uploadstatus) async {
                                if (uploadstatus == "Success") {
                                  print("SENT LOCK TO DEVICE");
                                  lockState = false;
                                  lockStorage.write('lockState', lockState);
                                } else {
                                  print("PROBLEM IN SENDING TO DEVICE");
                                }
                              });
                            }
                          }),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: calendarColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                            Get.back();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 45,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        //color: Colors.white, //background color of box
                        BoxShadow(
                          color: darkBlueColor,
                          blurRadius: 50.0, // soften the shadow
                          spreadRadius: 50.0, //extend the shadow
                          offset: Offset(
                            15.0, // Move to right 10  horizontally
                            15.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/icons/smallTruckLockIcon.png",
                          width: 38,
                          height: 38,
                        )),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
