import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';
import '../functions/ulipAPIs/fastagAPIs.dart';
import '../models/fastagModel.dart';
import '../widgets/buttons/helpButton.dart';
import '../widgets/fastagTimeline.dart';

// ignore: must_be_immutable
class FastagScreen extends StatefulWidget {
  final String? bookingDate;
  String? truckNo;
  String? loadingPoint;
  String? unloadingPoint;
  FastagScreen(
      {required this.truckNo,
      this.bookingDate,
      required this.loadingPoint,
      required this.unloadingPoint});

  @override
  _FastagScreenState createState() => _FastagScreenState();
}

class _FastagScreenState extends State<FastagScreen> {
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<TollPlazaData> tollPlazaDataList = [];
  List<String> addresses = []; // Create an empty list to store addresses
  bool isLoading = true;

  MapType mapType = MapType.normal;
  var col1 = Color(0xff878787);
  var col2 = Color(0xffFF5C00);
  Marker? loadingPointMarker;
  Marker? unloadingPointMarker;

  late GoogleMapController? _googleMapController;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Uint8List customIconBytes = Uint8List(0);
  String? bookingTime = "8:47 AM";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true when starting the API call
      });

      // Calling API here and store the result in variables
      final List<TollPlazaData> tollPlazaData =
          await fetchTollPlazaData(widget.truckNo!);

      // Fetch addresses for markers and pass the fetched data
      await _loadMarkers(tollPlazaData);
      setState(() {
        tollPlazaDataList = tollPlazaData;
        isLoading =
            false; // Set isLoading to false after receiving the response
      });
    } catch (error) {
      print('API Error: $error');
      setState(() {
        isLoading = false; // Set isLoading to false if there's an error
      });
    }
  }

  // For loading the markers form the assets
  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData? data = await rootBundle.load(path);

    if (data != null) {
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    }

    return null;
  }

  // to get the address of the toll plaza from  lat long
  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String street = placemark.street ?? '';
        String city = placemark.locality ?? '';
        String state = placemark.administrativeArea ?? '';
        String highway = placemark.name ?? '';

        String address = '';

        if (street.isNotEmpty && highway.isNotEmpty && street == highway) {
          // If street and highway are the same, display only one of them
          address = '$street, $city, $state';
        } else {
          // Display both street and highway
          address = '$street, $city, $state\n$highway';
        }

        return address;
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // for loading the markers and its various properties
  Future<void> _loadMarkers(List<TollPlazaData> tollPlazaDataList) async {
    LatLng loadingPointLatLng = await _geocodeLocation(widget.loadingPoint!);
    LatLng? lastTollPlazaLatLng; // Initialize it as nullable

    // Marker icons for loading and unloading points
    final Uint8List? loadingPointIcon =
        await getBytesFromAsset('assets/icons/loadingPoint.png', 100);
    final Uint8List? unloadingPointIcon =
        await getBytesFromAsset('assets/icons/unloadingPoint.png', 100);

    // Create a marker for the loading point
    final Marker loadingPointMarker = Marker(
      markerId: MarkerId('loadingPoint'),
      position: loadingPointLatLng,
      icon: BitmapDescriptor.fromBytes(loadingPointIcon!),
      onTap: () {
        _showInfoWindowloading(
            'Loading Point', widget.loadingPoint!, loadingPointLatLng);
      },
    );

    markers.add(loadingPointMarker);

    for (var i = 0; i < tollPlazaDataList.length; i++) {
      final tollPlazaData = tollPlazaDataList[i];
      final List<String> geocode = tollPlazaData.tollPlazaGeocode.split(',');
      final double latitude = double.parse(geocode[0]);
      final double longitude = double.parse(geocode[1]);
      final String name = tollPlazaData.tollPlazaName;
      final String timestamp = tollPlazaData.readerReadTime;
      final formattedDate =
          DateFormat('dd MMM yyyy').format(DateTime.parse(timestamp));
      final formattedTime =
          DateFormat('HH:mm').format(DateTime.parse(timestamp));
      final Uint8List? markerIcon =
          await getBytesFromAsset('assets/icons/fastagIcon.png', 100);

      // Get the address for this marker
      String address = await getAddressFromLatLng(LatLng(latitude, longitude));
      addresses.add(address); // Add the address to the list
      // info window for each marker
      final Widget infoContent = Container(
        color: Colors.black.withOpacity(0.8),
        height: 100,
        width: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$name',
                style: TextStyle(
                  color: white,
                  fontSize: size_7,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '$address',
                style: TextStyle(
                  color: white,
                  fontSize: size_6,
                ),
              ),
              SizedBox(
                height: size_1,
              ),
              Text(
                '$formattedDate',
                style: TextStyle(
                  color: white,
                  fontSize: size_6,
                ),
              ),
              Text(
                '$formattedTime',
                style: TextStyle(
                  color: white,
                  fontSize: size_6,
                ),
              ),
            ],
          ),
        ),
      );

      final LatLng tollPlazaLatLng = LatLng(latitude, longitude);

      // Connect the current toll plaza to the previous one with a polyline
      if (lastTollPlazaLatLng != null) {
        final List<LatLng> points = [lastTollPlazaLatLng, tollPlazaLatLng];
        final Polyline polyline = Polyline(
          polylineId: PolylineId('route$i'), // Unique ID for each polyline
          points: points,
          color: darkBlueColor, // Color of the polyline
          width: 3, // Width of the polyline
        );

        setState(() {
          polylines.add(polyline);
        });
      }

      // Create a marker for the current toll plaza
      final Marker marker = Marker(
        markerId: MarkerId(name),
        position: tollPlazaLatLng,
        icon: BitmapDescriptor.fromBytes(markerIcon!),
        onTap: () {
          // Show the custom info window with the info content for this marker
          _customInfoWindowController.addInfoWindow!(
              infoContent, tollPlazaLatLng);
        },
      );
      markers.add(marker);

      // Update lastTollPlazaLatLng for the next iteration
      lastTollPlazaLatLng = tollPlazaLatLng;
    }

    // Create a marker for the unloading point
    final LatLng unloadingPointLatLng =
        await _geocodeLocation(widget.unloadingPoint!);
    final Marker unloadingPointMarker = Marker(
      markerId: MarkerId('unloadingPoint'),
      position: unloadingPointLatLng,
      icon: BitmapDescriptor.fromBytes(unloadingPointIcon!),
      onTap: () {
        _showInfoWindowunloading(
            'Unloading Point', widget.unloadingPoint!, unloadingPointLatLng);
      },
    );

    markers.add(unloadingPointMarker);

    // Connect the last toll plaza to the unloading point with a polyline
    if (lastTollPlazaLatLng != null) {
      final List<LatLng> points = [lastTollPlazaLatLng, loadingPointLatLng];
      final Polyline polyline = Polyline(
        polylineId: PolylineId(
            'route-last-unloading'), // Unique ID for the last polyline
        points: points,
        color: darkBlueColor, // Color of the polyline
        width: 3, // Width of the polyline
      );

      setState(() {
        polylines.add(polyline);
      });
    }
  }

  Future<LatLng> _geocodeLocation(String locationName) async {
    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
    } catch (e) {
      print('Error geocoding location: $e');
    }
    // Return a default location (e.g., center of the map) if geocoding fails
    return LatLng(28.6139, 77.2090);
  }

  // infoWindow for loading point
  void _showInfoWindowloading(String title, String description, LatLng latLng) {
    final Widget infoContent = Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(size_5),
      ),
      height: space_5,
      width: space_10,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkBlueColor,
                fontSize: size_7,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: liveasyGreen,
                fontSize: size_7,
              ),
            ),
          ],
        ),
      ),
    );
    _customInfoWindowController.addInfoWindow!(infoContent, latLng);
  }

  // infoWindow for unloadingPoint
  void _showInfoWindowunloading(
      String title, String description, LatLng latLng) {
    final Widget infoContent = Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(size_5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkBlueColor,
                fontSize: size_7,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: red,
                fontSize: size_7,
              ),
            ),
          ],
        ),
      ),
    );
    _customInfoWindowController.addInfoWindow!(infoContent, latLng);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.truckNo}",
          style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.bold),
        ),
        titleSpacing: space_0,
        leading: Container(
          margin: EdgeInsets.all(space_2),
          child: CupertinoNavigationBarBackButton(
            color: darkBlueColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(space_2),
            child: HelpButtonWidget(),
          )
        ],
      ),
      body: Stack(
        children: [
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: darkBlueColor,
              ),
            )
          else if (tollPlazaDataList.isEmpty)
            Center(
              child: Text("No data available"), // Show a placeholder message
            )
          else
            GoogleMap(
              mapType: mapType,
              onTap: (postion) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (postion) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                _customInfoWindowController.googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(
                      tollPlazaDataList[0].tollPlazaGeocode.split(',')[0]),
                  double.parse(
                      tollPlazaDataList[0].tollPlazaGeocode.split(',')[1]),
                ),
                zoom: space_2,
              ),
              markers: {
                ...Set<Marker>.from(markers), // Your toll plaza markers
                if (loadingPointMarker != null) loadingPointMarker!,
                if (unloadingPointMarker != null) unloadingPointMarker!,
              },
              polylines: Set<Polyline>.from(polylines),
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          //custom infoWindow for each markers
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: space_26,
            width: space_50,
            offset: space_7,
          ),
          // two buttons at the top left corner to switch between satellite view and normal view
          Positioned(
            left: space_2,
            top: space_2,
            child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: grey,
                      width: 0.25,
                    ),
                  ),
                  //  height: 40,
                  child: Row(
                    children: [
                      Container(
                        height: space_8,
                        decoration: BoxDecoration(
                            color: col2,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(space_1)),
                            boxShadow: [
                              BoxShadow(
                                color: darkShadow,
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
                                this.mapType = MapType.normal;
                                col1 = darkGreyColor;
                                col2 = Color(0xffFF5C00);
                              });
                            },
                            child: Text(
                              'Map',
                              style: TextStyle(
                                color: white,
                              ),
                            )),
                      ),
                      Container(
                        height: space_8,
                        decoration: BoxDecoration(
                          color: col1,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(5)),
                          //  border: Border.all(color: Colors.black),
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                this.mapType = MapType.satellite;
                                col2 = darkGreyColor;
                                col1 = Color(0xffFF5C00);
                              });
                            },
                            child: Text('Satellite',
                                style: TextStyle(
                                  color: black,
                                ))),
                      )
                    ],
                  )),
            ),
          ),
          Positioned(
            right: space_2,
            top: space_45,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: white,
              onPressed: () {
                _googleMapController!.animateCamera(
                  CameraUpdate.zoomIn(),
                );
              },
              child: Icon(
                Icons.zoom_in,
                color: darkBlueColor,
              ),
            ),
          ),
          Positioned(
            right: space_2,
            top: space_55,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: white,
              onPressed: () {
                _googleMapController!.animateCamera(
                  CameraUpdate.zoomOut(),
                );
              },
              child: Icon(Icons.zoom_out, color: darkBlueColor),
            ),
          ),
          // to display the bottom sheet
          SlidingUpPanel(
              color: Colors.transparent,
              maxHeight: height * 0.75,
              minHeight: height * 0.10,
              parallaxEnabled: true,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size_9),
                  topRight: Radius.circular(size_9)),
              panel: Container(
                child: Column(children: [
                  Opacity(
                    opacity: 0.75,
                    child: Container(
                      padding: EdgeInsets.all(space_1),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: darkBlueColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1, right: 7),
                              child: Image(
                                  height: 17,
                                  width: 17,
                                  image: AssetImage(
                                      "assets/icons/location_marker.png")),
                            ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.loadingPoint}',
                                  style: TextStyle(
                                      color: white,
                                      fontSize: size_7,
                                      fontWeight: boldWeight),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "${widget.bookingDate}",
                                    style: TextStyle(
                                        color: white, fontSize: size_6),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    bookingTime!,
                                    style: TextStyle(
                                        color: white, fontSize: size_6),
                                  ),
                                )
                              ],
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: space_2),
                              child: Image(
                                  image: AssetImage("assets/icons/Arrow.png")),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 1, right: 7),
                              child: Image(
                                  height: 17,
                                  width: 17,
                                  image: AssetImage(
                                      "assets/icons/unloading_location_marker.png")),
                            ),
                            Text(
                              '${widget.unloadingPoint}',
                              // "Varanasi,Uttarpradesh",
                              style: TextStyle(
                                  color: white,
                                  fontSize: size_7,
                                  fontWeight: boldWeight),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          space_2, space_4, space_2, space_0),
                      child: Container(
                        width: width,
                        height: height * 0.59,
                        color: greyishshade,
                        child: TimelineTileFastag(
                          responses: tollPlazaDataList,
                          addresses: addresses,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: space_9,
                    color: white,
                    width: width,
                  )
                ]),
              ))
        ],
      ),
    );
  }
}
