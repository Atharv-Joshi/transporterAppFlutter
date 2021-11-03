import 'dart:async';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:logger/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:screenshot/screenshot.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:ui' as ui;

class TrackScreen extends StatefulWidget {
  final List gpsData;
  final Position position;
  final String? TruckNo;
  final String? imei;
  final String? driverNum;
  final String? driverName;

  TrackScreen({
    required this.gpsData,
    required this.position,
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
  late LatLng lastlatLngMarker;
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition;
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
  PolylinePoints polylinePoints = PolylinePoints();
  late PointLatLng start;
  late PointLatLng end;
  String? truckAddress;
  String? truckDate;
  String? Speed;
  String googleAPiKey = "AIzaSyCPU872xIfRhjvtdLViTDbj0EnIBuxlcSs";
  bool popUp=false;
  List<PolylineWayPoint> waypoints = [];
  var gpsDataHistory;
  var gpsStoppageHistory;
  late Uint8List markerIcon;
  var markerslist;

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
      // getCurrentLocation();
      getTruckLocation();
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
  getTruckHistory() async{
    var logger = Logger();
    logger.i("in truck history function");

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var nowTime = dateFormat.format(DateTime.now()).split(" ");
    var timestamp = nowTime[0].replaceAll("-", "");
    var year = timestamp.substring(0, 4);
    var month = int.parse(timestamp.substring(4, 6));
    var day = timestamp.substring(6, 8);
    var date = "$day-$month-$year";
    var time = nowTime[1];
    var endTimeParam = "$date $time";

    var yesterday2 = DateTime.now().subtract(Duration(days: 1));
    var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1))).split(" ");
    var timestamp2 = yesterday[0].replaceAll("-", "");
    var year2 = timestamp2.substring(0, 4);
    var month2 = int.parse(timestamp2.substring(4, 6));
    var day2 = timestamp2.substring(6, 8);
    var date2 = "$day2-$month2-$year2";
    var time2 = yesterday[1];
    var startTimeParam = "$date2 $time2";

    print("START is $startTimeParam and END is $endTimeParam");

