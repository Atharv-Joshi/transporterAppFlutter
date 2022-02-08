import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/placesNearbyDataModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/nearbyPlacesDetailsCard.dart';
import 'package:logger/logger.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';

class NearbyPlacesDetails extends StatefulWidget {
  final double height, width;
  final placeOnTheMapName, placeOnTheMapTag;
  PlacesNearbyData placesNearbyData = new PlacesNearbyData();

  NearbyPlacesDetails({
    required this.height,
    required this.width,
    required this.placeOnTheMapName,
    required this.placeOnTheMapTag,
    required this.placesNearbyData,
  });

  @override
  _NearbyPlacesDetailsState createState() => _NearbyPlacesDetailsState();
}

class _NearbyPlacesDetailsState extends State<NearbyPlacesDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height / 3 + 24,
        width: widget.width,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: darkShadow,
                offset: const Offset(
                  0,
                  -5.0,
                ),
                blurRadius: 15.0,
                spreadRadius: 10.0,
              ),
              BoxShadow(
                color: white,
                offset: const Offset(0, 1.0),
                blurRadius: 0.0,
                spreadRadius: 2.0,
              ),
            ]),
        child:
            ListView(physics: const NeverScrollableScrollPhysics(), children: <
                Widget>[
          Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: const Color(0xFFCBCBCB),
                  // height: size_3,
                  thickness: 3,
                  indent: 150,
                  endIndent: 150,
                ),
                Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.fromLTRB(space_1, space_1, space_1, space_1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        //Row for nearby location name and petrol prices
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/' +
                                      widget.placeOnTheMapTag +
                                      '.png',
                                  height: size_14,
                                  width: size_14,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  widget.placeOnTheMapName,
                                  style: TextStyle(
                                      fontSize: size_10,
                                      fontWeight: boldWeight,
                                      color: darkBlueColor),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        //Listview of Petrol Pumps nearby with their location
                        Container(
                            height: widget.height / 4 + 24,
                            margin: EdgeInsets.fromLTRB(0, space_1, 0, 0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: (widget.placesNearbyData.results !=
                                        null)
                                    ? widget.placesNearbyData.results!.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  Results here =
                                      widget.placesNearbyData.results![index];
                                  print("DISTANCE ABCD " +
                                      here.distance.toString());
                                  return NearbyPlacesDetailsCard(
                                      placeName: here.name,
                                      placeAddress: here.vicinity,
                                      placeDistance: here.distance,
                                      coordinates: here.geometry!.location!.lat
                                              .toString() +
                                          ',' +
                                          here.geometry!.location!.lng
                                              .toString());
                                })),
                      ],
                    )),
              ]),
        ]));
  }
}
