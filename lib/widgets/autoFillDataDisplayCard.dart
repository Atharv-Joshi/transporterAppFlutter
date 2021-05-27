import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class AutoFillDataDisplayCard extends StatelessWidget {
  String placeName;
  String placeAddress;
  var onTap;

  AutoFillDataDisplayCard(
    this.placeName,
    this.placeAddress,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: space_8,
        decoration: BoxDecoration(
            color: widgetBackGroundColor,
            border: Border.symmetric(
                horizontal: BorderSide(width: 0.5, color: greyBorderColor,),),),
        padding: EdgeInsets.all(space_1),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: space_1),
              child: Icon(
                Icons.location_on_outlined,
                color: borderBlueColor,
              ),
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    '$placeName',
                    style:
                        TextStyle(fontSize: size_7, color: liveasyBlackColor),
                  ),
                ),
                Container(
                  child: Text(
                    ' ($placeAddress)',
                    style:
                    TextStyle(fontSize: size_6, color: liveasyBlackColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
