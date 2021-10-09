import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class CancelLogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: darkBlueColor))),
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0)),
        ),
        onPressed: () {
          Get.back();
        },
        child: Container(
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: mediumBoldWeight,
              color: darkBlueColor,
              fontSize: size_7,
            ),
          ),
        ),
      ),
    );
  }
}
