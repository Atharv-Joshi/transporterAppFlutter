import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/truckLockUnlockScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:liveasy/widgets/truckInfoWindow.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:get/get.dart';

class TrackScreen extends StatefulWidget {
  final GpsDataModel gpsData;
  final String? truckNo;
  final int? deviceId;
  var totalDistance;
  var imei;
  bool active;
  bool? online;

  TrackScreen(
      {required this.gpsData,
      required this.truckNo,
      required this.deviceId,
      required this.totalDistance,
      this.imei,
      this.online,
      required this.active});

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
  late LatLng start;
  late LatLng end;
  String? truckAddress;
  String? truckDate;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var newGPSRoute;
  var finalDistance;
  var stoppageTime = [];
  List<LatLng> stoplatlong = [];
  var duration = [];
  var stopAddress = [];
  String? Speed;
  String googleAPiKey = dotenv.get('mapKey');

  bool popUp = false;
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
  var deviceId;
  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));

  final lockStorage = GetStorage();
  var lockState;
  var col1 = const Color(0xff878787);
  var col2 = const Color(0xffFF5C00);

  //variable for show running / stop status
  var totalStatus = "";

  bool loading_map = false;
  bool loadmap2 = false;
  bool loadmap3 = false;
  bool loadmap4 = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    from = yesterday.toIso8601String();
    istDate1 = yesterday;
    istDate2 = now;
    loading = false;
    to = now.toIso8601String();
    newGPSData.add(widget.gpsData);

    logger.i("newGPSData");
    try {
      initfunction();

      initfunction2();
      EasyLoading.dismiss();
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
  }

