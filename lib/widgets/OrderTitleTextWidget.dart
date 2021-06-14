import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';

class OrderTitleTextWidget extends StatelessWidget {
  const OrderTitleTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Orders",
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: size_10,
          color: liveasyBlackColor,
          fontFamily: "Montserrat"),
    );
  }
}
