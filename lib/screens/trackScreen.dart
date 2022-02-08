import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/invalidDateConditionDialog.dart';
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:liveasy/widgets/truckInfoWindow.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

class TrackScreen extends StatefulWidget {
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var routeHistory;
  final String? TruckNo;
  final int? deviceId;
  final String? driverNum;
  final String? driverName;
  var truckId;

  TrackScreen(
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
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with WidgetsBindingObserver {
  final Set<Polyline> _polyline = {};
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker =
      LatLng(widget.gpsData.last.latitude, widget.gpsData.last.longitude);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  CustomInfoWindowController _customDetailsInfoWindowController =
      CustomInfoWindowController();
  late CameraPosition camPosition =
      CameraPosition(target: lastlatLngMarker, zoom: 8);
  var logger = Logger();
  late Marker markernew;
  List<String> _locations = [
    '24 hours',
    '48 hours',
    '7 days',
    '14 days',
    '30 days'
  ];
  String _selectedLocation = '24 hours';
  List<Marker> customMarkers = [];
  late Timer timer;
  late Timer timer2;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData = widget.gpsData;
  late List reversedList;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];

  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late PointLatLng start;
  late PointLatLng end;
  String? truckAddress;
  String? truckDate;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var newGPSRoute;
  var totalDistance;
  var stoppageTime = [];
  List<LatLng> stoplatlong = [];
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

  var Get;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    from = yesterday.toIso8601String();
    to = now.toIso8601String();

    try {
      initfunction();
      initfunction2();
      getTruckHistory();
      iconthenmarker();

      logger.i("in init state function");
      lastlatLngMarker =
          LatLng(widget.gpsData.last.latitude, widget.gpsData.last.longitude);
      camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);
      //To make the truck look running and for the speed to change in every 10 seconds
      timer = Timer.periodic(Duration(minutes: 0, seconds: 10),
          (Timer t) => onActivityExecuted2());
      //To update the trackscreen fully
      timer2 = Timer.periodic(
          Duration(minutes: 5, seconds: 0), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
    _customDetailsInfoWindowController.googleMapController = controller;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await _controller.future;
        onMapCreated(controller);
        print('appLifeCycleState resumed');
        break;
    }
  }

