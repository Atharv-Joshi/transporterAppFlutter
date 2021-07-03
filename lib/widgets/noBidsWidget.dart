import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

import 'buttons/searchLoadButton.dart';

class NoBidsWidget extends StatefulWidget {
  @override
  _NoBidsWidgetState createState() => _NoBidsWidgetState();
}

class _NoBidsWidgetState extends State<NoBidsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/images/loadBoxImage.png"),
            height: (space_10 * 2) - 2,
          ),
          SizedBox(
            height: space_4,
          ),
          Container(
            child: Text(
              "Oh! You have not made any biddings.",
              style: TextStyle(
                  fontSize: size_8, fontWeight: regularWeight, color: textBlur),
            ),
          ),
          Container(
            child: Text(
              "Make a bid and comeback",
              style: TextStyle(
                  fontSize: size_8, fontWeight: regularWeight, color: textBlur),
            ),
          ),
          SizedBox(
            height: space_3,
          ),
          SearchLoadButton()
        ],
      ),
    );
  }
}
