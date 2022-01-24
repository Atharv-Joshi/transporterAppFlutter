import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/CancelLogoutButton.dart';
import 'package:liveasy/widgets/buttons/LogoutOkButton.dart';

class LogoutDialogue extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      title: new Text(
        'logoutDialog'.tr,
        // "Are you sure? You want to logout" ,
          style: TextStyle(
      color: liveasyBlackColor,
          fontSize: size_9,
          fontFamily: 'montserrat',
          fontWeight: regularWeight)),
      actions: <Widget>[
        LogoutOkButton(),
        CancelLogoutButton(),
        SizedBox(
          height: space_3
        )
      ]
    );
  }
}