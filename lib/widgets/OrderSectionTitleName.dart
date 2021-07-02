import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class OrderSectionTitleName extends StatelessWidget {
  String name;
  OrderSectionTitleName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontWeight: normalWeight,
          fontSize: size_7,
          color: liveasyBlackColor,
          fontFamily: "Montserrat"),
    );
  }
}
