import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/screens/tryAgainScreen.dart';
import 'package:liveasy/widgets/trackOngoing/TimelineTile.dart';
import 'package:shimmer/shimmer.dart';

class MobileMap extends StatefulWidget {
  final Function(MapType, Color, Color) ToggleMaptype;
  final void Function() retryCallBack;
  final bool isLoading;
  final bool timeOut;
  List<dynamic>? location;
  var markers,
      polyline,
      customInfoWindowController,
      maptype,
      currentCameraPosition,
      zoom,
      zoombutton,
      col2,
      col1,
      loadingPoint,
      unloadingPoint,
      truckNumber;
  MobileMap(
      {required this.ToggleMaptype,
      required this.isLoading,
      this.markers,
      this.polyline,
      this.customInfoWindowController,
      this.maptype,
      this.currentCameraPosition,
      this.zoom,
      this.zoombutton,
      this.location,
      this.truckNumber,
      this.col2,
      this.loadingPoint,
      this.unloadingPoint,
      this.col1,
      required this.timeOut,
      required this.retryCallBack});

  @override
  _MobileMapState createState() => _MobileMapState();
}

class _MobileMapState extends State<MobileMap> {
  late GoogleMapController googleMapController;
  double sheetTopMargin = 150.0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: (widget.timeOut)
          ? null
          : AppBar(
              backgroundColor: fastagAppBarColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: darkBlueTextColor,
                ),
              ),
              title: Text(
                widget.truckNumber,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.05,
                  height: 1.25,
                  color: darkBlueTextColor,
                ),
              ),
            ),
      body: SafeArea(
        child: Stack(children: [
          widget.isLoading
              ? Shimmer.fromColors(
                  baseColor: lightGrey,
                  highlightColor: greyishWhiteColor,
                  child: Container(
                    height: screenHeight,
                    color: lightGrey,
                  ))
              : (widget.timeOut)
                  ? TryAgain(
                      retryCallback: widget.retryCallBack,
                    )
                  : GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
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
                        widget.customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        widget.customInfoWindowController.onCameraMove!();
                        widget.currentCameraPosition = position;
                      },
                      initialCameraPosition: widget.currentCameraPosition),

          CustomInfoWindow(
            controller: widget.customInfoWindowController,
            height: 70,
            width: 250,
            offset: 35,
          ),
          //Map or Satellite View
          Visibility(
            visible: (widget.timeOut) ? false : true,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, top: screenWidth * 0.035),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: widget.col2,
                        borderRadius: const BorderRadius.horizontal(
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
                          widget.ToggleMaptype(MapType.normal,
                              const Color(0xff878787), const Color(0xffFF5C00));
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
                          widget.ToggleMaptype(MapType.satellite,
                              const Color(0xffFF5C00), const Color(0xff878787));
                        },
                        child: const Text('Satellite',
                            style: TextStyle(
                              color: Colors.black,
                            ))),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: (widget.timeOut) ? false : true,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                              bearing: 0,
                              target: widget.currentCameraPosition.target,
                              zoom: widget.zoom,
                            ),
                          ));
                        } else {
                          setState(() {
                            widget.zoom = 8.0;
                            widget.zoombutton = true;
                          });
                          googleMapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                              bearing: 0,
                              target: const LatLng(20.5937, 78.9629),
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
                        googleMapController
                            .animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 0,
                            target: widget.currentCameraPosition.target,
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
                        googleMapController
                            .animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 0,
                            target: widget.currentCameraPosition.target,
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

          //This widget Shows the BottomSheet over the GoogleMap
          Visibility(
            visible: (widget.timeOut) ? false : true,
            child: DraggableScrollableSheet(
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.55,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: headerLightBlueColor,
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      locationBottomSheet(context),
                      Center(child: returnTimeLine(context))
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Container locationBottomSheet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.09,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: darkBlueTextColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Image(image: AssetImage('assets/icons/StartLoc.png')),
            SizedBox(width: screenWidth * 0.03),
            Text(widget.loadingPoint,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    fontSize: screenHeight * 0.02,
                    color: Colors.white)),
            SizedBox(width: screenWidth * 0.03),
            const Text('---------------->',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: screenWidth * 0.03),
            const Image(image: AssetImage('assets/icons/EndingLoc.png')),
            SizedBox(width: screenWidth * 0.03),
            Text(widget.unloadingPoint,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    fontSize: screenHeight * 0.02,
                    color: Colors.white))
          ]),
        ));
  }

  SizedBox returnTimeLine(context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: TimeLineWidget(
          location: widget.location,
          vehicle: widget.truckNumber,
        ));
  }
}
