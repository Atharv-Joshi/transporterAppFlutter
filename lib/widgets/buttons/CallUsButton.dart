import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CallUs extends StatelessWidget {

  String number;
  CallUs({required this.number});

  @override
  Widget build(BuildContext context) {
    NavigationIndexController navigationIndexController =
        Get.find<NavigationIndexController>();

    return GestureDetector(
      onTap: () {
        String url = 'tel:$number';
        UrlLauncher.launch(url);
      },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_8,
        width: (space_16 * 2) + 3,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6)),
        child: Center(
          child: Text(
            "Call Us",
            style: TextStyle(
                color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
          ),
        ),
      ),
    );
  }
}
