import 'dart:async';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/invalidDateConditionDialog.dart';
import 'package:liveasy/widgets/playRouteDetailsWidget.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';


const kMarkerId = MarkerId('MarkerId1');
const kMarkerId2 = MarkerId('MarkerId2');

class PlayRouteHistory extends StatefulWidget {
  var gpsData;
  var gpsTruckHistory;
  var gpsStoppageHistory;
  var routeHistory;
  var totalRunningTime;
  var totalStoppedTime;
  double totalDistance;
  String? truckNo;
  String? dateRange;
  // String? toDate;
  // List<LatLng> polylineCoordinates ;

  PlayRouteHistory({
    required this.gpsTruckHistory,
    required this.gpsStoppageHistory,
    required this.gpsData,
    required this.routeHistory,
    required this.totalDistance,
    required this.truckNo,
    required this.dateRange,
    required this.totalRunningTime,
    required this.totalStoppedTime,
    // required this.toDate,
    // required this.polylineCoordinates,
  });

  @override
  _PlayRouteHistoryState createState() => _PlayRouteHistoryState();
}

class _PlayRouteHistoryState extends State<PlayRouteHistory> with WidgetsBindingObserver{
  List<Marker> customMarkers = [];
  String time = getFormattedDateForDisplay3(DateTime.now().toString());
  Map<PolylineId, Polyline> polylines = {};
  late List<LatLng> polylineCoordinates2 ;
  final Set<Polyline> _polyline = {};
  late LatLng lastlatLngMarker = LatLng(gpsData.last.lat, gpsData.last.lng);
  late CameraPosition camPosition;
  Completer<GoogleMapController> _controller = Completer();
  String googleAPiKey = FlutterConfig.get("mapKey");
  late BitmapDescriptor pinLocationIconTruck;
  var direction;
  List<LatLng> latlng = [];
  var gpsData = [];
  var gpsTruckHistory = [];
  var gpsStoppageHistory = [];
  var routeHistory = [];
  var stops = [];
  var totalDistance;
  String? dateRange;
  var logger = Logger();
  int i =0;
  var start;
  var end;
  late DateTimeRange newRange;
  var selectedDateString = [];
  DateTime today = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  DateTimeRange selectedDate = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 1)),
      end: DateTime.now()
  );
  bool showBottomMenu = true;
  var markers = <MarkerId, Marker>{};
  var controller = Completer<GoogleMapController>();
  var stream;
  var Locations = [];
  late Uint8List markerIcon;
  var routeTime = [];
  var routeSpeed = [];
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  var totalRunningTime;
  var totalStoppedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    try {
      initfunction();
      getTruckHistory();
      getDateRange();
      getInfoWindow();
      getStops();

      check();
      getTime();
      logger.i("in init state function");

    } catch (e) {
      logger.e("Error is $e");
    }
    if(mounted)
      setState(() {
        camPosition = CameraPosition(
            target: LatLng(gpsTruckHistory[0].lat, gpsTruckHistory[0].lng),
            zoom: 11.5
        );
        stream = Stream.periodic(Duration(milliseconds: 350), (count) => Locations[count])
            .take(Locations.length);
      });

  }

  initfunction(){
    setState(() {
      gpsData = widget.gpsData;
      gpsTruckHistory = widget.gpsTruckHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
      routeHistory = widget.routeHistory;
      totalDistance = widget.totalDistance;
      dateRange = widget.dateRange;
      totalRunningTime = widget.totalRunningTime;
      totalStoppedTime = widget.totalStoppedTime;
      // fromDate = widget.fromDate;
      // toDate = widget.toDate;
    });
    getLatLngList();
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

  getInfoWindow(){
    routeTime = [];
    routeSpeed = [];
    int a=0;
    int c=0;
    for(int i=0; i<gpsTruckHistory.length ; i++){
      c=a+10;

      print("Route Inst ${gpsTruckHistory[a].gpsTime}");
      var somei = gpsTruckHistory[a].gpsTime;
      var timestamp = somei.toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
      var month = int.parse(timestamp.substring(2, 4));
      var day = timestamp.substring(0, 2);
      var hour = int.parse(timestamp.substring(8, 10));
      var minute = int.parse(timestamp.substring(10, 12));
      var monthname  = DateFormat('MMM').format(DateTime(0, month));
      var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
      var time = "$day $monthname, $ampm";
      routeTime.add("$time");
      routeSpeed.add("${gpsTruckHistory[a].gpsSpeed} km/h");

      a=c;
      if(a>=gpsTruckHistory.length){
        break;
      }
    }
    print("Route Time ${routeTime}");
    print("Route speed ${routeSpeed}");

  }

  getStops() async {
    stops = [];
    for(var stop in gpsStoppageHistory) {
      stops.add(LatLng(stop.lat, stop.lng));
    }
    print("Stop Locations $stops");
    for(int i=0; i<stops.length; i++){
      markerIcon = await getBytesFromCanvas(i+1, 100, 100);
      setState(() {
        customMarkers.add(Marker(
          markerId: MarkerId("Stop Mark $i"),
          position: stops[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
      });
    }
  }
  void check(){
    print("Stop Locations $stops");
    print("Route time  $routeTime");
  }

  getLatLngList(){
    Locations.clear();
    int a=0;
    int b=a+1;
    int c=0;
    for(int i=0; i<gpsTruckHistory.length ; i++){
      c=a+10;
      Locations.add(LatLng(gpsTruckHistory[a].lat, gpsTruckHistory[a].lng));
      // Locations.add(LatLng(gpsTruckHistory[b].lat, gpsTruckHistory[b].lng));
      a=c;
      // b=c;
      if(a>=gpsTruckHistory.length){
        break;
      }
    }
  }

  void newLocationUpdate(LatLng latLng) async{
    markerIcon = await getBytesFromCanvas2(routeTime[i].toString(),routeSpeed[i].toString(), 300, 150);
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/playHistoryPin.png')
        .then((value) => {
          if(mounted)
            {
                  setState(() {
                    pinLocationIconTruck = value;
                  }),
                  setState(()
                  {
                    markers[kMarkerId] = Marker(
                        markerId: kMarkerId,
                        position: latLng,
                        icon: pinLocationIconTruck,
                        rotation: 180,
                        onTap: () {
                          print("Tapped");

                        });
                    customMarkers.add(Marker(
                        markerId: kMarkerId2,
                        position: latLng,
                        icon: BitmapDescriptor.fromBytes(markerIcon),
                        ));
                  })
                }
            });
    ;
    i=i+1;
  }
  newLocationUpdate2(LatLng latLng) {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/playHistoryPin.png')
        .then((value) => {
      if(mounted)
        {
          setState(() {
            pinLocationIconTruck = value;
          }),
          setState(()
          {
            markers[kMarkerId2] = Marker(
                markerId: kMarkerId2,
                position: latLng,
                icon: pinLocationIconTruck,
                rotation: 180,
                onTap: () {
                  print("Tapped");

                });
          })
        }
    });
    ;
  }


  getDateRange(){
    var splitted = dateRange!.split(" - ");
    var start1 = getFormattedDateForDisplay2(splitted[0]).split(", ");
    var end1 = getFormattedDateForDisplay2(splitted[1]).split(", ");
    var start2 = start1[0].split(" ");
    var end2 = end1[0].split(" ");
    start = start1[0];
    end = end1[0];
    print("Start is ${start} and ENd is ${end}");
  }



  getTruckHistory() {
    logger.i("in truck History function");
    polylineCoordinates2 = getPoylineCoordinates2(gpsTruckHistory);
    _getPolyline(polylineCoordinates2);
  }
  getTime(){
    print("Date Timenow ${DateTime.now().toString()}");
    setState(() {
      time = getFormattedDateForDisplay3(DateTime.now().toString());
    });
  }

  _getPolyline(List<LatLng> polylineCoordinates2) {
    var logger = Logger();
    logger.i("in polyline function 2");
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: loadingWidgetColor,
      points: polylineCoordinates2,
      width: 2,
    );
    setState(() {
      polylines[id] = polyline;
    });
    print("$polylines");

    _addPolyLine();
  }
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      width: 4,
      points: polylineCoordinates2,
      visible: true,
    );
    setState(() {
      polylines[id] = polyline;
      _polyline.add(polyline);
    });
  }

  void dispose() {
    logger.i("Activity is disposed");
    // timer.cancel();
    // stream.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double threshold = 100;

    return SafeArea(
      child: Scaffold(
        backgroundColor: statusBarColor,
          body: GestureDetector(
            onTap: (){
              setState(() {
                showBottomMenu = !showBottomMenu;
              });
            },
            onPanEnd: (details){
              if(details.velocity.pixelsPerSecond.dy > threshold) {
                this.setState(() {
                  showBottomMenu = false;
                });
              }
              else if(details.velocity.pixelsPerSecond.dy < -threshold){
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
                        bottom: 0 ,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                                children: <Widget>[
                                  Animarker(
                                    curve: Curves.easeIn,
                                    angleThreshold: 30,
                                    zoom: 11.5,
                                    useRotation: true,
                                    duration: Duration(milliseconds: 380 ),
                                    mapId: controller.future
                                        .then<int>((value) => value.mapId), //Grab Google Map Id
                                    markers: markers.values.toSet(),
                                    child: GoogleMap(
                                      // onTap: (position) {
                                      //   _customInfoWindowController.hideInfoWindow!();
                                      // },
                                      // onCameraMove: (position) {
                                      //   _customInfoWindowController.onCameraMove!();
                                      // },
                                      markers: customMarkers.toSet(),
                                      polylines: Set.from(polylines.values),
                                      myLocationButtonEnabled: true,
                                      zoomControlsEnabled: false,
                                      initialCameraPosition: camPosition,
                                      compassEnabled: true,
                                      mapType: MapType.normal,
                                      onMapCreated: (gController) {
                                        stream.forEach((value) => newLocationUpdate(value));
                                        // stream.forEach((value) => newLocationUpdate2(value));
                                        controller.complete(gController);
                                        _customInfoWindowController.googleMapController = gController;

                                      },
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                        new Factory<OneSequenceGestureRecognizer>(
                                              () => new EagerGestureRecognizer(),
                                        ),
                                      ].toSet(),
                                    ),
                                  ),
                                  // CustomInfoWindow(
                                  //   controller: _customInfoWindowController,
                                  //   height: 110,
                                  //   width: 275,
                                  //   offset: 30,
                                  // ),

                                ]
                            )
                        ),
                      ),
                Positioned(
                  top: 0,
                  // left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: white,

                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(space_3, space_3, 0, space_3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   width: space_3,
                                // ),
                                Header(
                                    reset: false,
                                    text: "${widget.truckNo}",
                                    backButton: true),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(space_9, space_2, 0, space_2),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                            Text("$totalDistance km",
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
                                    SizedBox(
                                        width: space_2
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text("${gpsData.last.speed} km/h",
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
                        ]
                    ),
                  ),
                ),

                AnimatedPositioned(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 400),
                  left: 0,
                  bottom: (showBottomMenu)? -30 : -(height/3),

                  child: MenuWidget(dateRange: dateRange, gpsData: gpsData, truckNo: widget.truckNo,),
                )
                //MENU PLACE
              ],
            ),
          )

      ),
    );
  }
}

