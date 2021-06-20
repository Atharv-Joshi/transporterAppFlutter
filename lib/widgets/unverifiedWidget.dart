import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class UnverifiedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_3,
      width: space_10 - 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.81),
        color: liveasyOrange,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "unverified",
            style: TextStyle(fontWeight: normalWeight, fontSize: size_3 + 1),
          ),
        ],
      ),
    );
  }
}
