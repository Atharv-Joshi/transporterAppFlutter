import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/controller/timerController.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Web/successScreen.dart';
import '../Web/unSuccessScreen.dart';
import '../screens/isolatedTransporterGetData.dart';

class AuthService {
  HudController hudController = Get.put(HudController());
  TimerController timerController = Get.put(TimerController());
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  Future signOut() async {
    try {
      Get.to(() => LoginScreen());
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void manualVerification({String? verificationId, String? smsCode}) async {
    print('verificationId in manual func: $smsCode');
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationId!, smsCode: smsCode!))
          .then((value) async {
        if (value.user != null) {
          print("${value.user!.phoneNumber} ----- ${value.user}");
          print('hud True due to try in manual verification');
          hudController.updateHud(true);
          timerController.cancelTimer();

          await runTransporterApiPost(
              mobileNum: value.user!.phoneNumber!.toString().substring(3, 13));

          // POST BID NOTIFICATIONS SECTION -------------------------

          // Once the user logs in ---- Set or Update the external one signal user id for user -- where external id is the transporter id or shipper id correspondingly; ------
          print("SETTING EXTERNAL ONESIGNAL USER ID -------");

          String externalUserId = transporterIdController.transporterId
              .toString(); // You will supply the external user id to the OneSignal SDK
          print("external user id ----- $externalUserId");

          OneSignal.shared.setExternalUserId(externalUserId).then((results) {
            log(results.toString());
          }).catchError((error) {
            log(error.toString());
          });

          // -----------------------------

          Get.offAll(() => NavigationScreen());
        }
      });
    } on FirebaseAuthException catch (e) {
      // FocusScope.of(context).unfocus();
      print("---------------------->${e.code}");
      if (e.code == "session-expired") {
        hudController.updateHud(true);
        isOtpInvalidController.updateIsOtpInvalid(false);
        //await FirebaseAuth.instance.signInWithCredential(credential);

        timerController.cancelTimer();
        // await runTransporterApiPost(
        //     mobileNum: value1.user!.phoneNumber!.toString().substring(3, 13));
        // Get.offAll(() => NavigationScreen());
        print("---------------------------------->hi");
      } else {
        print('hud false due to catch in manual verification');

        hudController.updateHud(false);
        // Get.to(() => NewLoginScreen());
        isOtpInvalidController.updateIsOtpInvalid(true);
      }
      // Get.snackbar('Invalid Otp', 'Please Enter the correct OTP',
      //     colorText: white, backgroundColor: black_87);
    }
  }

  void manualVerification_web({var temp, String? smsCode}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    print("WEB MANUAL OTP VERIFICATION STARTED -------------");
    print('verificationId in manual func: $smsCode');
    try {
      UserCredential userCredential = await temp.confirm(smsCode!);
      if (userCredential.user != null) {
        hudController.updateHud(true);
        timerController.cancelTimer();
        await runTransporterApiPost(
            mobileNum:
                userCredential.user!.phoneNumber!.toString().substring(3, 13));
        print("COVER");
        preferences.setString(
            'uid', transporterIdController.mobileNum.toString());
        print(transporterIdController.mobileNum.toString());
        Get.to(() => SuccessScreen());
        print("Transferred to next screen");
      }
      userCredential.additionalUserInfo!.isNewUser
          ? print("Authentication Successful")
          : print("User already exists");
    } on FirebaseAuthException catch (e) {
      Get.to(UnSuccessScreen());
      print('ERROR');
    }
  }
}
