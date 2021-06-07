import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';

class AddTruckSubtitleText extends StatelessWidget {


  String text;

  AddTruckSubtitleText({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        color: truckGreen,
        fontSize: size_9,
      ),
    );
  }
}
