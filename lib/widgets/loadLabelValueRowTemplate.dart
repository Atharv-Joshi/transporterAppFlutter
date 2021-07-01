import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadLabelValueRowTemplate extends StatelessWidget {
  final String? label;
  final String? value;

  LoadLabelValueRowTemplate({required this.value , required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: space_1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label',
            style: TextStyle(fontWeight: normalWeight),
          ),
          Text(
            value!,
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: veryDarkGrey
            ),
          ),
        ],
      ),
    );
  }
}
