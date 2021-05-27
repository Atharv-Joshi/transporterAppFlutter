import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LiveasyTitleTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
        height: space_6,
        child: Center(
        child: Text(
        "Liveasy",
        style: TextStyle(
        fontSize:  size_13,
              color: blueTitleColor,
              fontWeight: normalWeight),
        ),
      ),
    );
  }
}
