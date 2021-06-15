import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/raidus.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverDetailsFromDriverApi.dart';

// ignore: must_be_immutable
class AddButton extends StatelessWidget {
  String? displayContact;

  AddButton({this.displayContact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        for (int i=0;i<driverNameList.length;i++)
        {

          if (driverNameList[i] == displayContact)
          {print("has already added");
          break;}
          else if(i==driverNameList.length-1)
          driverNameList.add(displayContact);
        }
          Navigator.of(context).pop();
        },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: bidBackground,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "Add",
            style: TextStyle(
                color: white,
                fontWeight: normalWeight,
                fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}