//onMapCreated for initializing controller
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

    polylineCoordinates =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates);

    _getPolyline(polylineCoordinates);
  }

  // function is called to make the truck look running
  getTruckHistoryForSpeed() {
    var logger = Logger();
    polylineCoordinates =
        getPoylineCoordinates(gpsDataHistory, polylineCoordinates);
    polylineCoordinates
        .add(LatLng(newGPSData.last.latitude, newGPSData.last.longitude));
    _getPolyline(polylineCoordinates);
  }

  addstops(var gpsStoppage) async {
    var logger = Logger();
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
  }

  getStoppage(var gpsStoppage, int i) async {
    var stopAddress;
    var stoppageTime;
    var stoplatlong;
    var duration;

    LatLng? latlong;
    latlong = LatLng(gpsStoppage.latitude, gpsStoppage.longitude);
    stoplatlong = latlong;
    stopAddress = await getStoppageAddress(gpsStoppage);
    stoppageTime = getStoppageTime(gpsStoppage);
    duration = getStoppageDuration(gpsStoppage);
    markerIcon = await getBytesFromCanvas(i + 1, 100, 100);
    String snippet =
        "$duration  ------------  $stoppageTime  -----------  $stopAddress";
    logger.i(snippet);
    setState(() {
      customMarkers.add(Marker(
        markerId: MarkerId("Stop Mark $i"),
        position: stoplatlong,
        icon: kIsWeb
            ? BitmapDescriptor.fromBytes(markerIcon, size: const Size(40, 40))
            : BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: InfoWindow(
          snippet: snippet,
          anchor: Offset(50, 50),
        ),
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
    PolylineId id = const PolylineId("poly");
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
      loadmap2 = true;
    });
  }

  _getPolyline(List<LatLng> polylineCoordinates) async {
    var logger = Logger();
    logger.i("in polyline function");
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: loadingWidgetColor,
      points: polylineCoordinates,
      width: 2,
    );
    setState(() {
      polylines[id] = polyline;
      loadmap3 = true;
    });
    _addPolyLine();
  }

  // calling function for fetch total distance data
  getTotalDistance(var ab, var from, var to) async {
    var gpsRoute1 =
        await mapUtil.getTraccarSummary(deviceId: ab, from: from, to: to);
    setState(() {
      widget.totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
      finalDistance = widget.totalDistance;
    });
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
    var f = getDataHistory(widget.deviceId, from, to);
    var s = getStoppageHistory(widget.deviceId, from, to);
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;

    setState(() {
      newGPSData.add(widget.gpsData);
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(start: istDate1, end: istDate2);
      deviceId = widget.gpsData.deviceId!;
      finalDistance = getTotalDistance(deviceId, from, to);
      totalRunningTime =
          getTotalRunningTime(gpsStoppageHistory, istDate1, istDate2);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalStatus = getLastUpdate(
          gpsStoppageHistory, now.toIso8601String(), widget.active);
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

  void initfunctionAfterChange() async {
    logger.i("It is in init function after change function");
    var f = getDataHistory(newGPSData.last.deviceId, from, to);
    var s = getStoppageHistory(newGPSData.last.deviceId, from, to);
    var newGpsDataHistory = await f;
    var newGpsStoppageHistory = await s;
    setState(() {
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      selectedDate = DateTimeRange(start: istDate1, end: istDate2);
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
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
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
    initfunctionAfterChange();
    getTruckHistoryAfter();
    iconthenmarker();
    zoomin();
  }

  //function used to change the speed of truck after 10 seconds and to make the truck look running
  void onActivityExecuted2() async {
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
      String? title = widget.truckNo;
      truckAddress = await getAddress(newGPSData);
      setState(() {
        direction = 180 + newGPSData.last.course;
        lastlatLngMarker =
            LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(newGPSData.last.deviceId.toString()),
            position: latLngMarker,
            icon: pinLocationIconTruck,
            onTap: () {
              _customDetailsInfoWindowController.addInfoWindow!(
                truckInfoWindow(widget.truckNo, truckAddress),
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
    } catch (e) {
      print("Hello56");
    }
  }

  customSelection(String? choice) async {
    String startTime =
        DateTime.now().subtract(const Duration(days: 1)).toString();
    String endTime = DateTime.now().toString();
    switch (choice) {
      case '48 hours':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 2)).toString();
        });
        break;
      case '7 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 7)).toString();
        });
        break;
      case '14 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 14)).toString();
        });
        break;
      case '30 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 30)).toString();
        });
        break;
    }

    setState(() {
      loading = false;
      istDate1 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(startTime)
          .subtract(const Duration(hours: 5, minutes: 30));
      istDate2 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(endTime)
          .subtract(const Duration(hours: 5, minutes: 30));
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
    initfunction();
  }

  //function for show the how long device is active or not !
  getStatus() {
    print("-------------------- $s.length");
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
                left: Responsive.isMobile(context) ? 0 : null,
                right: Responsive.isMobile(context) ? null : 0,
                top: Responsive.isMobile(context) ? -250 : space_13,
                bottom: Responsive.isMobile(context) ? 0 : null,
                child: SizedBox(
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width / 1.5,
                    height: Responsive.isMobile(context)
                        ? height
                        : MediaQuery.of(context).size.height - space_13,
                    child: Stack(children: <Widget>[
                      loading_map && loadmap2 && loadmap3 ||
                              !(widget.online!) &&
                                  loading_map //condition to show loadingIndicator until routes and map is created
                          ? Container()
                          : Center(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: const CircularProgressIndicator(
                                  color: darkBlueColor,
                                ),
                              ),
                            ),
                      loadmap2 && loadmap3 ||
                              !(widget
                                  .online!) //condition to show loadingIndicator until route is created
                          ? GoogleMap(
                              onTap: (position) {
                                _customInfoWindowController.hideInfoWindow!();
                                _customDetailsInfoWindowController
                                    .hideInfoWindow!();
                              },
                              onCameraMove: (position) {
                                _customInfoWindowController.onCameraMove!();
                                _customDetailsInfoWindowController
                                    .onCameraMove!();
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
                                _customInfoWindowController
                                    .googleMapController = controller;
                                _customDetailsInfoWindowController
                                    .googleMapController = controller;
                                setState(() {
                                  loading_map =
                                      true; //variable is made true when map is created.
                                });
                              },
                              gestureRecognizers:
                                  <Factory<OneSequenceGestureRecognizer>>[
                                new Factory<OneSequenceGestureRecognizer>(
                                  () => new EagerGestureRecognizer(),
                                ),
                              ].toSet(),
                            )
                          : Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Center(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: const CircularProgressIndicator(
                                      color: darkBlueColor,
                                    ),
                                  ),
                                ),
                              ),
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
                        left: Responsive.isMobile(context) ? 10 : 20,
                        top: Responsive.isMobile(context) ? 325 : 20,
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
                                      borderRadius:
                                          const BorderRadius.horizontal(
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
                                          col2 = const Color(0xffFF5C00);
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
                                          col1 = const Color(0xffFF5C00);
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
                        bottom: Responsive.isMobile(context)
                            ? height / 2 + 90
                            : 100,
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
                        bottom:
                            Responsive.isMobile(context) ? height / 2 + 40 : 50,
                        child: SizedBox(
                          height: 40,
                          child: FloatingActionButton(
                            heroTag: "btn3",
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            child: const Icon(Icons.zoom_out,
                                size: 22, color: darkBlueColor),
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
                        bottom: Responsive.isMobile(context)
                            ? height / 2 + 150
                            : 150,
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
                      Responsive.isMobile(context)
                          ? Positioned(
                              right: 10,
                              top: 325,
                              child: Container(
                                height: 40,
                                width: 110,
                                alignment: Alignment.centerRight,
                                decoration: const BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.19),
                                        offset: Offset(
                                          0,
                                          5.33,
                                        ),
                                        blurRadius: 9.33,
                                        spreadRadius: 0.0,
                                      ),
                                    ]),
                                child: DropdownButton(
                                  underline: Container(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: Text('24 hours'),
                                  ),
                                  icon: Container(
                                    width: 36,
                                    child: Row(children: [
                                      Expanded(
                                        child: Container(
                                          width: 36,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: darkBlueColor,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 15,
                                              color: white),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  style: TextStyle(
                                      color: shareImageTextColor,
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
                            )
                          : Container(),
                    ])),
              ),
              Responsive.isMobile(context)
                  ? Positioned(
                      top: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: white,
                          child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: space_13,
                              color: white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        space_3, 0, space_3, 0),
                                    child: Header(
                                        reset: false,
                                        text: "${widget.truckNo} ",
                                        backButton: true),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 45),
                                    child: Container(
                                      child: Text(
                                        "( $totalStatus )",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])))
                  : Container(),
              Responsive.isMobile(context)
                  ? Container()
                  : Positioned(
                      top: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: white,
                          child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: space_13,
                              color: white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        space_3, 10, space_3, 0),
                                    child: Header(
                                        reset: false,
                                        text: "${widget.truckNo} ",
                                        backButton: true),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: DropdownButton(
                                      underline: Container(),
                                      hint: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                              ),
                                            ),
                                            child: const Text('24 hours')),
                                      ),
                                      icon: Container(
                                        width: 36,
                                        child: Row(children: [
                                          Expanded(
                                            child: Container(
                                              width: 36,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: darkBlueColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 15,
                                                  color: white),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      style: TextStyle(
                                          color: shareImageTextColor,
                                          fontSize: size_6,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400),
                                      // Not necessary for Option 1
                                      value: _selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedLocation =
                                              newValue.toString();
                                        });
                                        customSelection(_selectedLocation);
                                      },
                                      items: _locations.map((location) {
                                        return DropdownMenuItem(
                                          child: Container(
                                              child: new Text(location.tr)),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]))),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                top: Responsive.isMobile(context) ? null : space_13,
                left: 0,
                bottom: (showBottomMenu) ? 0 : -(height / 3) + 44,
                child: TrackScreenDetails(
                  finalDistance: widget.totalDistance,
                  gpsData: newGPSData,
                  dateRange: selectedDate,
                  TruckNo: widget.truckNo,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
                  stops: stoplatlong,
                  totalRunningTime: totalRunningTime,
                  totalStoppedTime: totalStoppedTime,
                  deviceId: widget.deviceId,
                  recentStops: gpsStoppageHistory,
                  imei: widget.imei,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
