import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';

class AlertOkButton extends StatelessWidget {
  const AlertOkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.only(left: space_10, right: space_10),
        child: Container(
          decoration: BoxDecoration(
              color: darkBlueColor,
              borderRadius: BorderRadius.circular(radius_6),
              boxShadow: [
                BoxShadow(color: darkGreyColor, offset: Offset(2.0, 2.0))
              ]),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: space_2, bottom: space_2),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: white,
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
