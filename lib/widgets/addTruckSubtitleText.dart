import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

// ignore: must_be_immutable
class AddTruckSubtitleText extends StatelessWidget {
  final String text;

  AddTruckSubtitleText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        color: liveasyGreen,
        fontWeight: mediumBoldWeight,
        fontSize: size_8,
      ),
    );
  }
}
