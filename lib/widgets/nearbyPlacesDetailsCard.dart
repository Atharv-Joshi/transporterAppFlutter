import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPlacesDetailsCard extends StatefulWidget {
  var placeName;
  var placeAddress;
  var placeDistance;
  var coordinates;

  NearbyPlacesDetailsCard({
    required this.placeName,
    required this.placeAddress,
    required this.placeDistance,
    required this.coordinates,
  });
  @override
  _NearbyPlacesDetailsCardState createState() =>
      _NearbyPlacesDetailsCardState();
}

class _NearbyPlacesDetailsCardState extends State<NearbyPlacesDetailsCard> {
  Future<void> openMap(String coordinates) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$coordinates';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(
              widget.placeName.toString(),
              style: TextStyle(
                  fontSize: size_7,
                  fontWeight: mediumBoldWeight,
                  color: darkBlueColor),
            ),
            subtitle: Text(
              widget.placeAddress.toString(),
              style: TextStyle(
                fontSize: size_6,
                fontWeight: mediumBoldWeight,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    openMap(widget.coordinates);
                  },
                  child: Image.asset(
                    'assets/icons/navigateIcon.png',
                    height: size_14,
                    width: size_14,
                  ),
                ),
                Text(
                  widget.placeDistance.toStringAsFixed(1) + " km",
                  style: TextStyle(
                      fontSize: size_5,
                      fontWeight: mediumBoldWeight,
                      color: darkBlueColor),
                ),
              ],
            )));
  }
}
