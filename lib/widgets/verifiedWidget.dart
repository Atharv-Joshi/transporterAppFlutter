import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';

class VerifiedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_3,
      width: space_10 - 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius_1 - 2),
        color: lightishGreen,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: space_1 + 3,
            width: space_1 + 3,
            image: AssetImage("assets/icons/verifiedButtonIcon.png"),
          ),
          Text(
            "verified",
            style: TextStyle(fontWeight: normalWeight, fontSize: size_3 + 1),
          ),
        ],
      ),
    );
  }
}
