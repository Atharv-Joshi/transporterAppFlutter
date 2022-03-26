import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TruckScreens/myTrucksScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/alertDialog/truckLockDialog.dart';

class TruckLockUnlock extends StatefulWidget {
  final int? deviceId;
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
 // var routeHistory;
  final String? TruckNo;
  final String? driverNum;
  final String? driverName;
  var truckId;

  TruckLockUnlock({
    required this.gpsData,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
  //  required this.routeHistory,
    // required this.position,
    this.TruckNo,
    this.driverName,
    this.driverNum,
    this.deviceId,
    this.truckId,
  });

  @override
  _TruckLockUnlockState createState() => _TruckLockUnlockState();
}

class _TruckLockUnlockState extends State<TruckLockUnlock> {
  var value = ["Unlock", "Lock"];
  final lockStorage = GetStorage();
  var lockState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lockState = lockStorage.read('lockState');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // margin: EdgeInsets.only(bottom: space_10),
              width: MediaQuery.of(context).size.width,
              height: space_13,
              color: white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios_rounded),
                    ),
                  ),
                ],
              ),
            ),
            lockState
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            space_18, space_14, space_18, space_0),
                        child: Text.rich(
                          TextSpan(
                              text: "Abhi aapka truck ".tr,
                              style: TextStyle(fontSize: 20),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "unlocked".tr,
                                    style: TextStyle(
                                        fontWeight: boldWeight, fontSize: 20)),
                                TextSpan(
                                    text: " Hai".tr,
                                    style: TextStyle(fontSize: 20)),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: space_12,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              space_18, space_0, space_18, space_0),
                          child: Image.asset(
                              "assets/icons/unlockTruckLightIcon.png")),
                      SizedBox(height: space_7),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            space_16, space_0, space_16, space_0),
                        child: Text.rich(
                          TextSpan(
                              text: "Truck ".tr,
                              style: TextStyle(fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Lock".tr,
                                    style: TextStyle(fontWeight: boldWeight)),
                                TextSpan(
                                    text:
                                        " krne ke liye button press kijiye!".tr,
                                    style: TextStyle(fontSize: 18)),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            space_18, space_14, space_18, space_0),
                        child: Text.rich(
                          TextSpan(
                              text: "Abhi aapka truck ".tr,
                              style: TextStyle(fontSize: 20),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Locked".tr,
                                    style: TextStyle(
                                        fontWeight: boldWeight, fontSize: 20)),
                                TextSpan(
                                    text: " Hai".tr,
                                    style: TextStyle(fontSize: 20)),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: space_12,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              space_18, space_0, space_18, space_0),
                          child: Image.asset(
                              "assets/icons/lockTruckDarkIcon.png")),
                      SizedBox(height: space_7),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            space_16, space_0, space_16, space_0),
                        child: Text.rich(
                          TextSpan(
                              text: "Truck ".tr,
                              style: TextStyle(fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "unlock".tr,
                                    style: TextStyle(fontWeight: boldWeight)),
                                TextSpan(
                                    text:
                                        " krne ke liye button press kijiye!".tr,
                                    style: TextStyle(fontSize: 18)),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: space_10,
                      ),
                    ],
                  ),
            lockState
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: activeButtonColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: darkBlueColor)))),
                          child: Text(
                            "Lock Kijiye".tr,
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              lockState = lockStorage.read('lockState');
                              print("SETHEEREEEEEEE");
                            });
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
                                      gpsStoppageHistory:
                                          widget.gpsStoppageHistory,
                                    //  routeHistory: widget.routeHistory,
                                      truckId: widget.truckId,
                                      value: value[1],
                                    )).whenComplete(() => setState(() {
                                  lockState = lockStorage.read('lockState');
                                  print("SETHEEREEEEEEE");
                                }));
                          }),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: deactiveButtonColor,
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: darkBlueColor)))),
                        child: Text(
                          "Unlock Kijiye".tr,
                          style: TextStyle(
                            color: darkBlueColor,
                          ),
                        ),
                        onPressed: null,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: deactiveButtonColor,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: darkBlueColor)))),
                          child: Text(
                            "Lock Kijiye".tr,
                            style: TextStyle(
                              color: darkBlueColor,
                            ),
                          ),
                          onPressed: null),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: activeButtonColor,
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: darkBlueColor)))),
                        child: Text(
                          "Unlock Kijiye".tr,
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            lockState = lockStorage.read('lockState');
                            print("SETSTATEEEEEEEEEEEEE");
                          });
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
                                    gpsStoppageHistory:
                                        widget.gpsStoppageHistory,
                                  //  routeHistory: widget.routeHistory,
                                    truckId: widget.truckId,
                                    value: value[0],
                                  )).whenComplete(() => setState(() {
                                lockState = lockStorage.read('lockState');
                                print("SETSTATEEEEEEEE");
                              }));
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ));
  }
}
