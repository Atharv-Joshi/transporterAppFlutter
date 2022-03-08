import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

class HistoryScreenMapWidget extends StatefulWidget {
  // final List gpsData;
  final routeHistory;
  final gpsHistory;
  var truckNo;
  var deviceId;
  var selectedlocation;

  HistoryScreenMapWidget({
    //  required this.gpsData,
    required this.routeHistory,
    required this.gpsHistory,
    required this.deviceId,
    required this.truckNo,
    required this.selectedlocation,
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
  PolylinePoints polylinePoints1 = PolylinePoints();
  late PointLatLng start;
  late PointLatLng end;
  String? truckAddress;
  String? truckDate;
  var gpsHistory;
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
  String googleAPiKey = FlutterConfig.get("mapKey");
  bool popUp = false;
  List<PolylineWayPoint> waypoints = [];
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
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
      if (widget.routeHistory[widget.routeHistory.length - 1].runtimeType !=
          GpsDataModel) {
        lastlatLngMarker = LatLng(
            widget.routeHistory[widget.routeHistory.length - 1][4],
            widget.routeHistory[widget.routeHistory.length - 1][5]);
        camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);
      } else {
        lastlatLngMarker = LatLng(
            widget.routeHistory[widget.routeHistory.length - 1].latitude,
            widget.routeHistory[widget.routeHistory.length - 1].longitude);
        camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);
      }

