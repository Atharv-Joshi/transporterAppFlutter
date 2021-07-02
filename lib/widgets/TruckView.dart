import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';

class TruckView extends StatelessWidget {
  const TruckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 140,
        ),
        Positioned(
          left: space_4,
          child: Container(
            width: space_17,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size_4),
              color: truckGreen,
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: space_1),
            child: Image(
              image: AssetImage("assets/images/overviewtataultra.png"),
            ),
          ),
        )
      ],
    );
  }
}
