import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
class BidButtonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      height: 31,
      width: 80,
      decoration: BoxDecoration(
          color: darkBlueColor,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          "Bid",
          style: TextStyle(
              color: Colors.white,
              fontWeight: normalWeight,
              fontSize: size_6 + 2),
        ),
      ),
    );
  }
}
