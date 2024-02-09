import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/widgets/MobileMap.dart';
import 'package:liveasy/widgets/fastagWebWidget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';
import '../functions/ulipAPIs/fastagAPIs.dart';
import '../models/fastagModel.dart';
import '../widgets/buttons/helpButton.dart';
import '../widgets/fastagTimeline.dart';

//This screen will display fastag Details
class MapScreen extends StatefulWidget {
  String? loadingPoint;
  String? unloadingPoint;
  String? truckNumber;

  MapScreen({
    Key? key,
    this.loadingPoint,
    this.unloadingPoint,
    this.truckNumber,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late bool isMobile;
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  List<Marker> _markers = [];
  late CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(21.2499640, 85.1930650), // Initial camera position
    zoom: 12.0, // Initial zoom level
  );
  double zoom = 8;
  bool zoombutton = false;

  double averagelat = 0;
  double averagelon = 0;
  var maptype = MapType.normal;
  var col1 = const Color(0xff878787);
  var col2 = const Color(0xffFF5C00);
  final List<String> paths = [
    'assets/icons/fastagIcon.png',
    'assets/icons/fastagIcon.png',
    'assets/icons/fastagIcon.png',
  ];
  List<BitmapDescriptor> customMarkerIcons = [];
  List<dynamic>? locations;

  final Set<Polyline> _polyline = {};
  bool isLoading = true;
  bool timeout = false;

  @override
  void initState() {
    super.initState();
    loadVehicleLocations(widget.truckNumber!);
  }

//for generating the location of the vehicle
  Future<void> loadVehicleLocations(String vehicle) async {
    // bool isMobile = Responsive.isMobile(context);
    locations = await checkFastTag().getVehicleLocation(vehicle);
    setState(() {
      isLoading = true;
    });

    List<LatLng> polylinePoints = [];

    String geoCode;

    //Getting the loadingPointCoordinates
    LatLng? loadingPointCoordinates =
        await getCoordinatesForWeb(widget.loadingPoint!);

    // Add the loading point to the polyline points
    if (loadingPointCoordinates != null) {
      polylinePoints.add(loadingPointCoordinates);
      final Uint8List loadingPointMarker =
          await getBytesFromAssets('assets/icons/loadingPoint.png', 55);

      _markers.add(Marker(
        markerId: const MarkerId('loading_point'),
        position: loadingPointCoordinates,
        icon: BitmapDescriptor.fromBytes(loadingPointMarker),
        onTap: () {
          customInfoWindowController.addInfoWindow!(
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 200,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.loadingPoint ?? '',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: diffDeleteButtonColor)),
                ],
              ),
            ),
            loadingPointCoordinates,
          );
        },
      ));
    } else {
      debugPrint("loading point is  null");
    }

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

        final Uint8List marker = await getBytesFromAssets(paths[i], 35);

        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.fromBytes(marker),
            onTap: () {
              customInfoWindowController.addInfoWindow!(
                Container(
                    height: 400,
                    width: 400,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0,
                                0.7), // Set the background color with transparency
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(location['tollPlazaName'],
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: white)),
                              Text(formattedDate,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: white)),
                              Text(formattedTime,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: white)),
                            ],
                          ),
                        ),
                      ],
                    )),
                LatLng(latitude, longitude),
              );
            }));
        polylinePoints.add(LatLng(latitude, longitude));
      }
      _polyline.add(
        Polyline(
          polylineId: PolylineId(i.toString()),
          points: polylinePoints,
          color: darkBlueTextColor,
          width: 3,
        ),
      );
    }

    LatLng? unloadingPointCoordinates =
        await getCoordinatesForWeb(widget.unloadingPoint!);
    if (unloadingPointCoordinates != null) {
      final Uint8List unloadingPointMarker =
          await getBytesFromAssets('assets/icons/unloadingPoint.png', 55);

      _markers.add(Marker(
        markerId: const MarkerId('unloading_point'),
        position: unloadingPointCoordinates,
        icon: BitmapDescriptor.fromBytes(unloadingPointMarker),
        onTap: () {
          // Handle tap on unloading point marker
          customInfoWindowController.addInfoWindow!(
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 200,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.unloadingPoint ?? '',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, color: okButtonColor)),
                ],
              ),
            ),
            unloadingPointCoordinates,
          );
        },
      ));
    } else {
      debugPrint("no unloading point");
    }
    setState(() {
      isLoading = false;
      if (!isLoading && locations!.isEmpty) {
        timeout = true;
      }
    });
  }

//After clicking on the TryAgain button, check whether the data is available now or not.
  void _retryFetchingData() {
    setState(() {
      isLoading = true;
      timeout = false;
    });
    // Retry fetching data
    loadVehicleLocations(widget.truckNumber.toString());
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

  ToggleMaptype(selectedMapType, selectedCol1, selectedCol2) {
    setState(() {
      maptype = selectedMapType;
      col1 = selectedCol1;
      col2 = selectedCol2;
    });
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

  @override
  Widget build(BuildContext context) {
    //on mobile user will de directed to the MobileMap screen
    isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return MobileMap(
        retryCallBack: _retryFetchingData,
        timeOut: timeout,
        isLoading: isLoading,
        location: locations,
        ToggleMaptype: ToggleMaptype,
        col1: col1,
        col2: col2,
        loadingPoint: widget.loadingPoint,
        unloadingPoint: widget.unloadingPoint,
        currentCameraPosition: currentCameraPosition,
        customInfoWindowController: customInfoWindowController,
        maptype: maptype,
        markers: _markers,
        polyline: _polyline,
        zoom: zoom,
        truckNumber: widget.truckNumber,
        zoombutton: zoombutton,
      );
    }
    //on web user will de directed to the WebMap screen
    else {
      return WebMap(
        retryCallBack: _retryFetchingData,
        timeOut: timeout,
        location: locations,
        ToggleMaptype: ToggleMaptype,
        isLoading: isLoading,
        col1: col1,
        col2: col2,
        currentCameraPosition: currentCameraPosition,
        customInfoWindowController: customInfoWindowController,
        maptype: maptype,
        markers: _markers,
        truckNo: widget.truckNumber,
        polyline: _polyline,
        zoom: zoom,
        zoombutton: zoombutton,
      );
    }
  }
}
