import 'dart:convert';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/functions/bookingApiCalls.dart';
import 'package:liveasy/functions/ongoingTrackUtils/FastTag.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/screens/tryAgainScreen.dart';
import 'package:liveasy/widgets/custom_Info_Window.dart';
import 'package:shimmer/shimmer.dart';

class TrackAllFastagScreen extends StatefulWidget {
  final List<Map<String, dynamic>> EwayData;
  const TrackAllFastagScreen({super.key, required this.EwayData});

  @override
  State<TrackAllFastagScreen> createState() => _TrackAllFastagScreenState();
}

class _TrackAllFastagScreenState extends State<TrackAllFastagScreen> {
  GlobalKey _mapKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final double customInfoWindowWidth = 200; // Adjust as needed
  final double customInfoWindowHeight = 100; // Adjust as needed
  final double markerOffset = 50;
  bool isDetailsVisible = false;
  Map<BookingModel, Map<String, String>> bookingDetails = {};
  bool isLoading = true;
  bool timeout = false;
  BookingApiCalls bookingApi = BookingApiCalls();
  BookingModel? selectedBooking;
  String? estimatedTime;
  String? shortAddress;
  List<List<LatLng>> routes = [];
  List<dynamic>? locations;
  List<dynamic>? stoppages;
  List<dynamic>? position;
  late Uint8List markerIcon;
  List<dynamic>? trips;
  //var trips;
  DateTime yesterday =
      DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));
  late GoogleMapController googleMapController;
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  late CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(20.5937, 78.9629), // Initial camera position
    zoom: 6.0, // Initial zoom level
  );
  var maptype = MapType.normal;
  var col1 = const Color(0xff878787);
  var col2 = const Color(0xffFF5C00);
  double zoom = 8;
  bool zoombutton = false;
  List<Marker> _markers = [];
  final Set<Polyline> _polyline = {};
  final List<String> paths = [
    'assets/images/TollImage.png',
    'assets/images/TollImage.png',
    'assets/images/TollImage.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  void setSelectedBooking(BookingModel booking) {
    setState(() {
      selectedBooking = booking;
      shortAddress = bookingDetails[booking]?['shortAddress'];
      estimatedTime = bookingDetails[booking]?['estimatedTime'];
    });
  }

