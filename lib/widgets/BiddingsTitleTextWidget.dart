import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class BiddingsTitleTextWidget extends StatelessWidget {
  const BiddingsTitleTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Biddings",
      style: TextStyle(
          fontSize: size_10,
          color: blueTitleColor,
          fontWeight: mediumBoldWeight,
          fontFamily: "Montserrat"),
    );
  }
}
