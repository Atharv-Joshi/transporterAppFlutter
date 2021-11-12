import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

class TrackScreen extends StatefulWidget {
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  final String? TruckNo;
  final String? imei;
  final String? driverNum;
  final String? driverName;

  TrackScreen({
    required this.gpsData,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    // required this.position,
    this.TruckNo,
    this.driverName,
    this.driverNum,
    this.imei});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}
class _TrackScreenState extends State<TrackScreen> with SingleTickerProviderStateMixin {
  final Set<Polyline> _polyline = {};
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(widget.gpsData.last.lat, widget.gpsData.last.lng);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =  CameraPosition(
      target: lastlatLngMarker,
      zoom: 8.0);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData=widget.gpsData;
  late List reversedList;
  late List oldGPSData;
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
  var stoppageTime = [];
  var duration = [];
  var stopAddress = [];
  String? Speed;
  String googleAPiKey = FlutterConfig.get("mapKey");
  bool popUp=false;
  List<PolylineWayPoint> waypoints = [];
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  late AnimationController _acontroller;
  late Animation<double> _heightFactorAnimation;
  double collapsedHeightFactor = 0.80;
  double expandedHeightFactor = 0.50;
  bool isAnimation = false;
  double mapHeight=600;

  var direction;

  @override
  void initState() {
    super.initState();
    _acontroller=AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _heightFactorAnimation = Tween<double>(begin: collapsedHeightFactor, end: expandedHeightFactor).animate(_acontroller);
    try {
      initfunction();
      iconthenmarker();
      getTruckHistory();
      getTruckDate();
      logger.i("in init state function");
      lastlatLngMarker = LatLng(widget.gpsData.last.lat, widget.gpsData.last.lng);
      camPosition = CameraPosition(
          target: lastlatLngMarker,
          zoom: 8.0
      );
      timer = Timer.periodic(Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }
  }

  //get truck route history on map

  getTruckHistory() {
    gpsDataHistory=widget.gpsDataHistory;
    gpsStoppageHistory=widget.gpsStoppageHistory;
    getStoppage(widget.gpsStoppageHistory);
    polylineCoordinates = getPoylineCoordinates(gpsDataHistory);
    _getPolyline(polylineCoordinates);
  }

  //function is called every one minute to get updated history

  getTruckHistoryAfter() async{
    var logger = Logger();
    logger.i("in truck history after function");
    gpsDataHistory = await getDataHistory(widget.imei, dateFormat.format(DateTime.now().subtract(Duration(days: 1))),  dateFormat.format(DateTime.now()) );
    gpsStoppageHistory = await getStoppageHistory(widget.imei, dateFormat.format(DateTime.now().subtract(Duration(days: 1))),  dateFormat.format(DateTime.now()));
    getStoppage(gpsStoppageHistory);
    polylineCoordinates = getPoylineCoordinates(gpsDataHistory);
    _getPolyline(polylineCoordinates);

  }

  getStoppage(var gpsStoppage) async{
    stopAddress = [];
    stoppageTime = [];
    duration = [];
    print("Stop length ${gpsStoppage.length}");
    LatLng? latlong;
    List<LatLng> stoplatlong = [];
    for(var stop in gpsStoppage) {
      latlong=LatLng(stop.lat, stop.lng);
      stoplatlong.add(latlong);
    }
    stoppageTime = getStoppageTime(gpsStoppage);
    stopAddress = await getStoppageAddress(gpsStoppage);
    duration = getStoppageDuration(gpsStoppage);

    for(int i=0; i<stoplatlong.length; i++){
      markerIcon = await getBytesFromCanvas(i+1, 100, 100);
      setState(() {
                    customMarkers.add(Marker(
                        markerId: MarkerId("Stop Mark $i"),
                        position: stoplatlong[i],
                        icon: BitmapDescriptor.fromBytes(markerIcon),

                        //info window
                        onTap: (){
                          _customInfoWindowController.addInfoWindow!(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Opacity(
                                      opacity: 0.5 ,
                                      child: Container(
                                        alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          (duration[i]!="Ongoing")?
                                          Container(
                                            margin: EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "${duration[i]}",
                                              style: TextStyle(
                                              color: white,
                                                  fontSize: size_6,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: regularWeight
                                              ),
                                            ),
                                          ) :
                                          SizedBox(
                                            height: 8.0,
                                          ),

                                          Text(
                                            "${stoppageTime[i]}",
                                            style: TextStyle(
                                            color: white,
                                                fontSize: size_6,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            "${stopAddress[i]}",
                                            style: TextStyle(
                                                color: white,
                                                fontSize: size_6,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                                ),
                              ],
                            ),
                            stoplatlong[i],
                          );
                        },
                    ));
                  });
    }
  }

  //get current date and time

  getTruckDate() {
    setState(() {
      truckDate = getFormattedDateForDisplay3(DateTime.now().toString());
      print("Truck date is $truckDate");
    });
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

  _makingPhoneCall() async {

    String url = 'tel:${widget.driverNum}';
    UrlLauncher.launch(url);
  }

  void initfunction() async {
    var gpsData = await mapUtil.getLocationByImei(imei: widget.imei);
    var gpsRoute = await getRouteStatusList(widget.imei, dateFormat.format(DateTime.now().subtract(Duration(days: 1))),  dateFormat.format(DateTime.now()));
    setState(() {
      newGPSRoute = gpsRoute;
      print("NEW ROute $newGPSRoute");
      newGPSData = gpsData;
      oldGPSData = newGPSData.reversed.toList();
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
  }

  //function called every one minute
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    initfunction();
    getTruckHistoryAfter();
    getTruckDate();
    iconthenmarker();
  }

  void createmarker() async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng latLngMarker =
      LatLng(newGPSData.last.lat, newGPSData.last.lng);
      print("Live location is ${newGPSData.last.lat}");
      String? title = widget.TruckNo;
      setState(() {
        direction = double.parse(newGPSData.last.direction);
        lastlatLngMarker = LatLng(newGPSData.last.lat, newGPSData.last.lng);
        latlng.add(lastlatLngMarker);
        customMarkers.add(Marker(
            markerId: MarkerId(newGPSData.last.id.toString()),
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
          zoom: 15.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, space_4, 0, 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: space_4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                      child: Header(
                          reset: false,
                          text: 'Location Tracking',
                          backButton: true
                      ),
                    ),
                    HelpButtonWidget()
                  ],
                ),
              ),
              Container(
                // width: 250,
                // height: 500,
                height: 375,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                    children: <Widget>[
                      GoogleMap(
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  markers: customMarkers.toSet(),
                  polylines: Set.from(polylines.values),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: camPosition,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _customInfoWindowController.googleMapController = controller;
                  },
                ),

              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 110,
                width: 275,
                offset: 30,
              ),])
              ),
              Container(
                height: 245,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)
                    )
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: space_11,
                        decoration : BoxDecoration(
                            color: shadowGrey2,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)
                            )
                        ),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.driverName}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: size_7,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: mediumBoldWeight
                              ),
                            ),
                            SizedBox(
                                width: 15
                            ),
                            Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    height: space_5,
                                    width: space_16,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(width: borderWidth_10, color: black)),
                                    padding: EdgeInsets.only(left: (space_3 - 1), right: (space_3 - 2)),
                                    margin: EdgeInsets.only(right: (space_3)),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: space_3,
                                            width: space_3,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage("assets/icons/callButtonIcon.png"))),
                                          ),
                                          SizedBox(
                                            width: space_1,
                                          ),
                                          Text(
                                            "Call",
                                            style: TextStyle(fontSize: size_7, color: black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    _makingPhoneCall();
                                  },
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Speed",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontWeight: mediumBoldWeight,
                                  ),
                                ),
                                SizedBox(
                                    height: 10
                                ),
                                Text(
                                  "${newGPSData.last.speed} km/h",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontWeight: regularWeight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: shareImageTextColor,
                                ),
                                SizedBox(
                                    width: 10
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 300,
                                      child: Text(
                                        "${newGPSData.last.address}",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: size_6,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: mediumBoldWeight
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 180,
                                      child: Text(
                                        "$truckDate",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: size_6,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: regularWeight
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                          margin: EdgeInsets.only(top: 15),
                          width: 345,
                          height: 0.4,
                          decoration: BoxDecoration(
                            color: black,
                          )
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) => NextUpdateAlertDialog());
                                    },
                                child: Row(
                                  children: [
                                    Container(
                                      height: (space_4 + 2),
                                      width: (space_4 + 2),
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: bidBackground,
                                      )
                                      // decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //         image: AssetImage("assets/icons/playicon.png"))),
                                    ),
                                    SizedBox(
                                      width: space_2,
                                    ),
                                    Text(
                                      "Play trip history",
                                      style: TextStyle(
                                          fontSize: size_6,
                                          color: bidBackground,
                                          fontWeight: mediumBoldWeight,
                                          fontStyle: FontStyle.normal
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  print("tapped");
                                  Get.to(TruckHistoryScreen(
                                    gpsData: newGPSData.last,
                                    gpsTruckHistory: gpsDataHistory,
                                    gpsStoppageHistory: gpsStoppageHistory,
                                    truckNo: widget.TruckNo,
                                    gpsTruckRoute: newGPSRoute,
                                  ));
                                },
                                child: Container(
                                    width: 130,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: bidBackground,
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        "See history",
                                        style: TextStyle(
                                            color: white,
                                            fontSize: size_6,
                                            fontWeight: mediumBoldWeight,
                                            fontStyle: FontStyle.normal
                                        )
                                    )
                                ),
                              ),
                            ]
                        ),
                      )
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}