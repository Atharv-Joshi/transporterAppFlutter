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
  OTPInputField(this._verificationCode);
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();
  HudController hudController = Get.put(HudController());
  AuthService authService = AuthService();
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    Color getColor() {
      if (isOtpInvalidController.isOtpInvalid.value) {
        return red;
      } else
        return blueTitleColor;
    }

    return OTPTextField(
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: radius_1,
      margin: EdgeInsets.only(left: space_2),
      otpFieldStyle: OtpFieldStyle(
        enabledBorderColor: getColor(),
        focusBorderColor: blueTitleColor,
      ),
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: space_8,
      style: TextStyle(fontSize: 17),
      onCompleted: (pin) {
        setState(() {
          print("otp is wrong--${isOtpInvalidController.isOtpInvalid.value}");
          hudController.updateHud(true);
          providerData.updateSmsCode(pin);
          // timerController.cancelTimer();
          authService.manualVerification(
              smsCode: providerData.smsCode,
              verificationId: widget._verificationCode);

          providerData.updateInputControllerLengthCheck(true);

          providerData.clearAll();
        });
      },
    );
  }
}