//Show Custom Info Window
  void _showCustomInfoWindow(MarkerId markerId, LatLng position, var duration,
      var stoppageTime, var stopAddress) async {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }

    RenderBox renderBox =
        _mapKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    //Convert Latlng to Screen Coordinates
    ScreenCoordinate screenCoordinate =
        await googleMapController.getScreenCoordinate(position);

    //Calculate the position of the customInfoWindow
    var left = offset.dx + screenCoordinate.x - (customInfoWindowWidth / 2);
    var top =
        offset.dy + screenCoordinate.y - customInfoWindowHeight - markerOffset;

    _overlayEntry = OverlayEntry(
        builder: ((context) => Positioned(
            left: left,
            top: top,
            child: customInfoWindow(
                duration: duration,
                stoppageTime: stoppageTime,
                stopAddress: stopAddress))));
    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> fetchBookingData() async {
    String geoCode;
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    int k = 0, j = 0;

    try {
      setState(() {
        isLoading = true;
      });

      for (var i = 0; i < widget.EwayData.length; i++) {
        final Map<String, dynamic> currentEwayBill = widget.EwayData[i];
        final String fromPlace = currentEwayBill['fromPlace'];
        final String toPlace = currentEwayBill['toPlace'];
        final String vehicleNo =
            currentEwayBill['vehicleListDetails'][0]['vehicleNo'];

        List<LatLng> eachBookingCompleteCoordinates = [];
        LatLng? loadingPointCoordinates = await getCoordinatesForWeb(fromPlace);

        //Add the marker for the loadingPoint
        if (loadingPointCoordinates != null) {
          eachBookingCompleteCoordinates.add(loadingPointCoordinates);
          final Uint8List loadingPointMarker =
              await getBytesFromAssets('assets/icons/EndingPoint.png', 35);
          _markers.add(Marker(
            markerId: MarkerId('loading${k + 1}'),
            position: loadingPointCoordinates,
            icon: BitmapDescriptor.fromBytes(loadingPointMarker),
          ));
          k++;
        }

        //Get the Fastag Data
        locations = await checkFastTag().getVehicleLocation(vehicleNo).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return [];
          },
        );
        print("5");
        //Fastag marker is added here
        if (locations != null) {
          for (int i = 0; i < locations!.length; i++) {
            final location = locations![i];
            String combinedDateTime = location['readerReadTime'];
            DateTime dateTime = DateTime.parse(combinedDateTime);
            String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
            String formattedTime = DateFormat('hh:mm a').format(dateTime);
            geoCode = location['tollPlazaGeocode'];
            final List<String> geoCodeParts = geoCode.split(',');

            if (geoCodeParts.length == 2) {
              final double latitude = double.tryParse(geoCodeParts[0]) ?? 0.0;
              final double longitude = double.tryParse(geoCodeParts[1]) ?? 0.0;

              final Uint8List marker = await getBytesFromAssets(paths[i], 25);

              _markers.add(Marker(
                  markerId: MarkerId(i.toString()),
                  position: LatLng(latitude, longitude),
                  icon: BitmapDescriptor.fromBytes(marker),
                  onTap: () {
                    _showCustomInfoWindow(
                        MarkerId(i.toString()),
                        LatLng(latitude, longitude),
                        formattedTime,
                        formattedDate,
                        location['tollPlazaName']);
                  }));
              eachBookingCompleteCoordinates.add(LatLng(latitude, longitude));
            }
          }
        }

        //Unloading Point marker is added
        LatLng? unloadingPointCoordinates = await getCoordinatesForWeb(toPlace);
        if (unloadingPointCoordinates != null) {
          eachBookingCompleteCoordinates.add(unloadingPointCoordinates);
          final Uint8List unloadingPointMarker =
              await getBytesFromAssets('assets/icons/StartingPoint.png', 35);
          _markers.add(Marker(
            markerId: MarkerId('Unloading ${j + 1}'),
            position: unloadingPointCoordinates,
            icon: BitmapDescriptor.fromBytes(unloadingPointMarker),
          ));
          j++;
        }

        if (routes.isEmpty && _markers.isEmpty) {
          isLoading = false;
          timeout = true;
        } else {
          setState(
            () {
              routes.add(eachBookingCompleteCoordinates);
              for (List<LatLng> routeCoordinates in routes) {
                int index = routes.indexOf(routeCoordinates);
                _polyline.add(Polyline(
                  polylineId: PolylineId('Route ${index + 1}'),
                  points: routeCoordinates,
                  color: Colors.blue,
                  width: 3,
                ));
              }
              isLoading = false;
            },
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> addStoppageMarker(var stoppage, int index) async {
    LatLng stoplatlong = LatLng(stoppage.latitude, stoppage.longitude);
    String stopAddress = await getStoppageAddress(stoppage);
    String stoppageTime = getStoppageTime(stoppage);
    String duration = getStoppageDuration(stoppage);
    BitmapDescriptor icon = await createNumberedMarkerIcon(index);

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("Stop Mark $index"),
        position: stoplatlong,
        icon: icon,
        onTap: () {
          _showCustomInfoWindow(MarkerId("Stop Mark $index"), stoplatlong,
              duration, stoppageTime, stopAddress);
        },
      ));
    });
  }

  //Add the custom marker for stoppages
  Future<BitmapDescriptor> createNumberedMarkerIcon(int number) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    //Cascading operator is used to reduce the code
    final Paint paint1 = Paint()..color = Colors.deepOrange;

    canvas.drawCircle(const Offset(20, 20), 17, paint1);
    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);

    painter.text = TextSpan(
      text: number.toString(),
      style: const TextStyle(
        fontSize: 22.0,
        color: Colors.white,
      ),
    );
    painter.layout();

    Offset center = const Offset(20, 20);
    double xCenter = center.dx - (painter.width) / 2;
    double yCenter = center.dy - (painter.height) / 2;
    Offset textPainter = Offset(xCenter, yCenter);

    painter.paint(canvas, textPainter);

    final image = await pictureRecorder.endRecording().toImage(40, 40);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<LatLng?> getCoordinatesForWeb(String placename) async {
    try {
      final encodedAddress = Uri.encodeComponent(placename);
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=${dotenv.get('mapKey')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final lat = location['lat']; // Corrected
          final lng = location['lng'];
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      debugPrint("Web function isn't working");
    }
    return null;
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo info = await codec.getNextFrame();
    return (await info.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//To set the visibility of the side panel
  void toggleDetailsVisibility() {
    setState(() {
      isDetailsVisible = false;
    });
  }

  void _onMarkerTapped() {
    setState(() {
      isDetailsVisible = true; // Show the details panel when a marker is tapped
    });
  }

  ToggleMaptype(selectedMapType, selectedCol1, selectedCol2) {
    setState(() {
      maptype = selectedMapType;
      col1 = selectedCol1;
      col2 = selectedCol2;
    });
  }

  // After clicking on the TryAgain button, check whether the data is available now or not.
  void retryFetchingData() {
    setState(() {
      isLoading = true;
      timeout = false;
    });
    // Retry fetching data
    fetchBookingData();
  }

  void _hideCustomInfoWindow() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Visibility(
          visible: timeout ? false : true,
          child: Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: darkBlueColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: Text(
                      "Track All Shipments",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        fontSize: screenWidth * 0.015,
                        color: darkBlueTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            flex: 9,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              if (isDetailsVisible)
                Expanded(
                    flex: 25,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: screenWidth * 0.02, top: 17),
                      child: isLoading
                          ? Shimmer.fromColors(
                              baseColor: lightGrey,
                              highlightColor: greyishWhiteColor,
                              child: Container(
                                height: screenHeight,
                                width: screenWidth,
                                color: lightGrey,
                              ))
                          : timeout
                              ? TryAgain(
                                  retryCallback: retryFetchingData,
                                )
                              : selectedBooking != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                          Container(
                                              height: screenHeight * 0.2,
                                              width: screenWidth * 0.18,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                  color: formBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  truckDetailsRow(
                                                      "Truck No.",
                                                      selectedBooking
                                                          ?.truckId![0]),
                                                  truckDetailsRow(
                                                      "Driver : ",
                                                      selectedBooking
                                                          ?.driverName),
                                                  truckDetailsRow(
                                                      "Driver No.",
                                                      selectedBooking
                                                          ?.driverPhoneNum),
                                                ],
                                              )),
                                          SizedBox(
                                              height: screenHeight * 0.022),
                                          //8888888888888888888888888888888888888888888888888888888888888888888888888888888888888
                                          routeRow(
                                              'assets/icons/endingPoint.png',
                                              'Loading Point'),
                                          Text(
                                              selectedBooking!
                                                  .loadingPointCity!,
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize:
                                                      screenHeight * 0.02)),
                                          SizedBox(height: screenHeight * 0.01),
                                          Image(
                                              image: const AssetImage(
                                                  'assets/images/dottedLine.png'),
                                              height: screenHeight * 0.2),
                                          SizedBox(height: screenHeight * 0.01),
                                          routeRow(
                                              'assets/icons/StartingPoint2.png',
                                              'Unloading Point'),
                                          Text(
                                              selectedBooking!
                                                  .unloadingPointCity!,
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize:
                                                      screenHeight * 0.02)),
                                          SizedBox(
                                              height: screenHeight * 0.022),
                                          Text('Current Location',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize:
                                                      screenHeight * 0.02)),
                                          SizedBox(height: screenHeight * 0.01),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Image(
                                                    image: AssetImage(
                                                        'assets/icons/location.png')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14.0),
                                                  child: Text(shortAddress!,
                                                      style: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              darkBlueTextColor,
                                                          fontSize:
                                                              screenHeight *
                                                                  0.02)),
                                                )
                                              ]),
                                          SizedBox(
                                              height: screenHeight * 0.022),
                                          routeRow('assets/icons/time.png',
                                              'Estimated Time'),
                                          SizedBox(
                                              height: screenHeight * 0.022),
                                          Text(estimatedTime!,
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: darkBlueTextColor,
                                                  fontSize:
                                                      screenHeight * 0.02)),
                                        ])
                                  : const Text(
                                      'Select a shipment to see details'),
                    )),
              Expanded(
                  flex: isDetailsVisible ? 75 : 10,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: screenWidth * 0.02, top: 17.0),
                    child: Stack(children: [
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: lightGrey,
                              highlightColor: greyishWhiteColor,
                              child: Container(
                                height: screenHeight,
                                width: screenWidth,
                                color: lightGrey,
                              ))
                          : timeout
                              ? TryAgain(
                                  retryCallback: retryFetchingData,
                                )
                              : GoogleMap(
                                  key: _mapKey,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    setState(() {
                                      googleMapController = controller;
                                      customInfoWindowController
                                          .googleMapController = controller;
                                    });
                                  },
                                  initialCameraPosition: currentCameraPosition,
                                  markers: Set.from(_markers),
                                  zoomControlsEnabled: false,
                                  polylines: _polyline,
                                  myLocationButtonEnabled: true,
                                  compassEnabled: true,
                                  mapType: maptype,
                                  onTap: (position) {
                                    _hideCustomInfoWindow();
                                  },
                                  onCameraMove: ((position) {
                                    customInfoWindowController.onCameraMove!();
                                    currentCameraPosition = position;
                                    _hideCustomInfoWindow();
                                  }),
                                ),
                      CustomInfoWindow(
                        controller: customInfoWindowController,
                        height: 200,
                        width: 200,
                        offset: 35,
                      ),

                      //Map or Satellite View
                      Visibility(
                        visible: !isLoading && !timeout ? true : false,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: screenHeight * 0.1,
                              top: screenHeight * 0.012),
                          child: Row(children: [
                            Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: col2,
                                    borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0.0,
                                      )
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
                                      'Default',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ))),
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
                                        col1 = const Color(0xffFF5C00);
                                        col2 = const Color(0xff878787);
                                      });
                                    },
                                    child: const Text('Satellite',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ))))
                          ]),
                        ),
                      ),
                      Visibility(
                        visible: !isLoading && !timeout ? true : false,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // stack button
                              SizedBox(
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
                                        zoom = 10.0;
                                        zoombutton = false;
                                      });
                                      googleMapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          bearing: 0,
                                          target: currentCameraPosition.target,
                                          zoom: zoom,
                                        ),
                                      ));
                                    } else {
                                      setState(() {
                                        zoom = 8.0;
                                        zoombutton = true;
                                      });
                                      googleMapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          bearing: 0,
                                          target:
                                              const LatLng(20.5937, 78.9629),
                                          zoom: zoom,
                                        ),
                                      ));
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              //zoom in button
                              SizedBox(
                                height: 40,
                                child: FloatingActionButton(
                                  heroTag: "btn2",
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  child: const Icon(Icons.zoom_in,
                                      size: 22, color: Color(0xFF152968)),
                                  onPressed: () {
                                    setState(() {
                                      zoom = zoom + 0.5;
                                    });
                                    googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        bearing: 0,
                                        target: currentCameraPosition.target,
                                        zoom: zoom,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Zoom out Button
                              SizedBox(
                                height: 40,
                                child: FloatingActionButton(
                                  heroTag: "btn3",
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  child: const Icon(Icons.zoom_out,
                                      size: 22, color: Color(0xFF152968)),
                                  onPressed: () {
                                    setState(() {
                                      zoom = zoom - 0.5;
                                    });
                                    googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        bearing: 0,
                                        target: currentCameraPosition.target,
                                        zoom: zoom,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ))
            ]))
      ]),
    ));
  }

  Widget truckDetailsRow(String key, String? value) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
        flex: 33,
        child: Text(key,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: screenHeight * 0.02)),
      ),
      const Expanded(
        flex: 22,
        child: SizedBox(
          height: 30,
          child: VerticalDivider(color: dividerColor, thickness: 2),
        ),
      ),
      Expanded(
        flex: 45,
        child: Text(value!,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: screenHeight * 0.02)),
      )
    ]);
  }

  Widget routeRow(String imagePath, String name) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image(image: AssetImage(imagePath)),
      Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: Text(name,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: screenHeight * 0.02)),
      )
    ]);
  }
}
