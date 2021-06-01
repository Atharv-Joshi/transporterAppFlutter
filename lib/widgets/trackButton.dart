import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class TrackButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: (){print('Track Button Pressed');},
        child: Text(
          'Track',
          style: TextStyle(
            letterSpacing: 0.7,
            fontWeight: FontWeight.w400,
            color: white,
            fontSize: space_3,
          ),
        ),
      ),
    );
  }
}
