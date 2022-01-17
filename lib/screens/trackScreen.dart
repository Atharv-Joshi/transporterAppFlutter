import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
import 'package:liveasy/widgets/stoppageInfoWindow.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

class TrackScreen extends StatefulWidget {
  final List gpsData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  final String? TruckNo;
  final int? deviceId;
  final String? driverNum;
  final String? driverName;
  var truckId;
  var gpsRoute;
  var totalRunningTime;
  var totalDistance;
  TrackScreen({
    required this.gpsData,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    // required this.position,
    this.gpsRoute,
    this.TruckNo,
    this.driverName,
    this.driverNum,
    this.deviceId,
    this.totalRunningTime,
    this.totalDistance,
    this.truckId});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}
class _TrackScreenState extends State<TrackScreen> with WidgetsBindingObserver{
  final Set<Polyline> _polyline = {};
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(widget.gpsData.last.latitude, widget.gpsData.last.longitude);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =  CameraPosition(
      target: lastlatLngMarker,
      zoom: 10);
  var logger = Logger();
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  late Timer timer2;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData=widget.gpsData;
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
  var newGPSRouteWithStops;
  var totalDistance;
  
  var stoppageTime = [];
  List<LatLng> stoplatlong = [];
  var duration = [];
  var stopAddress = [];
  String? Speed;
  String googleAPiKey = FlutterConfig.get("mapKey");
  bool popUp=false;
  List<PolylineWayPoint> waypoints = [];
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight=600;
  DateTimeRange selectedDate = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 1)),
   end: DateTime.now()
  );
  var direction;
  bool setDate = false;
  var selectedDateString = [];
  var maptype = MapType.normal;
  double zoom = 15;
  bool showBottomMenu = true;
  var totalRunningTime;
  var totalStoppedTime;
  var status;
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    
    try {
      initfunction();
      initfunction2();
      iconthenmarker();
      getTruckHistory();
      logger.i("in init state function");
      lastlatLngMarker = LatLng(newGPSData.last.latitude, newGPSData.last.longitude);
      camPosition = CameraPosition(
          target: lastlatLngMarker,
          zoom: zoom
      );

      timer = Timer.periodic(Duration(minutes: 5, seconds: 0), (Timer t) => onActivityExecuted());
      timer2 = Timer.periodic(Duration(minutes: 0, seconds: 10), (Timer t) => onActivityExecuted2());
    } catch (e) {
      logger.e("Error is $e");
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

  getTruckHistory() {
    gpsDataHistory=widget.gpsDataHistory;
    print("Gps data history length ${gpsDataHistory.length}");
    gpsStoppageHistory=widget.gpsStoppageHistory;
    getStoppage(widget.gpsStoppageHistory);
    polylineCoordinates = getPoylineCoordinates(gpsDataHistory);
    _getPolyline(polylineCoordinates);
  }

  //function is called every one minute to get updated history

  getTruckHistoryAfter() {
    var logger = Logger();
    logger.i("in truck history after function");
    getStoppage(gpsStoppageHistory);
    polylineCoordinates.add(LatLng(newGPSData.last.latitude, newGPSData.last.longitude));
    _getPolyline(polylineCoordinates);

  }

  getStoppage(var gpsStoppage) async{
    stopAddress = [];
    stoppageTime = [];
    stoplatlong = [];
    duration = [];
    print("Stop length ${gpsStoppage.length}");
    LatLng? latlong;

    for(var stop in gpsStoppage) {
      latlong=LatLng(stop.latitude, stop.longitude);
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
                            getInfoWindow(duration[i], stoppageTime[i], stopAddress[i]),
                            stoplatlong[i],
                          );
                        },
                    ));
                  });
    }
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

  initfunction() async{
  //  var gpsRoute = await getRouteStatusList(newGPSData.last.deviceId, from , to);
   // var gpsStoppageHistory = await getStoppageHistory(newGPSData.last.deviceId, from,  to);
    setState(() {
      newGPSData = widget.gpsData;
      
      gpsStoppageHistory = widget.gpsStoppageHistory;
      totalDistance = widget.totalDistance;
      totalRunningTime = widget.totalRunningTime;
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      
      status = getStatus(newGPSData, gpsStoppageHistory);
     newGPSRouteWithStops = widget.gpsRoute;
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
    var gpsData = await mapUtil.getTraccarPosition(deviceId : widget.deviceId);
    var gpsRoute = await getRouteStatusList(newGPSData.last.deviceId, from , to);
    var newGpsDataHistory = await getDataHistory(gpsData.last.deviceId, from , to);
    var newGpsStoppageHistory = await getStoppageHistory(gpsData.last.deviceId, from , to);
    setState(() {
      newGPSRoute = gpsRoute;
      gpsDataHistory = newGpsDataHistory;
      gpsStoppageHistory = newGpsStoppageHistory;
      newGPSRouteWithStops = gpsRoute;
      newGPSData = gpsData;
      selectedDate = DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 1)),
          end: DateTime.now()
      );
      print("NEW ROute $newGPSRoute");
      totalRunningTime = getTotalRunningTime(newGPSRoute);
      totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);
      totalDistance = getTotalDistance(newGPSRoute);
      print("after running time $totalRunningTime");
      print("after stopped time $totalStoppedTime");
      status = getStatus(newGPSData, gpsStoppageHistory);
      newGPSRouteWithStops = getStopList(newGPSRouteWithStops);
      print("HERE ROute $newGPSRoute");
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
    initfunctionAfter();
    getTruckHistory();
    iconthenmarker();
  }
  void onActivityExecuted2() async{
    newGPSData = await mapUtil.getTraccarPosition(deviceId : widget.deviceId);
    getTruckHistoryAfter();

    iconthenmarker();
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

  @override
  void dispose() {
    logger.i("Activity is disposed");
    timer.cancel();
    timer2.cancel();
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
                              mapType: maptype,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                _customInfoWindowController.googleMapController = controller;
                              },
                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
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
                                    top: 275,
                                    child: SizedBox(
                                      height: 40,
                                      child: FloatingActionButton(
                                        heroTag: "btn1",
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: const Icon(Icons.my_location, size: 22, color: Color(0xFF152968) ),
                                        onPressed: () {
                                          setState(() {
                                            this.maptype=(this.maptype == MapType.normal) ? MapType.satellite : MapType.normal;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: height/3+140,
                                    child: SizedBox(
                                      height: 40,
                                      child: FloatingActionButton(
                                        heroTag: "btn2",
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: const Icon(Icons.zoom_in, size: 22,  color: Color(0xFF152968)),
                                        onPressed: () {
                                          setState(() {
                                            this.zoom = this.zoom + 0.5;
                                          });
                                          this._googleMapController.animateCamera(CameraUpdate.newCameraPosition(
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
                                    bottom: height/3+90,
                                    child: SizedBox(
                                      height: 40,
                                      child: FloatingActionButton(
                                        heroTag: "btn3",
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: const Icon(Icons.zoom_out, size:22,  color: Color(0xFF152968)),
                                        onPressed: () {
                                          setState(() {
                                            this.zoom = this.zoom - 0.5;
                                          });
                                          this._googleMapController.animateCamera(CameraUpdate.newCameraPosition(
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
                                ]
                            )
                          ),
                        ),
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  child: Column(
                    children: [
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
                              margin: EdgeInsets.fromLTRB(space_3, 0, space_3, 0),
                              child: Header(
                                  reset: false,
                                  text: "${widget.TruckNo}",
                                  backButton: true
                              ),
                            ),
                            HelpButtonWidget()
                          ],
                        ),
                      ),
                    ]
                  )
                )
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
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
                left: 0,
                bottom: (showBottomMenu)? 0 : -(height/3)+ 110,
                child: TrackScreenDetails(
                  driverName: widget.driverName,
                  // truckDate: truckDate,
                  driverNum: widget.driverNum,
                  gpsData: newGPSData,
                  dateRange: selectedDate.toString(),
                  TruckNo: widget.TruckNo,
                  gpsTruckRoute: newGPSRouteWithStops,
                  gpsDataHistory: gpsDataHistory,
                  gpsStoppageHistory: gpsStoppageHistory,
                  stops: stoplatlong,
                  totalRunningTime: totalRunningTime,
                  totalStoppedTime: totalStoppedTime,
                  truckId: widget.truckId,
                  deviceId: widget.deviceId,
                  totalDistance: totalDistance,

                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}