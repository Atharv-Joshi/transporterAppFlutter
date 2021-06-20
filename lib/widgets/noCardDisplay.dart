import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class NoCardDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: space_7,
        ),
        Image(
          image: AssetImage("assets/icons/errorIcon.png"),
          height: size_15 + 6,
          width: size_15 + 11,
        ),
        SizedBox(
          height: space_3,
        ),
        Text(
          "Sorry! We could not find a load",
          style: TextStyle(
              color: veryDarkGrey, fontWeight: regularWeight, fontSize: size_8),
        ),
        Text(
          "on this route",
          style: TextStyle(
              color: veryDarkGrey, fontWeight: regularWeight, fontSize: size_8),
        )
      ],
    );
  }
}
