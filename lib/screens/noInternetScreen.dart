import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class NoInternetConnection {
  static Column noInternetDialogue() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/wifi.gif',
          width: 115,
          height: 115,
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          'Ooops!',
          style: TextStyle(
            fontWeight: mediumBoldWeight,
            fontFamily: 'Montserrat',
            fontSize: size_9,
            color: black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Slow or no internet connection.\n Check your network connection and \n try again.',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: normalWeight,
              fontSize: size_6,
              color: grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
