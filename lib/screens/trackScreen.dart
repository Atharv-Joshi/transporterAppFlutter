import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/screens/truckLockUnlockScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:liveasy/widgets/truckInfoWindow.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';

class TrackScreen extends StatefulWidget {
  final GpsDataModel gpsData;
//  final List gpsDataHistory;
  // final List gpsStoppageHistory;
//  final List routeHistory;
  final String? TruckNo;
  final int? deviceId;
  // final String? driverNum;
  // final String? driverName;
  // final String? truckId;
  var totalDistance;
  var imei;
  TrackScreen(
      {required this.gpsData,
      //  required this.gpsDataHistory,
      //  required this.gpsStoppageHistory,
      //  required this.routeHistory,
      // required this.position,
      required this.TruckNo,
      //   this.driverName,
      //  this.driverNum,
      required this.deviceId,
      //  required this.truckId,
      required this.totalDistance,
      this.imei});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with WidgetsBindingObserver {
  final Set<Polyline> _polyline = {};
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker =
      LatLng(widget.gpsData.latitude!, widget.gpsData.longitude!);
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
  late List newGPSData = [];
  late List reversedList;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  var istDate1;
  var istDate2;
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
  bool zoombutton = false;
  bool showBottomMenu = true;
  var totalRunningTime = "";
  double averagelat = 0;
  double averagelon = 0;
  var totalStoppedTime = "";
  var status;
  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  final lockStorage = GetStorage();
  var lockState;
  var col1 = Color(0xff878787);
  var col2 = Color(0xffFF5C00);
  //var Get;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    from = yesterday.toIso8601String();
    istDate1 = yesterday;
    istDate2 = now;
    loading = false;
    to = now.toIso8601String();
    print("device ID ${widget.deviceId}");
    newGPSData.add(widget.gpsData);
    try {
      initfunction();

      initfunction2();
      EasyLoading.dismiss();
      logger.i("in init state function");
      lastlatLngMarker =
          LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
      camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);
      //To make the truck look running and for the speed to change in every 10 seconds
      timer = Timer.periodic(Duration(minutes: 0, seconds: 10),
          (Timer t) => onActivityExecuted2());
      //To update the trackscreen fully
      timer2 = Timer.periodic(
          Duration(minutes: 45, seconds: 0), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }

    lockState = lockStorage.read('lockState');
    if (lockState == null) {
      lockState = false;
      lockStorage.write('lockState', lockState);
    }
    print("lock STATE is $lockState");
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
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  //function is called at the starting
  getTruckHistory() {
    // gpsDataHistory = widget.gpsDataHistory;

    //  gpsStoppageHistory = widget.gpsStoppageHistory;
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
    averagelat = 0;
    averagelon = 0;
    FutureGroup futureGroup = FutureGroup();
    for (int i = 0; i < gpsStoppage.length; i++) {
      var future = getStoppage(gpsStoppage[i], i);
      averagelat += gpsStoppage[i].latitude as double;
      averagelon += gpsStoppage[i].longitude as double;
      futureGroup.add(future);
    }
    averagelat = averagelat / gpsStoppage.length;
    averagelon = averagelon / gpsStoppage.length;

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

  initfunction() async {
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
    logger.i("It is in init function");
    // var f1 = mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    var f = getDataHistory(widget.deviceId, from, to);
    var s = getStoppageHistory(widget.deviceId, from, to);
    //  var t = getRouteStatusList(widget.deviceId, from, to);
    //   var gpsRoute = await t;
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    print("newGpsDataHistory $newGpsDataHistory");
    print("newGpsStoppageHistory $newGpsStoppageHistory");
    setState(() {
      newGPSData.add(widget.gpsData);
      // newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(start: istDate1, end: istDate2);
      //  print("NEW ROute $newGPSRoute");
      totalDistance = widget.totalDistance;
      //totalDistance = getTotalDistance(gpsRoute);
      //  newGPSRoute = getStopList(newGPSRoute);
      totalRunningTime =
          getTotalRunningTime(gpsStoppageHistory, istDate1, istDate2);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
    });

    addstops(gpsStoppageHistory);

    getTruckHistory();
    iconthenmarker();
    zoomin();
    setState(() {
      loading = true;
    });

    EasyLoading.dismiss();
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
    // var f1 = mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    var f = getDataHistory(newGPSData.last.deviceId, from, to);
    var s = getStoppageHistory(newGPSData.last.deviceId, from, to);
    // var t = getRouteStatusList(newGPSData.last.deviceId, from, to);
    //  distancecalculation(from,to);
    // var gpsData = await f1;
    // var gpsRoute = await t;
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    setState(() {
      //  newGPSData = gpsData;
      // newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(start: istDate1, end: istDate2);
      //   print("NEW ROute $newGPSRoute");

      //  totalRunningTime = getTotalRunningTime(gpsRoute);
      // totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      //totalDistance = getTotalDistance(gpsRoute);
      //  newGPSRoute = getStopList(newGPSRoute);
      // status = getStatus(newGPSData, gpsStoppageHistory);
    });
    addstops(gpsStoppageHistory);
    getTruckHistoryAfter();
    iconthenmarker();
    zoomin();
    setState(() {
      loading = true;
    });
    EasyLoading.dismiss();
  }

  // function called every 45 minuts to get updated

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

  //function called every forty five minute
  void onActivityExecuted() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    customMarkers = [];
    polylines = {};
    logger.i("It is in Activity Executed function");
    initfunctionAfterChange();
    getTruckHistoryAfter();
    iconthenmarker();
    zoomin();
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

  void zoomin() async {
    final GoogleMapController controller = await _controller.future;
    LatLng lastlatLngMarker =
        LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: lastlatLngMarker,
        zoom: zoom,
      ),
    ));
  }

  void createmarker() async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
          LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
      print("Live location is ${newGPSData.last.latitude}");

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
      /*   controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: lastlatLngMarker,
          zoom: zoom,
        ),
      ));*/
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

    setState(() {
      // bookingDateList[3] = (nextDay.MMMEd);
      loading = false;
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
                      // loading?
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
                      //   :Container(),
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
                        top: MediaQuery.of(context).size.height / 2,
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.25,
                              ),
                            ),
                            //  height: 40,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: col2,
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.25),
                                          offset: const Offset(
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
                                          col1 = Color(0xff878787);
                                          col2 = Color(0xffFF5C00);
                                        });
                                      },
                                      child: Text(
                                        'Map',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: col1,
                                    borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(5)),
                                    //  border: Border.all(color: Colors.black),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          this.maptype = MapType.satellite;
                                          col2 = Color(0xff878787);
                                          col1 = Color(0xffFF5C00);
                                        });
                                      },
                                      child: Text('Satellite',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ))),
                                )
                              ],
                            )
                            /*        FloatingActionButton(
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
                   */
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
                        bottom: height / 2 + 150,
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
                                this._googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
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
                                this._googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
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
                                    child: new Text(location.tr)),
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
                              //HelpButtonWidget(),
                              PopupMenuButton(
                                  onSelected: (value) => {
                                        if (value == 1)
                                          {
                                            //   print("THE DATA ${widget.truckId}"),
                                            Get.to(TruckLockUnlock(
                                                deviceId: widget.deviceId,
                                                gpsData: newGPSData,
                                                // position: position,
                                                TruckNo: widget.TruckNo,
                                                //   driverName: widget.driverName,
                                                //   driverNum: widget.driverNum,
                                                gpsDataHistory: gpsDataHistory,
                                                gpsStoppageHistory:
                                                    gpsStoppageHistory))
                                            //    routeHistory:
                                            //       widget.routeHistory))
                                            // truckId: widget.truckId))
                                            //   if (lockState == false)
                                            //     {
                                            //       Get.to(() => TruckLockScreen(
                                            //           deviceId: widget.deviceId,
                                            //           gpsData: widget.gpsData,
                                            //           // position: position,
                                            //           TruckNo: widget.TruckNo,
                                            //           driverName:
                                            //               widget.driverName,
                                            //           driverNum: widget.driverNum,
                                            //           gpsDataHistory:
                                            //               widget.gpsDataHistory,
                                            //           gpsStoppageHistory: widget
                                            //               .gpsStoppageHistory,
                                            //           routeHistory:
                                            //               widget.routeHistory,
                                            //           truckId: widget.truckId))
                                            //     }
                                            //   else
                                            //     {
                                            //       Get.to(() => TruckUnlockScreen(
                                            //           deviceId: widget.deviceId,
                                            //           gpsData: widget.gpsData,
                                            //           // position: position,
                                            //           TruckNo: widget.TruckNo,
                                            //           driverName:
                                            //               widget.driverName,
                                            //           driverNum: widget.driverNum,
                                            //           gpsDataHistory:
                                            //               widget.gpsDataHistory,
                                            //           gpsStoppageHistory: widget
                                            //               .gpsStoppageHistory,
                                            //           routeHistory:
                                            //               widget.routeHistory,
                                            //           truckId: widget.truckId))
                                            //     }
                                          }
                                      },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(radius_1 + 1))),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                "assets/icons/truckLockIcon.png",
                                                height: space_2 + 3,
                                                width: space_2 + 3,
                                              ),
                                              SizedBox(
                                                width: space_1 + 1,
                                              ),
                                              Container(
                                                  //width: 100,
                                                  child: Text(
                                                "Truck Lock".tr,
                                                style: TextStyle(
                                                    color: liveasyBlackColor),
                                              )),
                                            ],
                                          ),
                                        ),
                                        // PopupMenuItem(
                                        //   child: Text("Second"),
                                        //   value: 2,
                                        // )
                                      ])
                            ],
                          ),
                        ),
                      ]))),
              //   loading?
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
                left: 0,
                bottom: (showBottomMenu) ? 0 : -(height / 3) + 44,
                child: TrackScreenDetails(
                  //   driverName: widget.driverName,
                  // truckDate: truckDate,
                  //  driverNum: widget.driverNum,
                  gpsData: newGPSData,
                  dateRange: selectedDate,
                  TruckNo: widget.TruckNo,
                  //  gpsTruckRoute: newGPSRoute,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
                  stops: stoplatlong,
                  totalRunningTime: totalRunningTime,
                  totalStoppedTime: totalStoppedTime,
                  //  truckId: widget.truckId,
                  deviceId: widget.deviceId,
                  // totalDistance: totalDistance,
                  recentStops: gpsStoppageHistory,
                  imei: widget.imei,
                  //    timer2: timer2,
                  //  timer3: timer,
                ),
              )
              //   :Container(),
            ],
          ),
        ),
      ),
    );
  }
}
