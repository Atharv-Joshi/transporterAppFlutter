import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';

class GetStartedButton extends StatefulWidget {
  Function? onTapNext;

  GetStartedButton({Key? key, required this.onTapNext}) : super(key: key);

  @override
  _GetStartedButtonState createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        // highlightColor: Colors.transparent,
        onPressed: () {
          widget.onTapNext!();
        },
        child: Container(
          height: space_8,
          decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6),
          ),
          child: Center(
            child: Text(
              'getStarted'.tr,
              // "Get Started",
              style: TextStyle(
                  color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
            ),
          ),
        ));
    //   GestureDetector(
    //   onTap: (){
    //     widget.onTapNext!();
    //   },
    //   child: Container(
    //     height: space_8,
    //     decoration: BoxDecoration(
    //         color: darkBlueColor,
    //         borderRadius: BorderRadius.circular(radius_6)),
    //     child: Center(
    //       child: Text(
    //         'getStarted'.tr,
    //         // "Get Started",
    //         style: TextStyle(
    //             color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
    //       ),
    //     ),
    //   ),
    // );
  }
}
