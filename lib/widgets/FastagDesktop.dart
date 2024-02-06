import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/screens/tryAgainScreen.dart';
import 'package:liveasy/widgets/trackOngoing/TimelineTile.dart';
import 'package:shimmer/shimmer.dart';

class WebMap extends StatefulWidget {
  final Function(MapType, Color, Color) ToggleMaptype;
  final bool isLoading;
  final void Function() retryCallBack;
  List<dynamic>? location;
  final bool timeOut;
  var markers,
      polyline,
      customInfoWindowController,
      maptype,
      currentCameraPosition,
      zoom,
      zoombutton,
      truckNo,
      col2,
      col1;
  WebMap(
      {required this.ToggleMaptype,
      required this.isLoading,
      this.markers,
      this.polyline,
      this.location,
      this.customInfoWindowController,
      this.maptype,
      required this.currentCameraPosition,
      this.zoom,
      this.zoombutton,
      this.truckNo,
      this.col2,
      this.col1,
      required this.timeOut,
      required this.retryCallBack});

  @override
  _WebMapState createState() => _WebMapState();
}

class _WebMapState extends State<WebMap> {
  late GoogleMapController googleMapController;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: (widget.timeOut) ? false : true,
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
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          "Fastag Tracking",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            fontSize: screenWidth * 0.02,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: (widget.timeOut) ? false : true,
                    child: Expanded(
                      flex: 3,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: screenWidth * 0.02, top: 17),
                        child: TimeLineWidget(
                            vehicle: widget.truckNo, location: widget.location),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: screenWidth * 0.02, top: 17.0),
                      child: Stack(
                        children: [
                          //Google Map
                          widget.isLoading
                              ? Shimmer.fromColors(
                                  baseColor: lightGrey,
                                  highlightColor: greyishWhiteColor,
                                  child: Container(
                                    height: screenHeight,
                                    width: screenWidth,
                                    color: lightGrey,
                                  ))
                              : (widget.timeOut)
                                  ? TryAgain(
                                      retryCallback: widget.retryCallBack,
                                    )
                                  : GoogleMap(
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        setState(() {
                                          googleMapController = controller;
                                          widget.customInfoWindowController
                                              .googleMapController = controller;
                                        });
                                      },
                                      markers: Set.from(widget.markers),
                                      zoomControlsEnabled: false,
                                      polylines: widget.polyline,
                                      mapType: widget.maptype,
                                      onTap: (position) {
                                        widget.customInfoWindowController
                                            .hideInfoWindow!();
                                      },
                                      onCameraMove: (position) {
                                        widget.customInfoWindowController
                                            .onCameraMove!();
                                        widget.currentCameraPosition = position;
                                      },
                                      initialCameraPosition:
                                          widget.currentCameraPosition),

                          CustomInfoWindow(
                            controller: widget.customInfoWindowController,
                            height: 200,
                            width: 200,
                            offset: 35,
                          ),
                          //Map or Satellite View
                          Visibility(
                            visible: (widget.timeOut) ? false : true,
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: widget.col2,
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
                                        widget.ToggleMaptype(
                                            MapType.normal,
                                            Color(0xff878787),
                                            Color(0xffFF5C00));
                                      },
                                      child: const Text(
                                        'Default',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: widget.col1,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(5)),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        widget.ToggleMaptype(
                                            MapType.satellite,
                                            Color(0xffFF5C00),
                                            Color(0xff878787));
                                      },
                                      child: const Text('Satellite',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ))),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: (widget.timeOut) ? false : true,
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
                                        if (widget.zoombutton) {
                                          setState(() {
                                            widget.zoom = 10.0;
                                            widget.zoombutton = false;
                                          });
                                          googleMapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              bearing: 0,
                                              target: widget
                                                  .currentCameraPosition.target,
                                              zoom: widget.zoom,
                                            ),
                                          ));
                                        } else {
                                          setState(() {
                                            widget.zoom = 8.0;
                                            widget.zoombutton = true;
                                          });
                                          googleMapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              bearing: 0,
                                              target: const LatLng(
                                                  20.5937, 78.9629),
                                              zoom: widget.zoom,
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
                                          widget.zoom = widget.zoom + 0.5;
                                        });
                                        googleMapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            bearing: 0,
                                            target: widget
                                                .currentCameraPosition.target,
                                            zoom: widget.zoom,
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
                                          widget.zoom = widget.zoom - 0.5;
                                        });
                                        googleMapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            bearing: 0,
                                            target: widget
                                                .currentCameraPosition.target,
                                            zoom: widget.zoom,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
