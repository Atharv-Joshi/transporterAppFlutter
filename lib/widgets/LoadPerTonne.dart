import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadPerTonne extends StatelessWidget {
  int load;
  LoadPerTonne({Key? key, required this.load}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: space_22,
      height: space_7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space_1), color: priceBackground),
      child: Container(
        child: Center(
          child: Text(
            "₹${load.toString()}/tonne",
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                fontSize: size_6,
                color: bidBackground,
                fontFamily: "Montserrat"),
          ),
        ),
      ),
    );
  }
}
