import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/accountVerification/accountPageUtil.dart';
import 'package:provider/provider.dart';

class VerifyNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationIndexController navigationIndexController =
        Get.find<NavigationIndexController>();
    return GestureDetector(
      onTap: () {
        Get.offAll(NavigationScreen(initScreen: 4));
        navigationIndexController.updateIndex(4);
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
            "Verify Now",
            style: TextStyle(
                color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
          ),
        ),
      ),
    );
  }
}
