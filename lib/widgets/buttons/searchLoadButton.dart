import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';

class SearchLoadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: double.infinity,
      child: TextButton(
        child: Text(
          'Search Load',
          style: TextStyle(
              letterSpacing: 1,
              fontSize: size_9,
              color: white,
              fontWeight: mediumBoldWeight),
        ),
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius_6),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
      ),
    );
  }
}
