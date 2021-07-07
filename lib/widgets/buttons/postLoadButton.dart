import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';

// ignore: must_be_immutable
class PostButtonLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: space_33,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(liveasyGreen),
        ),
        onPressed: () {
          Get.to(PostLoadScreenOne());
        },
        child: Container(
          child: Text(
            'Post Load',
            style: TextStyle(
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_8,
            ),
          ),
        ),
      ),
    );
  }
}
