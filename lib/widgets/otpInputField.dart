import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/functions/authFunctions.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPInputField extends StatefulWidget {
  String _verificationCode = '';
  // String autoVerificationCode = '';

  var temp; // to store confirmationResult of WEB SIGN IN METHOD

  OTPInputField(this._verificationCode, [this.temp]);
  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  HudController hudController = Get.put(HudController());
  AuthService authService = AuthService();
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());
  TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: PinCodeTextField(
        cursorColor: Colors.black,
        appContext: context,
        controller: textEditingController,
        pastedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          activeFillColor: Colors.white,
          activeColor: Colors.black,
          inactiveColor: Colors.black,
          selectedFillColor: Colors.white,
          selectedColor: Colors.black,
          inactiveFillColor: Colors.white,
          fieldHeight: 48,
          fieldWidth: 48,
        ),
        length: 6,
        enableActiveFill: true,
        keyboardType: TextInputType.phone,
        onCompleted: (pin) {
          hudController.updateHud(true);
          providerData.updateSmsCode(pin);
          print("${providerData.smsCode}-------------------SMS Code");
          print(
                "${widget._verificationCode}-------------------Verification Code"); // For Android Authentication
          // isOtpInvalidController.updateIsOtpInvalid(false);
            print("INITIALIZING MANUAL VERIFICATION ON ANDROID");
            authService.manualVerification(
                smsCode: providerData.smsCode,
                verificationId: widget._verificationCode);
          providerData.updateInputControllerLengthCheck(true);
          providerData.clearAll();
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