      //   timer = Timer.periodic(Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
  }

  /*@override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await _controller.future;
        onMapCreated(controller);
        print('appLifeCycleState resumed');
         break;
  }
  }*/

  getTruckHistory() {
    setState(() {
      gpsHistory = widget.gpsHistory;
    });

    print("Gps data history length ${gpsHistory.length}");
    // gpsStoppageHistory=widget.gpsStoppageHistory;
    // getStoppage(widget.gpsStoppageHistory);
    polylineCoordinates1 =
        getPoylineCoordinates(gpsHistory, polylineCoordinates1);
    _getPolyline(polylineCoordinates1);
  }

  //function is called every one minute to get updated history

  getTruckHistoryAfter() {
    var logger = Logger();
    logger.i("in truck history after function");
    // getStoppage(gpsStoppageHistory);
    polylineCoordinates1 =
        getPoylineCoordinates(gpsHistory, polylineCoordinates1);
    _getPolyline(polylineCoordinates1);
  }

  addstops(var gpsStoppage) async {
    var logger = Logger();
    logger.i("in addstops function");
    FutureGroup futureGroup = FutureGroup();
    int j = 0;
    for (int i = 0; i < gpsStoppage.length; i++) {
      if (gpsStoppage[i].runtimeType != GpsDataModel) {
        var future = getStoppage(gpsStoppage[i], j);
        futureGroup.add(future);
        j++;
      }
    }
    futureGroup.close();
    await futureGroup.future;
    print("STOPS DONE __");

    //This is another way to fire placemark APIs in parallel ------

    // stopAddress =[];
    // var obj = [];
    // for(int i=0; i<gpsStoppage.length; i++) {
    //   obj.add(getStoppageAddress(gpsStoppage[i]));
    // }
    // print("Added all ");
    // for(int i=0; i<gpsStoppage.length; i++) {
    //
    //   var place = await obj[i];
    //   stopAddress.insert(i, place);
    // }
    // print("STOPSS $stopAddress");
  }

  getStoppage(var gpsStoppage, int i) async {
    var stopAddress;
    var stoppageTime;
    var stoplatlong;
    var duration;
    print("Stop length ${gpsStoppage}");
    LatLng? latlong;

    // for(var stop in gpsStoppage) {
    latlong = LatLng(gpsStoppage[4], gpsStoppage[5]);
    stoplatlong = latlong;
    // }
    stoppageTime = "${gpsStoppage[1]} - ${gpsStoppage[2]}";
    // stopAddress = await getStoppageAddress(gpsStoppage);
    duration = gpsStoppage[3];

    // for(int i=0; i<stoplatlong.length; i++){
    markerIcon = await getBytesFromCanvas(i + 1, 100, 100);
    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId("Stop Mark $i"),
        position: stoplatlong,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        //info window
        onTap: () async {
          stopAddress =
              await getStoppageAddressLatLong(gpsStoppage[4], gpsStoppage[5]);

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
      //   gpsStoppageHistory = widget.gpsStoppageHistory;

      //  totalRunningTime = getTotalRunningTime(newGPSRoute);
      //  totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      // totalDistance = getTotalDistance(newGPSRoute);
      print("kya $to");
      //  status = getStatus(newGPSData, gpsStoppageHistory);
      //  newGPSRoute = getStopList(newGPSRoute);
    });
    addstops(newGPSRoute);
  }

  Future<void> initfunction2() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _googleMapController = controller;
    });
  }

  /* void initfunctionAfter() async {
    logger.i("It is in init function after function");
    var f1 = mapUtil.getTraccarPosition(deviceId : widget.deviceId);
    var f =  getDataHistory(newGPSData.last.deviceId, from,  to);
    var s = getStoppageHistory(newGPSData.last.deviceId, from,  to);
    var t = getRouteStatusList(newGPSData.last.deviceId, from,  to);

    var gpsData = await f1;
    var gpsRoute = await t;
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    setState(() {
      newGPSData = gpsData;
      newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 1)),
          end: DateTime.now()
      );
      print("NEW ROute $newGPSRoute");
      totalRunningTime = getTotalRunningTime(newGPSRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(newGPSRoute);
      status = getStatus(newGPSData, gpsStoppageHistory);
      newGPSRoute = getStopList(newGPSRoute);
    });
    addstops(gpsStoppageHistory);
  }
*/
/*  void iconthenmarker() {
    logger.i("in Icon maker function");
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/truckPin.png')
        .then((value) => {
      setState(() {
        pinLocationIconTruck = value;
      }),
   //   createmarker()
    });
  }
*/
  //function called every one minute
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    // initfunctionAfter();
    getTruckHistoryAfter();
    //  iconthenmarker();
  }

  /* void createmarker() async {
    try {
      print("rj");
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
      LatLng(widget.routeHistory[0].latitude, widget.routeHistory[0].longitude);
      print("Live location is ${widget.routeHistory[0].latitude}");

    //  print("id ${newGPSData.last.deviceId.toString()}");
    //  String? title = widget.TruckNo;
      setState(() {
        direction = 180 + newGPSData.last.course;
        lastlatLngMarker = LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(newGPSData.last.deviceId.toString()),
            position: latLngMarker,
            infoWindow: InfoWindow(title: title),
            icon: pinLocationIconTruck,
        rotation: direction));
        _polyline.add(Polyline(
          polylineId: PolylineId(newGPSData.last.id.toString()),
          visible: true,
          points: polylineCoordinates,
          color: Colors.blue,
          width: 2
        ));
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
  */
  customSelection(String? choice) async {
    String startTime = DateTime.now().subtract(Duration(days: 1)).toString();
    String endTime = DateTime.now().toString();
    switch (choice) {
      case '48 hours':
        print("48");
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 2)).toString();
          print("NEW start $startTime and $endTime");
        });
        break;
      case '7 days':
        print("7");
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 7)).toString();
          print("NEW start $startTime and $endTime");
        });
        break;
      case '14 days':
        print("14");
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 14)).toString();
          print("NEW start $startTime and $endTime");
        });
        break;
      case '30 days':
        print("30");
        setState(() {
          endTime = DateTime.now().toString();
          startTime = DateTime.now().subtract(Duration(days: 30)).toString();
          print("NEW start $startTime and $endTime");
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
      print(
          "selected date 1 ${istDate1.toIso8601String()} and ${istDate2.toIso8601String()}");
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
    var newRouteHistory = await getRouteStatusList(widget.deviceId,
        istDate1.toIso8601String(), istDate2.toIso8601String());
    print("AFter ${newRouteHistory.length}");
    totalDistance = getTotalDistance(newRouteHistory);
    newRouteHistory = getStopList(newRouteHistory, istDate1, istDate2);
    //Run all APIs using new Date Range
    customMarkers = [];
    from = istDate1.toIso8601String();
    to = istDate2.toIso8601String();
    Get.back();
    EasyLoading.dismiss();
    Get.to(() => TruckHistoryScreen(
          truckNo: widget.truckNo,
          gpsTruckRoute: newRouteHistory,
          dateRange: selectedDate.toString(),
          deviceId: widget.deviceId,
          istDate1: istDate1,
          istDate2: istDate2,
          //   gpsDataHistory: gpsHistory,
          selectedLocation: _selectedLocation,
          totalDistance: totalDistance,
          //    latitude: widget.latitude,
          //    longitude: widget.longitude
        ));
  }

  @override
  void dispose() {
    logger.i("Activity is disposed");
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double threshold = 100;
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: -100,
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: height,
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
                    height: 120,
                    width: 275,
                    offset: 30,
                  ),
                  Positioned(
                    left: 10,
                    top: 175,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: "btn1",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.my_location,
                            size: 22, color: Color(0xFF152968)),
                        onPressed: () {
                          setState(() {
                            this.maptype = (this.maptype == MapType.normal)
                                ? MapType.satellite
                                : MapType.normal;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: height / 3 + 130,
                    child: SizedBox(
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.zoom_in,
                            size: 22, color: Color(0xFF152968)),
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
                    bottom: height / 3 + 80,
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
                    top: 175,
                    child: Container(
                      height: 40,
                      width: 110,
                      alignment: Alignment.centerRight,
                      //   padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      //   margin: EdgeInsets.fromLTRB(0, 14, 0, 10),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.19),
                              offset: const Offset(
                                0,
                                5.33,
                              ),
                              blurRadius: 9.33,
                              spreadRadius: 0.0,
                            ),
                          ]),

                      child: DropdownButton(
                        underline: Container(),
                        hint: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text('24 hours'),
                        ),
                        icon: Container(
                          width: 36,
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                width: 36,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff152968),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Icon(Icons.keyboard_arrow_down,
                                    size: 20, color: white),
                              ),
                            ),
                          ]),
                        ),
                        style: TextStyle(
                            color: const Color(0xff3A3A3A),
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400),
                        // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue.toString();
                          });
                          customSelection(_selectedLocation);
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: Container(
                                //  width: 74,
                                child: new Text(location)),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ])),
          ),

          /*      Container(
                      margin: EdgeInsets.fromLTRB(space_7, space_1, 0, space_2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Column(
                                  children: [
      
                                    Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/icons/distanceCovered.png'),
                                            height: 23,
                                          ),
                                          SizedBox(
                                            width: space_1,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 170,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Travelled ",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: liveasyGreen,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                    Text("${totalDistance} km",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("$totalRunningTime ",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: grey,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
      
                                        ]
                                    ),
                                    SizedBox(
                                      height: space_3,
                                    ),
                                    Row(
                                        children: [
                                          Icon(Icons.pause,
                                              size: size_11),
                                          SizedBox(
                                            width: space_1,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 170,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${gpsStoppageHistory.length } ",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                    Text("Stops",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: red,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("$totalStoppedTime ",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: grey,
                                                            fontSize: size_6,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: regularWeight)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
      
                                        ]
                                    ),
      
                                  ],
                                )
                            ),
      
                            Container(
                              child: Column(
                                children: [
                                  Text("${(newGPSData.last.speed).toStringAsFixed(2)} km/h",
                                      style: TextStyle(
                                          color: liveasyGreen,
                                          fontSize: size_10,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: regularWeight)
                                  ),
                                  Text("Status",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: size_6,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: regularWeight)
                                  ),
                                  Text("$status",
                                      style: TextStyle(
                                          color: grey,
                                          fontSize: size_6,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: regularWeight)
                                  )
                                ],
                              ),
                            )
      
                          ]
                      )
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
      */
        ],
      ),
    );
  }
}
