import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/screens/myDriversScreen.dart';

class OkButtonDeleteDriver extends StatelessWidget {
  DriverModel driverData;

  OkButtonDeleteDriver({required this.driverData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disableActionOnDriver(driverId: driverData.id.toString());
        Timer(Duration(milliseconds: 1), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyDrivers()));
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_7,
        width: space_16,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6),
            boxShadow: [
              BoxShadow(color: darkGreyColor, offset: Offset(2.0, 2.0))
            ]),
        child: Center(
          child: Text(
            "Ok",
            style: TextStyle(
                color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
          ),
        ),
      ),
    );
  }
}
