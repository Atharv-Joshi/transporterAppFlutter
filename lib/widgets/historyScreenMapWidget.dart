import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

class HistoryScreenMapWidget extends StatefulWidget {
  // final List gpsData;
  final routeHistory;

  //final gpsHistory;
  var truckNo;
  var deviceId;
  var selectedlocation;
  var gpsDataHistory;
  var gpsStoppageHistory;

  HistoryScreenMapWidget({
    //  required this.gpsData,
    required this.routeHistory,
    //required this.gpsHistory,
    required this.deviceId,
    required this.truckNo,
    required this.selectedlocation,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
  });

  @override
  _HistoryScreenMapWidgetState createState() => _HistoryScreenMapWidgetState();
}

class _HistoryScreenMapWidgetState extends State<HistoryScreenMapWidget>
    with WidgetsBindingObserver {
  final Set<Polyline> _polyline1 = new Set<Polyline>();
  Map<PolylineId, Polyline> polylines1 = new Map<PolylineId, Polyline>();
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =
      CameraPosition(target: lastlatLngMarker, zoom: 8);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  Completer<GoogleMapController> _controller = Completer();

  // late List newGPSData=widget.gpsData;
  late List reversedList;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];

  List<LatLng> polylineCoordinates1 = [];
  List<LatLng> polylineCoordinates2 = [];
  // PolylinePoints polylinePoints1 = PolylinePoints();
  late LatLng start;
  late LatLng end;
  String? truckAddress;
  double averagelat = 0;
  double averagelon = 0;
  String? truckDate;
  bool zoombutton = false;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var newGPSRoute;
  var totalDistance;
  var stoppageTime = [];
  List<LatLng> stoplatlong = [];
  List<String> _locations = [
    '24 hours',
    '48 hours',
    '7 days',
    '14 days',
    '30 days'
  ];
  String _selectedLocation = '24 hours';
  var duration = [];
  var stopAddress = [];
  String? Speed;
  // String googleAPiKey = FlutterConfig.get("mapKey");
  String googleAPiKey = dotenv.get('mapKey');
  bool popUp = false;
  // List<PolylineWayPoint> waypoints = [];
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight = 600;
  DateTimeRange selectedDate = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 1)), end: DateTime.now());
  var direction;
  bool setDate = false;
  var selectedDateString = [];
  var maptype = MapType.normal;
  double zoom = 15;
  bool showBottomMenu = true;
  var totalRunningTime;
  var totalStoppedTime;
  var status;
  var col1 = Color(0xff878787);
  var col2 = Color(0xffFF5C00);
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    setState(() {
      _selectedLocation = widget.selectedlocation;
    });
    try {
      initfunction();
      initfunction2();
      getTruckHistory();
      //   iconthenmarker();

      logger.i("in init state function");
      lastlatLngMarker = LatLng(
          gpsStoppageHistory[0].latitude, gpsStoppageHistory[0].longitude);
      camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);

      //   timer = Timer.periodic(Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }
  }

//for getting truck history
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
  }

  getTruckHistory() {
    setState(() {
      gpsDataHistory = widget.gpsDataHistory;
    });

    polylineCoordinates1 =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates1);
    _getPolyline(polylineCoordinates1);
  }

  getTruckHistoryAfter() {
    var logger = Logger();
    logger.i("in truck history after function");

    polylineCoordinates1 =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates1);
    _getPolyline(polylineCoordinates1);
  }

  addstops(var gpsStoppagehistory) async {
    var logger = Logger();
    logger.i("in addstops function");
    FutureGroup futureGroup = FutureGroup();
    averagelat = 0;
    averagelon = 0;
    for (int i = 0; i < gpsStoppagehistory.length; i++) {
      var future = getStoppage(gpsStoppagehistory[i], i);
      averagelat += gpsStoppagehistory[i].latitude as double;
      averagelon += gpsStoppagehistory[i].longitude as double;
      futureGroup.add(future);
    }
    averagelat = averagelat / gpsStoppagehistory.length;
    averagelon = averagelon / gpsStoppagehistory.length;

    futureGroup.close();
    await futureGroup.future;
  }

//for getting address and time-duration from the gpsStoppage list
  getStoppage(var gpsStoppage, int i) async {
    var stopAddress;
    var stoppageTime;
    var stoplatlong;
    var duration;
    LatLng? latlong;
    latlong = LatLng(gpsStoppage.latitude, gpsStoppage.longitude);
    stoplatlong = latlong;
    markerIcon = await getBytesFromCanvas(i + 1, 100, 100);
    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId("Stop Mark $i"),
        position: stoplatlong,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        //info window
        onTap: () async {
          stopAddress = await getStoppageAddress(gpsStoppage);
          stoppageTime = getStoppageTime(gpsStoppage);
          duration = getStoppageDuration(gpsStoppage);
          _customInfoWindowController.addInfoWindow!(
            getInfoWindow(duration, stoppageTime, stopAddress),
            stoplatlong,
          );
        },
      ));
    });
    // }
  }

  _addPolyLine() {
    PolylineId id1 = PolylineId("poly1");
    Polyline polyline1 = Polyline(
      polylineId: id1,
      color: Colors.blue,
      width: 4,
      points: polylineCoordinates1,
      visible: true,
    );
    setState(() {
      polylines1[id1] = polyline1;
      _polyline1.add(polyline1);
    });
  }

