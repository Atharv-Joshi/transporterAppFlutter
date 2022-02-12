// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:liveasy/constants/color.dart';
// import 'package:liveasy/constants/fontSize.dart';
// import 'package:liveasy/constants/fontWeights.dart';
// import 'package:liveasy/constants/spaces.dart';
// import 'package:liveasy/screens/TruckScreens/myTrucksScreen.dart';
// import 'package:liveasy/screens/navigationScreen.dart';
// import 'package:liveasy/screens/trackScreen.dart';
// import 'package:liveasy/widgets/alertDialog/truckLockDialog.dart';

// class TruckUnlockScreen extends StatefulWidget {
//   final int? deviceId;
//   final List gpsData;
//   var gpsDataHistory;
//   var gpsStoppageHistory;
//   var routeHistory;
//   final String? TruckNo;
//   final String? driverNum;
//   final String? driverName;
//   var truckId;

//   TruckUnlockScreen({
//     required this.gpsData,
//     required this.gpsDataHistory,
//     required this.gpsStoppageHistory,
//     required this.routeHistory,
//     // required this.position,
//     this.TruckNo,
//     this.driverName,
//     this.driverNum,
//     this.deviceId,
//     this.truckId,
//   });

//   @override
//   _TruckUnlockScreenState createState() => _TruckUnlockScreenState();
// }

// class _TruckUnlockScreenState extends State<TruckUnlockScreen> {
//   var value = ["Unlock", "Lock"];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           //padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 // margin: EdgeInsets.only(bottom: space_10),
//                 width: MediaQuery.of(context).size.width,
//                 height: space_13,
//                 color: white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.to(() => NavigationScreen());
//                         },
//                         child: Icon(Icons.arrow_back_ios_rounded),
//                       ),
//                     ),
//                     //HelpButtonWidget(),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin:
//                     EdgeInsets.fromLTRB(space_18, space_14, space_18, space_0),
//                 child: Text.rich(
//                   TextSpan(
//                       text: "Abhi aapka truck ",
//                       style: TextStyle(fontSize: 20),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: "unlocked",
//                             style: TextStyle(
//                                 fontWeight: boldWeight, fontSize: 20)),
//                         TextSpan(text: " Hai", style: TextStyle(fontSize: 20)),
//                       ]),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(
//                 height: space_12,
//               ),
//               Container(
//                   margin:
//                       EdgeInsets.fromLTRB(space_18, space_0, space_18, space_0),
//                   child: Image.asset("assets/icons/unlockTruckLightIcon.png")),
//               SizedBox(height: space_7),
//               Container(
//                 margin:
//                     EdgeInsets.fromLTRB(space_16, space_0, space_16, space_0),
//                 child: Text.rich(
//                   TextSpan(
//                       text: "Truck ",
//                       style: TextStyle(fontSize: 18),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: "Lock",
//                             style: TextStyle(fontWeight: boldWeight)),
//                         TextSpan(
//                             text: " krne ke liye button press kijiye!",
//                             style: TextStyle(fontSize: 18)),
//                       ]),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(
//                 height: space_10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: activeButtonColor,
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15.0),
//                                       side: BorderSide(color: darkBlueColor)))),
//                       child: Text(
//                         "Lock Kijiye",

//                         // AppLocalizations.of(context)!.next,

//                         style: TextStyle(
//                           color: white,
//                         ),
//                       ),
//                       onPressed: () {
//                         showDialog(
//                             context: context,
//                             builder: (context) => TruckLockDialog(
//                                   deviceId: widget.deviceId,
//                                   gpsData: widget.gpsData,
//                                   // position: position,
//                                   TruckNo: widget.TruckNo,
//                                   driverName: widget.driverName,
//                                   driverNum: widget.driverNum,
//                                   gpsDataHistory: widget.gpsDataHistory,
//                                   gpsStoppageHistory: widget.gpsStoppageHistory,
//                                   routeHistory: widget.routeHistory,
//                                   truckId: widget.truckId,
//                                   value: value[1],
//                                 ));
//                       }),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: calendarColor,
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18.0),
//                                       side: BorderSide(color: darkBlueColor)))),
//                       child: Text(
//                         'cancel'.tr,
//                         // AppLocalizations.of(context)!.next,
//                         style: TextStyle(
//                           color: darkBlueColor,
//                         ),
//                       ),
//                       onPressed: () {
//                         // Get.to(() => TrackScreen(
//                         //       deviceId: widget.deviceId,
//                         //       gpsData: widget.gpsData,
//                         //       // position: position,
//                         //       TruckNo: widget.TruckNo,
//                         //       driverName: widget.driverName,
//                         //       driverNum: widget.driverNum,
//                         //       gpsDataHistory: widget.gpsDataHistory,
//                         //       gpsStoppageHistory: widget.gpsStoppageHistory,
//                         //       routeHistory: widget.routeHistory,
//                         //       truckId: widget.truckId,
//                         //     ));
//                         //Get.to(() => MyTrucks());
//                         //Get.back();
//                         // Get.to(() => NavigationScreen());
//                         Get.back();
//                         Get.back();
//                       }),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
