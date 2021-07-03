import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/verifyNowButton.dart';

class VerifyAccountNotifyAlertDialog extends StatefulWidget {
  @override
  _VerifyAccountNotifyAlertDialogState createState() =>
      _VerifyAccountNotifyAlertDialogState();
}

class _VerifyAccountNotifyAlertDialogState
    extends State<VerifyAccountNotifyAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(
        left: space_4,
        right: space_4,
      ),
      title: Column(
        children: [
          Image(
              height: space_16,
              width: (space_9 * 2) + 3,
              image: AssetImage("assets/icons/errorIcon.png")),
          SizedBox(
            height: space_2,
          ),
          Text(
            "Your Account is not Verified",
            style: TextStyle(
                fontWeight: normalWeight,
                fontSize: size_9,
                color: liveasyOrange),
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            "Upload details and get it verified to book loads",
            style: TextStyle(
                fontWeight: normalWeight, fontSize: size_9, color: black),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: space_8,
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VerifyNowButton(),
          ],
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
    );
  }
}
