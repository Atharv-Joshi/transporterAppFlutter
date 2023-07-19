import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LogoutOkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OneSignal.shared.removeExternalUserId();
        FirebaseAuth.instance.signOut().then((value) =>
            tidstorage.erase().then((value) => print('Storage is erased')));
        Get.offAll(LoginScreen());
      },
      child: Container(
        height: 31,
        width: 80,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: darkShadow,
                offset: Offset(0, 0),
                blurRadius: 16,
                spreadRadius: 0,
              )
            ],
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "ok".tr,
            style: TextStyle(
                fontFamily: 'montserrat',
                color: backgroundColor, fontWeight: mediumBoldWeight, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
