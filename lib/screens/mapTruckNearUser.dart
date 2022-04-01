// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:liveasy/constants/spaces.dart';
// import 'package:liveasy/providerClass/providerData.dart';
// import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
// import 'package:liveasy/widgets/MapScreenBarButton.dart';
// import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
// import 'package:liveasy/widgets/allMapWidget.dart';
// import 'package:liveasy/widgets/searchLoadWidget.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter_config/flutter_config.dart';

// class MapTruckNearUser extends StatefulWidget {
//   List gpsDataList;
//   List deviceList;
//   List runningDataList;
//   List runningGpsDataList;
//   List stoppedList;
//   List stoppedGpsList;

//   MapTruckNearUser({
//     required this.gpsDataList,
//     required this.deviceList,
//     required this.runningDataList,
//     required this.runningGpsDataList,
//     required this.stoppedGpsList,
//     required this.stoppedList,
//   });

//   @override
//   _MapTruckNearUserState createState() => _MapTruckNearUserState();
// }

// class _MapTruckNearUserState extends State<MapTruckNearUser>
//     with WidgetsBindingObserver {
//   late GoogleMapController _googleMapController;
//   late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
//   late List<Placemark> placemarks;
//   Iterable markers = [];
//   ScreenshotController screenshotController = ScreenshotController();
//   late BitmapDescriptor pinLocationIcon;
//   late BitmapDescriptor pinLocationIconTruck;
//   late CameraPosition camPosition =
//       CameraPosition(target: lastlatLngMarker, zoom: 4);
//   var logger = Logger();
//   late Marker markernew;
//   List<Marker> customMarkers = [];
//   late Timer timer;
//   Completer<GoogleMapController> _controller = Completer();
//   late List newGPSData;
//   late List reversedList;
//   late List oldGPSData;
//   MapUtil mapUtil = MapUtil();
//   List<LatLng> latlng = [];
//   String googleAPiKey = FlutterConfig.get("mapKey");
//   bool popUp = false;
//   late Uint8List markerIcon;
//   var markerslist;
//   CustomInfoWindowController _customInfoWindowController =
//       CustomInfoWindowController();
//   bool isAnimation = false;
//   double mapHeight = 600;
//   var direction;
//   var maptype = MapType.normal;
//   double zoom = 8;
//   var _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//   }

//   void onMapCreated(GoogleMapController controller) {
//     controller.setMapStyle("[]");

//     _controller.complete(controller);

//     _customInfoWindowController.googleMapController = controller;
//   }

//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.inactive:
//         print('appLifeCycleState inactive');
//         break;
//       case AppLifecycleState.resumed:
//         final GoogleMapController controller = await _controller.future;
//         onMapCreated(controller);
//         print('appLifeCycleState resumed');
//         break;
//       case AppLifecycleState.paused:
//         print('appLifeCycleState paused');
//         break;
//       case AppLifecycleState.detached:
//         print('appLifeCycleState detached');
//         break;
//     }
//   }

// /////////////////////////////////////////////////////////////////////////////////
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double threshold = 100;
//     ProviderData providerData = Provider.of<ProviderData>(context);
//     PageController pageController =
//         PageController(initialPage: providerData.upperNavigatorIndex);
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(children: [
//             Row(children: [
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(space_4, space_10, 0, space_4),
//                   child: Image.asset(
//                     'assets/icons/navigationIcons/goBack.png',
//                     width: 11,
//                     height: 21,
//                   ),
//                 ),
//               ),
//               Container(
//                   margin:
//                       EdgeInsets.fromLTRB(space_4, space_10, space_4, space_4),
//                   width: MediaQuery.of(context).size.width - 85,
//                   child: SearchLoadWidget(
//                     hintText: 'Search',
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (context) => NextUpdateAlertDialog());
//                     },
//                   )),
//             ]),
//             Container(
//               //    height: 26,
//               //    width: 200,
//               //  padding: EdgeInsets.fromLTRB(5,5,5,5),
//               padding: EdgeInsets.all(0),
//               margin: EdgeInsets.fromLTRB(space_6, 0, space_6, space_4),
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFEFEFEF),
//                     blurRadius: 9,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//                 color: const Color(0xFFF7F8FA),
//               ),

//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MapScreenBarButton(
//                       text: 'All', value: 0, pageController: pageController),
//                   Container(
//                     padding: EdgeInsets.all(0),
//                     width: 1,
//                     height: 15,
//                     color: const Color(0xFFC2C2C2),
//                   ),
//                   MapScreenBarButton(
//                       text: 'Running',
//                       value: 1,
//                       pageController: pageController),
//                   Container(
//                     padding: EdgeInsets.all(0),
//                     width: 1,
//                     height: 15,
//                     color: const Color(0xFFC2C2C2),
//                   ),
//                   MapScreenBarButton(
//                       text: 'Stopped',
//                       value: 2,
//                       pageController: pageController),
//                 ],
//               ),
//             ),
//             Container(
//                 height: MediaQuery.of(context).size.height - 125,
//                 child: PageView(
//                     controller: pageController,
//                     onPageChanged: (value) {
//                       setState(() {
//                         providerData.updateUpperNavigatorIndex(value);
//                       });
//                     },
//                     children: [
//                       AllMapWidget(
//                           gpsDataList: widget.gpsDataList,
//                           truckDataList: widget.deviceList),
//                       AllMapWidget(
//                           gpsDataList: widget.runningGpsDataList,
//                           truckDataList: widget.runningDataList),
//                       AllMapWidget(
//                           gpsDataList: widget.stoppedGpsList,
//                           truckDataList: widget.stoppedList),
//                     ])),
//           ]),
//         ),
//       ),
//     );
//   }

//   _getCurrentLocation() {
//     Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.best,
//             forceAndroidLocationManager: true)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//         print("CUURENT LOCATION IS $_currentPosition");
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }
// }
