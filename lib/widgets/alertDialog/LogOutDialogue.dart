import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/CancelLogoutButton.dart';
import 'package:liveasy/widgets/buttons/LogoutOkButton.dart';

class LogoutDialogue extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Are you sure? You want to logout"),
      actions: <Widget>[
        LogoutOkButton(),
        CancelLogoutButton(),
        SizedBox(
          height: space_12
        )
      ]
    );
  }
}