import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/screens/playRouteHistoryScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/screens/truckHistoryScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/widgets/trackScreenDetailsWidget.dart';
import 'package:liveasy/widgets/truckInfoWindow.dart';
import 'package:liveasy/widgets/trucknoInfoWidget.dart';
import 'package:logger/logger.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';
class AllMapWidget extends StatefulWidget {
  List gpsDataList;
  List truckDataList;
   AllMapWidget({
    required this.gpsDataList,
    required this.truckDataList, 
   });

  @override
  _AllMapWidgetState createState() => _AllMapWidgetState();
}

class _AllMapWidgetState extends State<AllMapWidget> with WidgetsBindingObserver{
  late GoogleMapController _googleMapController;
  late LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
  late List<Placemark> placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIconTruck;
  late CameraPosition camPosition =  CameraPosition(
      target: lastlatLngMarker,
      zoom: 4.5);
  var logger = Logger();
  bool showdetails = false;
  late Marker markernew;
  List<Marker> customMarkers = [];
  late Timer timer;
  Completer<GoogleMapController> _controller = Completer();
  late List newGPSData;
  late List reversedList;
  late List oldGPSData;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  String googleAPiKey = FlutterConfig.get("mapKey");
  bool popUp=false;
  late Uint8List markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  CustomInfoWindowController _customDetailsInfoWindowController = CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight=600;
  var direction;
  var maptype = MapType.normal;
  double zoom = 4.5;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    iconthenmarker();
    initfunction2();
    try {

      timer = Timer.periodic(Duration(minutes: 1, seconds: 10), (Timer t) => onActivityExecuted());
    } catch (e) {
      logger.e("Error is $e");
    }
  }
  Future<void> initfunction2() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _googleMapController = controller;
    });
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
  

  //function called every one minute
  void onActivityExecuted() {
    logger.i("It is in Activity Executed function");
    
    iconthenmarker();
  }
    void iconthenmarker() {
    logger.i("in Icon maker function");
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/truckPin.png')
        .then((value) => {
      setState(() {
        pinLocationIconTruck = value;
      }),
      print("hello ${widget.gpsDataList.length}"),
      for(int i =0;i<widget.gpsDataList.length;i++)
    {
      if(widget.gpsDataList[i] != null)
      createmarker(widget.gpsDataList[i],widget.truckDataList[i]),
    }
      
    });
  }
   void createmarker(List gpsData,TruckModel truckData) async {
    try {
      final GoogleMapController controller = await _controller.future;
      
      LatLng latLngMarker =
      LatLng(gpsData.last.latitude, gpsData.last.longitude);
      print("Live location is  ${gpsData.last.latitude}");
      print("hh");
      print(gpsData.last.deviceId.toString());
      String title = truckData.truckNo!;
      markerIcon = await getBytesFromCanvas3(truckData.truckNo!, 100, 100);
      var address =  await getAddress(gpsData);
      setState(() {
        direction = 180 + gpsData.last.course;
        lastlatLngMarker = LatLng(gpsData.last.latitude, gpsData.last.longitude);
        latlng.add(lastlatLngMarker);
         _customDetailsInfoWindowController.hideInfoWindow!();
         _customInfoWindowController.addInfoWindow!(
                            trucknoInfoWindow(truckData.truckNo),
                            lastlatLngMarker,
                          );
          showdetails = false;
        customMarkers.add(Marker(
            markerId: MarkerId(gpsData.last.deviceId.toString()),
            position: latLngMarker,
            onTap: ()
            {
              if(!showdetails)
                {
                  _customInfoWindowController.hideInfoWindow!();
                  _customDetailsInfoWindowController.addInfoWindow!(
                            truckInfoWindow(truckData.truckNo,address),
                            lastlatLngMarker,
                          );
                  showdetails = true;
                }
                else{
                  _customDetailsInfoWindowController.hideInfoWindow!();
                  _customInfoWindowController.addInfoWindow!(
                            trucknoInfoWindow(truckData.truckNo),
                            lastlatLngMarker,
                          );
                  showdetails = false;
                }
            },
            infoWindow: InfoWindow(
           //   title: title,
              onTap: (){
                
              }),
            icon: pinLocationIconTruck,
        rotation: direction));
     /*   print("here i am");
        customMarkers.add(Marker(
            markerId: MarkerId("Details of ${gpsData.last.deviceId.toString()}"),
            position: latLngMarker,
            icon: BitmapDescriptor.fromBytes(markerIcon),
        rotation: 0.0));*/

        
      });
      print("done");
   //   controller.showMarkerInfoWindow(MarkerId(gpsData.last.deviceId.toString()));
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(28.5673, 77.3211),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double threshold = 100;
    
    return Container(
       width: MediaQuery.of(context).size.width,
      child: Scaffold(
      body: Stack(
                              children: <Widget>[
                                GoogleMap(
                         /*   onTap: (position) {
                              _customInfoWindowController.hideInfoWindow!();
                              _customDetailsInfoWindowController.hideInfoWindow!();
                            },*/
                            onCameraMove: (position) {
                              _customInfoWindowController.onCameraMove!();
                              _customDetailsInfoWindowController.onCameraMove!();
                            },
                            markers: customMarkers.toSet(),
                  
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: camPosition,
                            compassEnabled: true,
                            mapType: maptype,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              _customInfoWindowController.googleMapController = controller;
                              _customDetailsInfoWindowController.googleMapController = controller;
                            },
                            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                    new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                  ].toSet(),
                          ),
                              CustomInfoWindow(
                                controller: _customInfoWindowController,
                                height: 110,
                                width: 275,
                                offset: 0,
                              ),
                              CustomInfoWindow(
                                controller: _customDetailsInfoWindowController,
                                height: 140,
                                width: 300,
                                offset: 0,
                              ),
                         /*       Positioned(
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
                                ),*/
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
                          ),
      ),
           
     
     );
  }
  getAddress(var gpsData) async{
    var address = await getStoppageAddressLatLong(gpsData.last.latitude, gpsData.last.longitude);
    
  
    return address;
  }
  
}