    gpsDataHistory =
    await mapUtil.getLocationHistoryByImei(
        imei: widget.imei,
        starttime: startTimeParam,
        endtime: endTimeParam,
        choice: "deviceTrackList");
    gpsStoppageHistory =
    await mapUtil.getLocationHistoryByImei(
        imei: widget.imei,
        starttime: startTimeParam,
        endtime: endTimeParam,
        choice: "stoppagesList");
    getStoppage(gpsStoppageHistory);
    int a=0;
    int b=a+1;
    int c=0;
    print("length ${gpsDataHistory.length}");
    print("End lat ${gpsDataHistory[gpsDataHistory.length-1].lat}");
    for(int i=0; i<gpsDataHistory.length; i++) {
      c=b+1;
      PointLatLng point1 =  PointLatLng(gpsDataHistory[a].lat,  gpsDataHistory[a].lng);
      PointLatLng point2 =  PointLatLng(gpsDataHistory[b].lat,  gpsDataHistory[b].lng);
      _getPolyline(point1, point2);
      a=b;
      b=c;
      if(b>=gpsDataHistory.length){
        break;
        }
    }
    if(gpsDataHistory.length%2==0){
      print("In even ");
      PointLatLng point1 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-2].lat,  gpsDataHistory[gpsDataHistory.length-2].lng);
      PointLatLng point2 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-1].lat,  gpsDataHistory[gpsDataHistory.length-1].lng);
      _getPolyline(point1, point2);
    }
  }

  getStoppage(var gpsStoppage) async{
    print("Stop length ${gpsStoppage.length}");
    LatLng? latlong;
    List<LatLng> stoplatlong = [];
    for(var stop in gpsStoppage) {
      latlong=LatLng(stop.lat, stop.lng);
      stoplatlong.add(latlong);
    }
    print("Stops $stoplatlong");
    markerIcon = await getBytesFromCanvas(1, 100, 100);
    for(int i=0; i<stoplatlong.length; i++){
                  setState(() {
                    customMarkers.add(Marker(
                        markerId: MarkerId("Stop Mark $i"),
                        position: stoplatlong[i],
                        infoWindow: InfoWindow(title: "Your Location"),
                        icon: BitmapDescriptor.fromBytes(markerIcon),));
                  });
                  markerIcon = await getBytesFromCanvas(i+1, 100, 100);
    }
  }

  Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.red;
    final Radius radius = Radius.circular(width/2);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: TextStyle(fontSize: 50.0, color: Colors.white),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  getTruckLocation() async{
    placemarks = await placemarkFromCoordinates(newGPSData.last.lat, newGPSData.last.lng);
    print("Truck los is $placemarks");
    var first = placemarks.first;
    print("${first.subLocality},${first.locality},${first.administrativeArea}\n${first.postalCode},${first.country}");
    setState(() {
      if(first.subLocality=="")
        truckAddress = "${first.street}, ${first.locality}, ${first.administrativeArea},\n${first.postalCode}, ${first.country}";

      else
        truckAddress = "${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea},\n${first.postalCode}, ${first.country}";
    });
    print("truck add is $truckAddress");
    iconthenmarker();
  }
  getTruckDate() {
    var somei = widget.gpsData.last.gpsTime;
    var timestamp = somei.toString().replaceAll(" ", "").replaceAll("/", "").replaceAll(":", "");
    var year = timestamp.substring(4, 8);
    var month = int.parse(timestamp.substring(2, 4));
    var day = timestamp.substring(0, 2);
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var monthname  = DateFormat('MMM').format(DateTime(0, month));
    var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
    setState(() {
      truckDate = "$ampm, $day $monthname $year";
      print("Truck date is $truckDate");
      direction = double.parse(widget.gpsData.last.direction);
      print("direction is $direction");
    });
  }
  getTruckDateAfter() {
    var somei = newGPSData.last.gpsTime;
    var timestamp = somei.toString().replaceAll(" ", "").replaceAll("/", "").replaceAll(":", "");
    var year = timestamp.substring(4, 8);
    print("timestamp is $timestamp");
    var month = int.parse(timestamp.substring(2, 4));
    var day = timestamp.substring(0, 2);
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var monthname  = DateFormat('MMM').format(DateTime(0, month));
    var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
    setState(() {
      truckDate = "$ampm, $day $monthname $year";
      print("Truck date is $truckDate");
      direction = double.parse(newGPSData.last.direction);
      print("direction after is $direction");
    });
  }

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted)
        getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    LatLng? latlong;
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Your positiion is ${widget.position.latitude}, ${widget.position.longitude}");
    start = PointLatLng(widget.position.latitude, widget.position.longitude);
    end = PointLatLng(newGPSData.last.lat, newGPSData.last.lng);
    // setState(() {
    //   latlong = LatLng(widget.position.latitude, widget.position.longitude);
    //   BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
    //       'assets/icons/manIcon.png')
    //       .then((value) => {
    //     setState(() {
    //       pinLocationIcon = value;
    //       customMarkers.add(Marker(
    //           markerId: MarkerId("Transporter Mark"),
    //           position: latlong!,
    //           infoWindow: InfoWindow(title: "Your Location"),
    //           icon: pinLocationIcon));
    //     }),
    //   });
    // });
    print("Start 1 is $start");
    print("End  1 is $end");
    // _getPolyline(start, end);
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
  _getPolyline(PointLatLng start, PointLatLng end) async {
    var logger = Logger();
    logger.i("in polyline function");
    print("Start 3 is $start \nEnd 3 is $end");
    setState(() {
            polylineCoordinates.add(LatLng(start.latitude, start.longitude));
            polylineCoordinates.add(LatLng(end.latitude, end.longitude));
          });
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
    setState(() {
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
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    initfunction();
    getLocation();
    getTruckLocation();
    getTruckHistory();
    getTruckDateAfter();
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
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF525252),
      //   title: ,
      // ),
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
                child: GoogleMap(
                  markers: customMarkers.toSet(),
                  // polylines: _polyline,
                  polylines: Set.from(polylines.values),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: camPosition,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
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
                                        "$truckAddress",
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
                              Row(
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
                              InkWell(
                                onTap: (){
                                  print("tapped");
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