import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';

// ignore: must_be_immutable
class SuggestedLoadDataDisplayCard extends StatelessWidget {
  String loadingPointCity;
  String unloadingPointCity;
  var onTap;

  SuggestedLoadDataDisplayCard({
    required this.loadingPointCity,
    required this.unloadingPointCity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76,
        width: 71,
        decoration: BoxDecoration(
          color: widgetBackGroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        margin: EdgeInsets.only(top: space_3, left: space_3, bottom: space_3),
        padding: EdgeInsets.symmetric(vertical: space_2, horizontal: space_1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                 LoadingPointImageIcon(width: 8, height: 8),
                  SizedBox(width: space_1,),
                  Text(
                    '$loadingPointCity',
                    style: TextStyle(fontSize: size_5, color: grey),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  UnloadingPointImageIcon(width: 8, height: 8),
                  SizedBox(width: space_1,),
                  Text(
                    '$unloadingPointCity',
                    style: TextStyle(fontSize: size_5, color: grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
