import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/trucksNearUserController.dart';
import 'package:liveasy/functions/truckApis/truckLockApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/widgets/MapScreenBarButton.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/allMapWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';

class MapAllTrucks extends StatefulWidget {
  List gpsDataList;
  List deviceList;
  List status;
  List runningDataList;
  List runningGpsDataList;
  List stoppedList;
  List stoppedGpsList;

  MapAllTrucks({
    required this.gpsDataList,
    required this.deviceList,
    required this.status,
    required this.runningDataList,
    required this.runningGpsDataList,
    required this.stoppedGpsList,
    required this.stoppedList,
  });

  @override
  _MapAllTrucksState createState() => _MapAllTrucksState();
}

class _MapAllTrucksState extends State<MapAllTrucks>
    with WidgetsBindingObserver {
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =
      CameraPosition(target: lastlatLngMarker, zoom: 4);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData;
  late List reversedList;
  late List oldGPSData;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  String googleAPiKey = dotenv.get("mapKey");
  bool popUp = false;
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight = 600;
  var direction;
  var maptype = MapType.normal;
  double zoom = 8;

  // var _currentPosition;
  // var customGpsDataList = [];
  // var customDeviceList = [];
  // var customRunningDataList = [];
  // var customRunningGpsDataList = [];
  // var customStoppedList = [];
  // var customStoppedGpsList = [];
  // var rangeDistance;
  // //bool nearStatus = true;

  // TrucksNearUserController trucksNearUserController =
  //     Get.put(TrucksNearUserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // customGpsDataList = widget.gpsDataList;
    // customDeviceList = widget.deviceList;
    // customRunningDataList = widget.runningDataList;
    // customRunningGpsDataList = widget.runningGpsDataList;
    // customStoppedList = widget.stoppedList;
    // customStoppedGpsList = widget.stoppedGpsList;
    // customGpsDataList = [];
    // customDeviceList = [];
    // customRunningDataList = [];
    // customRunningGpsDataList = [];
    // customStoppedList = [];
    // customStoppedGpsList = [];
    //_getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");

    _controller.complete(controller);

    _customInfoWindowController.googleMapController = controller;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await _controller.future;
        onMapCreated(controller);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  //function called every one minute
/*  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");

    iconthenmarker();
  }
    void iconthenmarker() {
    logger.i("in Icon maker function");
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/truckPin.png')
        .then((value) => {
      setState(() {
        pinLocationIconTruck = value;
      }),
      for(int i =0;i<widget.gpsDataList.length;i++)
    {
      createmarker(widget.gpsDataList[i],widget.truckDataList[i]),
    }

    });
  }
  void createmarker(List gpsData,TruckModel truckData) async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
      LatLng(gpsData.last.lat, gpsData.last.lng);
      print("Live location is ${gpsData.last.lat}");
      String? title = truckData.truckNo;
      setState(() {
        direction = 180 + double.parse(gpsData.last.direction);
        lastlatLngMarker = LatLng(gpsData.last.lat, gpsData.last.lng);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(gpsData.last.id.toString()),
            position: latLngMarker,
            infoWindow: InfoWindow(title: title),
            icon: pinLocationIconTruck,
        rotation: direction));

      });
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: lastlatLngMarker,
          zoom: zoom,
        ),
      ));
    } catch (e) {
      print("Exceptionis $e");
    }
  }

  @override
  void dispose() {
    logger.i("Activity is disposed");
    timer.cancel();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double threshold = 100;
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child:
              // Obx(
              //   () =>
              Column(children: [
            Row(children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(space_4, space_10, 0, space_4),
                  child: Image.asset(
                    'assets/icons/navigationIcons/goBack.png',
                    width: 11,
                    height: 21,
                  ),
                ),
              ),
              Container(
                  margin:
                      EdgeInsets.fromLTRB(space_4, space_10, space_4, space_4),
                  width: MediaQuery.of(context).size.width - 85,
                  child: SearchLoadWidget(
                    hintText: 'Search',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => NextUpdateAlertDialog());
                    },
                  )),
            ]),
            Container(
              //    height: 26,
              //    width: 200,
              //  padding: EdgeInsets.fromLTRB(5,5,5,5),
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.fromLTRB(space_6, 0, space_6, space_4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEFEFEF),
                    blurRadius: 9,
                    offset: Offset(0, 2),
                  ),
                ],
                color: const Color(0xFFF7F8FA),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MapScreenBarButton(
                      text: 'All', value: 0, pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  MapScreenBarButton(
                      text: 'Running',
                      value: 1,
                      pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  MapScreenBarButton(
                      text: 'Stopped',
                      value: 2,
                      pageController: pageController),
                ],
              ),
            ),
            // Obx(
            //   () =>
            Container(
                height: MediaQuery.of(context).size.height - 125,
                child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        providerData.updateUpperNavigatorIndex(value);
                        print("IN TRUEE PAGE PAGE");
                      });
                    },
                    children: [
                      AllMapWidget(
                        gpsDataList: widget.gpsDataList,
                        truckDataList: widget.deviceList,
                        status: widget.status,
                      ),
                      AllMapWidget(
                        gpsDataList: widget.runningGpsDataList,
                        truckDataList: widget.runningDataList,
                        status: widget.status,
                      ),
                      AllMapWidget(
                        gpsDataList: widget.stoppedGpsList,
                        truckDataList: widget.stoppedList,
                        status: widget.status,
                      ),
                    ])
                // trucksNearUserController.nearStatus.value
                //     ? PageView(
                //         controller: pageController,
                //         onPageChanged: (value) {
                //           setState(() {
                //             providerData.updateUpperNavigatorIndex(value);
                //             print("IN TRUEE PAGE PAGE");
                //           });
                //         },
                //         children: [
                //             AllMapWidget(
                //                 gpsDataList: widget.gpsDataList,
                //                 truckDataList: widget.deviceList),
                //             AllMapWidget(
                //                 gpsDataList: widget.runningGpsDataList,
                //                 truckDataList: widget.runningDataList),
                //             AllMapWidget(
                //                 gpsDataList: widget.stoppedGpsList,
                //                 truckDataList: widget.stoppedList),
                //           ])
                //     // : Container()
                //     : PageView(
                //         controller: pageController,
                //         onPageChanged: (value) {
                //           setState(() {
                //             providerData.updateUpperNavigatorIndex(value);
                //             print("INTO THE SELECTION  . .");
                //             mapAllTrucksNearUser();
                //           });
                //         },
                //         children: [
                //             AllMapWidget(
                //                 gpsDataList: customGpsDataList,
                //                 truckDataList: customDeviceList),
                //             AllMapWidget(
                //                 gpsDataList: customRunningGpsDataList,
                //                 truckDataList: customRunningDataList),
                //             AllMapWidget(
                //                 gpsDataList: customStoppedGpsList,
                //                 truckDataList: customStoppedList),
                //           ])
                ),
            //),
          ]),
          //)
        ),
      ),
    );
  }

// _getCurrentLocation() {
//   Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best,
//           forceAndroidLocationManager: true)
//       .then((Position position) {
//     setState(() {
//       _currentPosition = position;
//       print(
//           "CURRENT LOCATION IS ${_currentPosition.latitude} AND ${_currentPosition.longitude}");
//       //widget.gpsDataList[1].latitude
//       print(
//           "CURRENT LOCATION IS ${widget.gpsDataList[1].latitude} AND ${widget.gpsDataList[1].longitude}");
//     });
//   }).catchError((e) {
//     print(e);
//   });
// }

// void mapAllTrucksNearUser() {
//   // customGpsDataList = [];
//   // customDeviceList = [];
//   // customRunningDataList = [];
//   // customRunningGpsDataList = [];
//   // customStoppedList = [];
//   // customStoppedGpsList = [];

//   var customGpsDataListDummy = [];
//   var customDeviceListDummy = [];
//   var customRunningDataListDummy = [];
//   var customRunningGpsDataListDummy = [];
//   var customStoppedListDummy = [];
//   var customStoppedGpsListDummy = [];

//   print("INSIDE THE MAP_ALLFUNCTION");
//   print(trucksNearUserController.distanceRadius.value);
//   print(
//       "THE CONTENT IS ${widget.gpsDataList[0]} and the lenght is ${widget.gpsDataList.length}");
//   //var j = 0;
//   for (var i = 0; i < widget.gpsDataList.length; i++) {
//     print(widget.gpsDataList[i]);
//     var distanceStore = Geolocator.distanceBetween(
//             widget.gpsDataList[i].latitude,
//             widget.gpsDataList[i].longitude,
//             _currentPosition.latitude,
//             _currentPosition.longitude) /
//         1000;
//     print(distanceStore);
//     print("THE CODE VALUE ${trucksNearUserController.distanceRadius.value}");
//     if (distanceStore <= trucksNearUserController.distanceRadius.value) {
//       print("TRYINGGGGGG");
//       customGpsDataListDummy.add(widget.gpsDataList[i]);
//       customDeviceListDummy.add(widget.deviceList[i]);
//       // customRunningDataListDummy.add(widget.runningDataList[i]);
//       // customRunningGpsDataListDummy.add(widget.runningGpsDataList[i]);
//       // customStoppedListDummy.add(widget.stoppedList[i]);
//       // customStoppedGpsListDummy.add(widget.stoppedGpsList[i]);
//     }
//     // else {
//     //   print("STILL TRYINGGGGGG");
//     //   print(distanceStore);
//     //   customGpsDataList[i] = [];
//     //   customDeviceList[i] = [];
//     //   customRunningDataList[i] = [];
//     //   customRunningGpsDataList[i] = [];
//     //   customStoppedList[i] = [];
//     //   customStoppedGpsList[i] = [];
//     // }
//   }

//   // if (widget.runningDataList[0] != null) {
//   //   for (var i = 0; i < widget.runningDataList.length; i++) {
//   //     print(widget.runningDataList[i]);
//   //     var distanceStore = Geolocator.distanceBetween(
//   //             widget.runningDataList[i].latitude,
//   //             widget.runningDataList[i].longitude,
//   //             _currentPosition.latitude,
//   //             _currentPosition.longitude) /
//   //         1000;
//   //     print(distanceStore);
//   //     print(
//   //         "THE RUNNING CODE VALUE ${trucksNearUserController.distanceRadius.value}");
//   //     if (distanceStore <= trucksNearUserController.distanceRadius.value) {
//   //       print("TRYINGGGGGG IN RUNNING");
//   //       // customGpsDataListDummy.add(widget.gpsDataList[i]);
//   //       // customDeviceListDummy.add(widget.deviceList[i]);
//   //       customRunningDataListDummy.add(widget.runningDataList[i]);
//   //       customRunningGpsDataListDummy.add(widget.runningGpsDataList[i]);
//   //       // customStoppedListDummy.add(widget.stoppedList[i]);
//   //       // customStoppedGpsListDummy.add(widget.stoppedGpsList[i]);
//   //     }
//   //   }
//   // }

//   // for (var i = 0; i < widget.runningDataList.length; i++) {
//   //   print(widget.runningDataList[i]);
//   //   var distanceStore = Geolocator.distanceBetween(
//   //           widget.runningDataList[i].latitude,
//   //           widget.runningDataList[i].longitude,
//   //           _currentPosition.latitude,
//   //           _currentPosition.longitude) /
//   //       1000;
//   //   print(distanceStore);
//   //   print("THE CODE VALUE ${trucksNearUserController.distanceRadius.value}");
//   //   if (distanceStore <= trucksNearUserController.distanceRadius.value) {
//   //     print("TRYINGGGGGG");
//   //     // customGpsDataListDummy.add(widget.gpsDataList[i]);
//   //     // customDeviceListDummy.add(widget.deviceList[i]);
//   //     customRunningDataListDummy.add(widget.runningDataList[i]);
//   //     customRunningGpsDataListDummy.add(widget.runningGpsDataList[i]);
//   //     // customStoppedListDummy.add(widget.stoppedList[i]);
//   //     // customStoppedGpsListDummy.add(widget.stoppedGpsList[i]);
//   //   }
//   // }

//   // for (var i = 0; i < widget.stoppedList.length; i++) {
//   //   print(widget.stoppedList[i]);
//   //   var distanceStore = Geolocator.distanceBetween(
//   //           widget.stoppedList[i].latitude,
//   //           widget.stoppedList[i].longitude,
//   //           _currentPosition.latitude,
//   //           _currentPosition.longitude) /
//   //       1000;
//   //   print(distanceStore);
//   //   print("THE CODE VALUE ${trucksNearUserController.distanceRadius.value}");
//   //   if (distanceStore <= trucksNearUserController.distanceRadius.value) {
//   //     print("TRYINGGGGGG");
//   //     // customGpsDataListDummy.add(widget.gpsDataList[i]);
//   //     // customDeviceListDummy.add(widget.deviceList[i]);
//   //     // customRunningDataListDummy.add(widget.runningDataList[i]);
//   //     // customRunningGpsDataListDummy.add(widget.runningGpsDataList[i]);
//   //     customStoppedListDummy.add(widget.stoppedList[i]);
//   //     customStoppedGpsListDummy.add(widget.stoppedGpsList[i]);
//   //   }
//   // }

//   setState(() {
//     customGpsDataList = [];
//     customDeviceList = [];
//     customRunningDataList = [];
//     customRunningGpsDataList = [];
//     customStoppedList = [];
//     customStoppedGpsList = [];

//     customGpsDataList.addAll(customGpsDataListDummy);
//     customDeviceList.addAll(customDeviceListDummy);
//     customRunningDataList.addAll(customRunningDataListDummy);
//     customRunningGpsDataList.addAll(customRunningGpsDataListDummy);
//     customStoppedList.addAll(customStoppedListDummy);
//     customStoppedGpsList.addAll(customStoppedGpsListDummy);
//     print("THE NEW LIST HAS ${customGpsDataList}");
//     AllMapWidget(
//         gpsDataList: customGpsDataList, truckDataList: customGpsDataList);
//   });
//   //print("OUT OF FORRRR");
//   return;
// }

// double calculateDistance(lat1, lon1, lat2, lon2) {
//   var p = 0.017453292519943295;
//   var c = cos;
//   var a = 0.5 -
//       c((lat2 - lat1) * p) / 2 +
//       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//   return 12742 * asin(sqrt(a));
// }
}