  //function is called at the starting
  getTruckHistory() {
    gpsDataHistory = widget.gpsDataHistory;
    print("Gps data history length ${gpsDataHistory.length}");
    gpsStoppageHistory = widget.gpsStoppageHistory;
    // getStoppage(widget.gpsStoppageHistory);
    polylineCoordinates =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates);
    _getPolyline(polylineCoordinates);
  }

  getAddress(var gpsData) async {
    var address = await getStoppageAddressLatLong(
        gpsData.last.latitude, gpsData.last.longitude);

    return address;
  }
  //function is called every five minute to get updated history

  getTruckHistoryAfter() {
    var logger = Logger();
    logger.i("in truck history after function");
    // getStoppage(gpsStoppageHistory);

    polylineCoordinates =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates);

    _getPolyline(polylineCoordinates);
  }

  // function is called to make the truck look running
  getTruckHistoryForSpeed() {
    var logger = Logger();
    logger.i("in truck history after function");
    // getStoppage(gpsStoppageHistory);
    polylineCoordinates =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates);
    polylineCoordinates
        .add(LatLng(newGPSData.last.latitude, newGPSData.last.longitude));
    _getPolyline(polylineCoordinates);
  }

  addstops(var gpsStoppage) async {
    var logger = Logger();
    logger.i("in addstops function");
    FutureGroup futureGroup = FutureGroup();
    for (int i = 0; i < gpsStoppage.length; i++) {
      var future = getStoppage(gpsStoppage[i], i);
      futureGroup.add(future);
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
    latlong = LatLng(gpsStoppage.latitude, gpsStoppage.longitude);
    stoplatlong = latlong;
    // }
    stoppageTime = getStoppageTime(gpsStoppage);
    // stopAddress = await getStoppageAddress(gpsStoppage);
    duration = getStoppageDuration(gpsStoppage);

    // for(int i=0; i<stoplatlong.length; i++){
    markerIcon = await getBytesFromCanvas(i + 1, 100, 100);
    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId("Stop Mark $i"),
        position: stoplatlong,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        //info window
        onTap: () async {
          stopAddress = await getStoppageAddress(gpsStoppage);

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
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      width: 4,
      points: polylineCoordinates,
      visible: true,
    );
    setState(() {
      polylines[id] = polyline;
      _polyline.add(polyline);
    });
  }

  _getPolyline(List<LatLng> polylineCoordinates) async {
    var logger = Logger();
    logger.i("in polyline function");
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: loadingWidgetColor,
      points: polylineCoordinates,
      width: 2,
    );
    setState(() {
      polylines[id] = polyline;
    });
    _addPolyLine();
  }

  initfunction() {
    setState(() {
      newGPSData = widget.gpsData;
      newGPSRoute = widget.routeHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;

      totalRunningTime = getTotalRunningTime(newGPSRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(newGPSRoute);
      status = getStatus(newGPSData, gpsStoppageHistory);
      newGPSRoute = getStopList(newGPSRoute, yesterday, now);
    });
    addstops(gpsStoppageHistory);
  }

  Future<void> initfunction2() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _googleMapController = controller;
    });
  }

  //called when clicked on custom button
  void initfunctionAfterChange() async {
    logger.i("It is in init function after change function");
    var f1 = mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    var f = getDataHistory(newGPSData.last.deviceId, from, to);
    var s = getStoppageHistory(newGPSData.last.deviceId, from, to);
    var t = getRouteStatusList(newGPSData.last.deviceId, from, to);

    var gpsData = await f1;
    var gpsRoute = await t;
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    setState(() {
      newGPSData = gpsData;
      // newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 1)),
          end: DateTime.now());
      print("NEW ROute $newGPSRoute");

      totalRunningTime = getTotalRunningTime(gpsRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(gpsRoute);
      //  newGPSRoute = getStopList(newGPSRoute);
      status = getStatus(newGPSData, gpsStoppageHistory);
    });
    addstops(gpsStoppageHistory);
    getTruckHistoryAfter();
    EasyLoading.dismiss();
  }

  // function called every 5 minuts to get updated
  void initfunctionAfter() async {
    logger.i("It is in init function after function");
    var f1 = mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    var f = getDataHistory(newGPSData.last.deviceId, from, to);
    var s = getStoppageHistory(newGPSData.last.deviceId, from, to);
    var t = getRouteStatusList(newGPSData.last.deviceId, from, to);

    var gpsData = await f1;
    var gpsRoute = await t;
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    _selectedLocation = '24 hours';
    setState(() {
      newGPSData = gpsData;
      newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 1)),
          end: DateTime.now());
      print("NEW ROute $newGPSRoute");

      totalRunningTime = getTotalRunningTime(newGPSRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(newGPSRoute);
      newGPSRoute = getStopList(newGPSRoute, yesterday, now);
      status = getStatus(newGPSData, gpsStoppageHistory);
    });
    addstops(gpsStoppageHistory);
  }

  void iconthenmarker() {
    logger.i("in Icon maker function");
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/truckPin.png')
        .then((value) => {
              setState(() {
                pinLocationIconTruck = value;
              }),
              createmarker()
            });
  }

  //function called every five minute
  void onActivityExecuted() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    customMarkers = [];
    polylines = {};
    logger.i("It is in Activity Executed function");
    initfunctionAfter();
    getTruckHistoryAfter();
    iconthenmarker();
  }

  //function used to change the speed of truck after 10 seconds and to make the truck look running
  void onActivityExecuted2() async {
    logger.i("It is in Activity2 Executed function");
    var gpsData = await mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    setState(() {
      newGPSData = gpsData;
    });
    getTruckHistoryForSpeed();
    iconthenmarker();
  }

  void createmarker() async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
          LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
      print("Live location is ${newGPSData.last.latitude}");
      print("hh");
      print("id ${newGPSData.last.deviceId.toString()}");
      String? title = widget.TruckNo;
      truckAddress = await getAddress(newGPSData);
      setState(() {
        direction = 180 + newGPSData.last.course;
        lastlatLngMarker =
            LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(newGPSData.last.deviceId.toString()),
            position: latLngMarker,
         //   infoWindow: InfoWindow(title: title),
            icon: pinLocationIconTruck,
            onTap: () {
              _customDetailsInfoWindowController.addInfoWindow!(
                truckInfoWindow(widget.TruckNo, truckAddress),
                lastlatLngMarker,
              );
            },
            rotation: direction));
        _polyline.add(Polyline(
            polylineId: PolylineId(newGPSData.last.id.toString()),
            visible: true,
            points: polylineCoordinates,
            color: Colors.blue,
            width: 2));
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

    //Run all APIs using new Date Range
    customMarkers = [];
    from = istDate1.toIso8601String();
    to = istDate2.toIso8601String();
    initfunctionAfterChange();
  }

  @override
  void dispose() {
    logger.i("Activity in trackscreen is disposed");
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double threshold = 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: statusBarColor,
        body: GestureDetector(
          onTap: () {
            setState(() {
              showBottomMenu = !showBottomMenu;
            });
          },
          onPanEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > threshold) {
              this.setState(() {
                showBottomMenu = false;
              });
            } else if (details.velocity.pixelsPerSecond.dy < -threshold) {
              this.setState(() {
                showBottomMenu = true;
              });
            }
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: -250,
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: height,
                    child: Stack(children: <Widget>[
                      GoogleMap(
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow!();
                          _customDetailsInfoWindowController.hideInfoWindow!();
                        },
                        onCameraMove: (position) {
                          _customInfoWindowController.onCameraMove!();
                          _customDetailsInfoWindowController.onCameraMove!();
                        },
                        markers: customMarkers.toSet(),
                        polylines: Set.from(polylines.values),
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        initialCameraPosition: camPosition,
                        compassEnabled: true,
                        mapType: maptype,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          _customInfoWindowController.googleMapController =
                              controller;
                          _customDetailsInfoWindowController
                              .googleMapController = controller;
                        },
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
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
                      CustomInfoWindow(
                        controller: _customDetailsInfoWindowController,
                        height: 140,
                        width: 300,
                        offset: 0,
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
                        bottom: height / 2 + 90,
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
                        bottom: height / 2 + 40,
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
                        top: 325,
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
                                        size: 15, color: white),
                                  ),
                                ),
                              ]),
                            ),
                            style: TextStyle(
                                color: const Color(0xff3A3A3A),
                                fontSize: size_6,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight
                                    .w400), // Not necessary for Option 1
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
              Positioned(
                  top: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: white,
                      child: Column(children: [
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
                                margin:
                                    EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                                child: Header(
                                    reset: false,
                                    text: "${widget.TruckNo}",
                                    backButton: true),
                              ),
                              HelpButtonWidget()
                            ],
                          ),
                        ),
                      ]))),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
                left: 0,
                bottom: (showBottomMenu) ? 0 : -(height / 3) + 24,
                child: TrackScreenDetails(
                  driverName: widget.driverName,
                  // truckDate: truckDate,
                  driverNum: widget.driverNum,
                  gpsData: newGPSData,
                  dateRange: selectedDate.toString(),
                  TruckNo: widget.TruckNo,
                  gpsTruckRoute: newGPSRoute,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
                  stops: stoplatlong,
                  totalRunningTime: totalRunningTime,
                  totalStoppedTime: totalStoppedTime,
                  truckId: widget.truckId,
                  deviceId: widget.deviceId,
                  totalDistance: totalDistance,
                  //    timer2: timer2,
                  //  timer3: timer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
