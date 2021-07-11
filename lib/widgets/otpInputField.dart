import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/functions/authFunctions.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPInputField extends StatefulWidget {
  String _verificationCode = '';
  // String autoVerificationCode = '';

  OTPInputField(this._verificationCode);
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  HudController hudController = Get.put(HudController());
  AuthService authService = AuthService();
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return OTPTextField(
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: radius_1,
      margin: EdgeInsets.only(left: space_2),
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: white,
        //TODO:change enabledBorderColor dynamically according to figma
        enabledBorderColor: blueTitleColor,
        focusBorderColor: blueTitleColor,
      ),
      length: 6,
      width: MediaQuery.of(context).size.width / 1.2,
      fieldWidth: space_8,
      style: TextStyle(fontSize: 17),
      onCompleted: (pin) {
        hudController.updateHud(true);
        providerData.updateSmsCode(pin);
        // isOtpInvalidController.updateIsOtpInvalid(false);
        authService.manualVerification(
            smsCode: providerData.smsCode,
            verificationId: widget._verificationCode);

        providerData.updateInputControllerLengthCheck(true);
        providerData.clearAll();
      },
      onChanged: (value) {
        setState(() {});
        if (value.length == 6) {
          isOtpInvalidController.updateIsOtpInvalid(false);
        }
        print("changed to - ${value.length}");
      },
    );
  }
}
