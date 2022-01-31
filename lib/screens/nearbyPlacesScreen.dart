import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/placesNearbyDataModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/buttons/okButton.dart';
import 'package:liveasy/widgets/nearbyPlacesDetailsWidget.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../widgets/stoppageInfoWindow.dart';

class NearbyPlacesScreen extends StatefulWidget {
  final List gpsData;
  final String? TruckNo;
  final int? deviceId;
  final String? driverNum;
  final String? driverName;
  var gpsDataHistory;
  var truckId;

  NearbyPlacesScreen(
      {required this.gpsData,
      // required this.position,
      required this.gpsDataHistory,
      this.TruckNo,
      this.driverName,
      this.driverNum,
      this.deviceId,
      this.truckId});

  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen>
    with WidgetsBindingObserver {
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
  late BitmapDescriptor pinLocationIconPumps;
  late CameraPosition camPosition =
      CameraPosition(target: lastlatLngMarker, zoom: 8);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData = widget.gpsData;
  late List reversedList;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  late Set<Circle> circles;
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
  double zoom = 10;
  bool showBottomMenu = false;
  var totalRunningTime;
  var totalStoppedTime;
  var status;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  late PlacesNearbyData _placesNearbyData;
  late Timer timer;
  var iconOnTheMap = 'assets/icons/gasstation';
  var placeOnTheMap = "gas_station";
  List<Marker> customMarkersGasStation = [];
  List<Marker> customMarkersPolice = [];

  Future<void> callApi(String lat, String lon) async {
    if (placeOnTheMap == "gas_station" && customMarkersGasStation.length != 0) {
      print("RETRIEVED OLD DATA");
      customMarkers = customMarkersGasStation;
    } else if (placeOnTheMap == "police" && customMarkersPolice.length != 0) {
      print("RETRIEVED OLD DATA");
      customMarkers = customMarkersPolice;
    } else {
      var url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" +
              lat +
              "," +
              lon +
              "&radius=15000&types=" +
              placeOnTheMap +
              "&key=" +
              googleAPiKey);
      var response = await http.get(url);
      print("LOCATION API RESPONSE");

      var body = response.body;
      _placesNearbyData = PlacesNearbyData.fromJson(jsonDecode(body));
      print("FIRST LOCATOIN IDENTIFIED");

      print(_placesNearbyData.results![1].name);

      var logger = Logger();
      logger.i("in addstops function");
      FutureGroup futureGroup = FutureGroup();
      for (int i = 0; i < _placesNearbyData.results!.length; i++) {
        var future = markNearbyPlaces(_placesNearbyData.results![i], i);
        futureGroup.add(future);
      }
      futureGroup.close();
      await futureGroup.future;
      print("STOPS DONE __");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    from = yesterday.toIso8601String();
    to = now.toIso8601String();

    try {
      //initfunction();
      initfunction2();
      iconthenmarker();
      getTruckHistory();

      callApi(widget.gpsData.last.latitude.toString(),
          widget.gpsData.last.longitude.toString());
      logger.i("in init state function");
      lastlatLngMarker =
          LatLng(widget.gpsData.last.latitude, widget.gpsData.last.longitude);
      camPosition = CameraPosition(target: lastlatLngMarker, zoom: zoom);
      print("PRINTING STOP LATLONG");
      print(widget.gpsData.last.latitude);
      print(widget.gpsData.last.longitude);
      final circleId =
          CircleId('circle_id_${DateTime.now().millisecondsSinceEpoch}');
      circles = Set.from([
        Circle(
          circleId: circleId,
          center: LatLng(
              widget.gpsData.last.latitude, widget.gpsData.last.longitude),
          radius: 1000,
          fillColor: Color.fromRGBO(17, 255, 169, 0.28),
          strokeColor: Color.fromRGBO(17, 255, 169, 0.28),
          strokeWidth: 2,
        )
      ]);
      timer = Timer.periodic(
          Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
      print("FSFSDFSDF SDFSDF");
    }
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
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await _controller.future;
        onMapCreated(controller);
        print('appLifeCycleState resumed');
        break;
    }
  }
  //function is called every one minute to get updated history

  getTruckHistory() {
    gpsDataHistory = widget.gpsDataHistory;
    print("Gps data history length ${gpsDataHistory.length}");
    // getStoppage(widget.gpsStoppageHistory);
    polylineCoordinates = getPoylineCoordinates(gpsDataHistory);
    _getPolyline(polylineCoordinates);
  }

  getTruckHistoryAfter() {
    var logger = Logger();
    logger.i("in truck history after function");
    // getStoppage(gpsStoppageHistory);
    polylineCoordinates = getPoylineCoordinates(gpsDataHistory);
    _getPolyline(polylineCoordinates);
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

  initfunction() {
    setState(() {
      newGPSData = widget.gpsData;
      totalRunningTime = getTotalRunningTime(newGPSRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(newGPSRoute);
      print("kya $to");
      status = getStatus(newGPSData, gpsStoppageHistory);
      newGPSRoute = getStopList(newGPSRoute);
    });
  }

  Future<void> initfunction2() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _googleMapController = controller;
    });
  }

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
      status = getStatus(newGPSData, gpsStoppageHistory);
      newGPSRoute = getStopList(newGPSRoute);
    });
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
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(16, 16)),
            iconOnTheMap + "_rounded.png")
        .then((value) => {
              setState(() {
                pinLocationIconPumps = value;
              }),
              createmarker()
            });
  }

  //function called every one minute
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    initfunctionAfter();
    iconthenmarker();
    customMarkers = [];
    callApi(widget.gpsData.last.latitude.toString(),
        widget.gpsData.last.longitude.toString());
  }

  void createmarker() async {
    try {
      print("rj");
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
          LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
      print("Live location is ${newGPSData.last.latitude}");
      print("hh");
      print("id ${newGPSData.last.deviceId.toString()}");
      String? title = widget.TruckNo;
      setState(() {
        direction = 180 + newGPSData.last.course;
        lastlatLngMarker =
            LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(newGPSData.last.deviceId.toString()),
            position: latLngMarker,
            infoWindow: InfoWindow(title: title),
            icon: pinLocationIconTruck,
            rotation: direction));
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(bearing: 0, target: lastlatLngMarker, zoom: 14.5),
      ));
      this.zoom = 14.5;
    } catch (e) {
      print("Exceptionis $e");
    }
  }

  markNearbyPlaces(Results nearbyPlaces, int i) async {
    LatLng latlong;

    // for(var stop in gpsStoppage) {
    latlong = LatLng(nearbyPlaces.geometry!.location!.lat ?? 0,
        nearbyPlaces.geometry!.location!.lng ?? 0);

    // for(int i=0; i<stoplatlong.length; i++){
    markerIcon = await getBytesFromCanvas(i + 1, 100, 100);
    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId("Stop Mark $i"),
        position: latlong,
        icon: pinLocationIconPumps,
        infoWindow: InfoWindow(title: nearbyPlaces.name),
        // onTap: () async {
        //   _customInfoWindowController.addInfoWindow!(
        //     getInfoWindow(duration, stoppageTime, stopAddress),
        //     latlong,
        //   );
        // },
      ));
    });
    // }
  }

  @override
  void dispose() {
    logger.i("Activity is disposed");
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                top: -100,
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: <Widget>[
                      GoogleMap(
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow!();
                        },
                        onCameraMove: (position) {
                          _customInfoWindowController.onCameraMove!();
                        },
                        circles: circles,
                        markers: customMarkers.toSet(),
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        initialCameraPosition: camPosition,
                        compassEnabled: true,
                        polylines: Set.from(polylines.values),
                        mapType: maptype,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          _customInfoWindowController.googleMapController =
                              controller;
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
                        bottom: height / 3 + 170,
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
                        bottom: height / 3 + 115,
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
                bottom: (showBottomMenu) ? 0 : -(height / 3) + 55,
                child: menuWidget(height, width),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container menuWidget(double height, double width) {
    return Container(
      height: height / 3 + 86,
      width: width,
      padding: EdgeInsets.fromLTRB(0, 0, 0, space_3),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: darkShadow,
              offset: const Offset(
                0,
                -5.0,
              ),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
            BoxShadow(
              color: white,
              offset: const Offset(0, 1.0),
              blurRadius: 0.0,
              spreadRadius: 2.0,
            ),
          ]),
      child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: const Color(0xFFCBCBCB),
              // height: size_3,
              thickness: 3,
              indent: 150,
              endIndent: 150,
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(space_5, space_4, space_8, space_1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      FloatingActionButton(
                        heroTag: "button5",
                        backgroundColor: bidBackground,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.local_gas_station, size: 30),
                        onPressed: () {
                          if (placeOnTheMap != "gas_station")
                            setState(() {
                              iconOnTheMap = 'assets/icons/gasstation';
                              placeOnTheMap = "gas_station";
                              customMarkersPolice = customMarkers;
                              onActivityExecuted();
                            });
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Petrol Pump",
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                    Column(children: [
                      FloatingActionButton(
                        heroTag: "button7",
                        backgroundColor: bidBackground,
                        foregroundColor: Colors.white,
                        child: Image.asset(
                          'assets/icons/policecap.png',
                          scale: 3.5,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (placeOnTheMap != "police")
                            setState(() {
                              iconOnTheMap = 'assets/icons/policecap';
                              placeOnTheMap = "police";
                              customMarkersGasStation = customMarkers;
                              onActivityExecuted();
                            });
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Police Station",
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                    Column(children: [
                      FloatingActionButton(
                        heroTag: "button7",
                        backgroundColor: bidBackground,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.settings, size: 30),
                        onPressed: () {
                          Get.defaultDialog(
                              content: Column(
                                children: [
                                  Text("Mechanic data coming soon\n"),
                                  OkButton()
                                ],
                              ),
                              title: "\nComing Soon",
                              titleStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ));
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Mechanic",
                        style: TextStyle(
                            color: black,
                            fontSize: size_6,
                            fontStyle: FontStyle.normal,
                            fontWeight: mediumBoldWeight),
                      ),
                    ]),
                  ],
                )),
          ]),
    );
  }
}
