import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import 'package:liveasy/screens/myLoadPages/biddingScreen.dart';
import 'package:liveasy/screens/PostLoadScreens/postloadnavigation.dart';

// ignore: must_be_immutable
class RepostButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(declineButtonRed),
        ),
        onPressed: () { Get.to(postloadnav()); },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0 , horizontal: space_5),
          child:  Text(
            'repost'.tr,
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_7,
            ),
          ),
        ),
      ),
    );
  }
}