//for creating polylines
  _getPolyline(List<LatLng> polylineCoordinates1) async {
    var logger = Logger();
    logger.i("in polyline function in history screen");
    PolylineId id1 = PolylineId('poly1');
    Polyline polyline1 = Polyline(
      polylineId: id1,
      color: loadingWidgetColor,
      points: polylineCoordinates1,
      width: 2,
    );
    setState(() {
      polylines1[id1] = polyline1;
    });
    _addPolyLine();
  }

  initfunction() {
    setState(() {
      //  newGPSData = widget.gpsData;
      newGPSRoute = widget.routeHistory;
      gpsDataHistory = widget.gpsDataHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
    });
    addstops(gpsStoppageHistory);
  }

  Future<void> initfunction2() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _googleMapController = controller;
    });
  }

  //function called every one minute
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    // initfunctionAfter();
    getTruckHistoryAfter();
    //  iconthenmarker();
  }

//dropdown for choosing the duration for viewing history
  customSelection(String? choice) async {
    String startTime = DateTime.now().subtract(Duration(days: 1)).toString();
    String endTime = DateTime.now().toString();
    switch (choice) {
      case '48 hours':
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 2)).toString();
        });
        break;
      case '7 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 7)).toString();
        });
        break;
      case '14 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 14)).toString();
        });
        break;
      case '30 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 30)).toString();
        });
        break;
    }
    var istDate1;
    var istDate2;

    setState(() {
      // bookingDateList[3] = (nextDay.MMMEd);
      istDate1 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(startTime)
          .subtract(Duration(hours: 5, minutes: 30));
      istDate2 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(endTime)
          .subtract(Duration(hours: 5, minutes: 30));
    });
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
    var a = getStoppageHistory(widget.deviceId, istDate1.toIso8601String(),
        istDate2.toIso8601String());
    var b = getDataHistory(widget.deviceId, istDate1.toIso8601String(),
        istDate2.toIso8601String());

    gpsDataHistory = await b;
    gpsStoppageHistory = await a;
    //Run all APIs using new Date Range
    customMarkers = [];
    from = istDate1.toIso8601String();
    to = istDate2.toIso8601String();
    distancecalculation(from, to);
    Get.back();
    EasyLoading.dismiss();
    Get.to(() => TruckHistoryScreen(
          truckNo: widget.truckNo,
          dateRange: selectedDate.toString(),
          deviceId: widget.deviceId,
          istDate1: istDate1,
          istDate2: istDate2,
          selectedLocation: _selectedLocation,
          totalDistance: totalDistance,
          gpsDataHistory: gpsDataHistory,
          gpsStoppageHistory: gpsStoppageHistory,
        ));
  }

//for calculating the distance from loadingpoint to unloadingpoint
  distancecalculation(String from, String to) async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    logger.i("Activity is disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double threshold = 100;
    return Container(
      height: screenHeight - space_13,
      width: Responsive.isMobile(context) ? screenWidth : screenWidth / 1.5,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            child: Container(
                width: Responsive.isMobile(context)
                    ? screenWidth
                    : screenWidth / 1.5,
                height: screenHeight - space_13,
                child: Stack(children: <Widget>[
                  GoogleMap(
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    markers: customMarkers.toSet(),
                    polylines: Set.from(polylines1.values),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: camPosition,
                    compassEnabled: true,
                    mapType: maptype,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 110,
                    width: 275,
                    offset: 30,
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.25,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: col2,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(5)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(
                                        0,
                                        4,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 0.0,
                                    ),
                                  ]),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      this.maptype = MapType.normal;
                                      col1 = darkGreyColor;
                                      col2 = Color(0xffFF5C00);
                                    });
                                  },
                                  child: const Text(
                                    'Map',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: col1,
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(5)),
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      this.maptype = MapType.satellite;
                                      col2 = darkGreyColor;
                                      col1 = Color(0xffFF5C00);
                                    });
                                  },
                                  child: const Text('Satellite',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))),
                            )
                          ],
                        )),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 100,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.zoom_in,
                            size: 22, color: darkBlueColor),
                        onPressed: () {
                          setState(() {
                            this.zoom = this.zoom + 0.5;
                          });
                          this
                              ._googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  bearing: 0,
                                  target: lastlatLngMarker,
                                  zoom: this.zoom,
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 50,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: "btn3",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.zoom_out,
                            size: 22, color: Color(0xFF152968)),
                        onPressed: () {
                          setState(() {
                            this.zoom = this.zoom - 0.5;
                          });
                          this
                              ._googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  bearing: 0,
                                  target: lastlatLngMarker,
                                  zoom: this.zoom,
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 150,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: "btn4",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icons/layers.png',
                            width: 20,
                            height: 20,
                          ),
                        )),
                        onPressed: () {
                          if (zoombutton) {
                            setState(() {
                              this.zoom = 15;
                              zoombutton = false;
                            });
                            this
                                ._googleMapController
                                .animateCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    bearing: 0,
                                    target: lastlatLngMarker,
                                    zoom: this.zoom,
                                  ),
                                ));
                          } else {
                            setState(() {
                              this.zoom = 12;
                              zoombutton = true;
                            });
                            this
                                ._googleMapController
                                .animateCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    bearing: 0,
                                    target: LatLng(averagelat, averagelon),
                                    zoom: this.zoom,
                                  ),
                                ));
                          }
                        },
                      ),
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
