import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class PriceButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: LightGrayishBlue, borderRadius: BorderRadius.circular(5)),
      height: 35,
      width: 110,
      child: Center(
        child: Text(
          "रु6000/tonne",
          style: TextStyle(
              color: darkBlueColor,
              fontWeight: mediumBoldWeight,
              fontSize: size_7),
        ),
      ),
    );
  }
}
