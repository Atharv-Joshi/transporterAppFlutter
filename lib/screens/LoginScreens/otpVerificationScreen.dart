import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/isOtpInvalidController.dart';
import 'package:liveasy/controller/timerController.dart';
import 'package:liveasy/functions/authFunctions.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/otpInputField.dart';
import 'package:provider/provider.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

import '../../responsive.dart';
import '../../widgets/webLoginLeftPart.dart';
import '../navigationScreen.dart';

class NewOTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  NewOTPVerificationScreen(this.phoneNumber);

  @override
  _NewOTPVerificationScreenState createState() =>
      _NewOTPVerificationScreenState();
}

class _NewOTPVerificationScreenState
    extends VisibilityAwareState<NewOTPVerificationScreen> {
//--------------------------------------------------------------------------------------------------------------------
  late AppLifecycleState go = AppLifecycleState.resumed;

//objects
  AuthService authService = AuthService();

  //keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //variables
  String _verificationCode = '';
  var temp; // to store confirmationResult of WEB SIGN IN METHOD
  late int _forceResendingToken = 0;
  bool isError = false;
  bool size = true;

  //controllers

  TimerController timerController = Get.put(TimerController());
  HudController hudController = Get.put(HudController());
  // TextEditingController textEditingController = TextEditingController();
  IsOtpInvalidController isOtpInvalidController =
      Get.put(IsOtpInvalidController());

  //--------------------------------------------------------------------------------------------------------------------
  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    print('Visibility state : $visibility');
    super.onVisibilityChanged(visibility);
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: (kIsWeb && (Responsive.isDesktop(context)))
          ? SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Container(
                  child: Row(
                    children: [
                      const WebLoginLeftPart(),
                      Expanded(
                        child: Container(
                          color: formBackground,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  double maxWidth = kIsWeb
                                      ? screenWidth * 0.5
                                      : screenWidth * 0.8;
                                  double containerHeight = isError
                                      ? screenHeight * 0.5
                                      : screenHeight * 1;
                                  return Container(
                                    width: maxWidth,
                                    height: containerHeight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: screenHeight * 0.2,
                                          ),
                                          child: Text(
                                            'Verification Code'.tr,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 36,
                                              fontWeight: FontWeight.w700,
                                              color: blueTitleColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                        ),
                                        Text(
                                          'Please type the verification code sent to'
                                              .tr,
                                          style: TextStyle(
                                            fontSize: size_12,
                                            fontWeight: FontWeight.w400,
                                            color: blueTitleColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Text(' +91${widget.phoneNumber} ',
                                            style: TextStyle(
                                                fontSize: size_12,
                                                fontWeight: regularWeight,
                                                color: blueTitleColor,
                                                fontFamily: "Roboto")),
                                        SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'change'.tr,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: size_10,
                                              fontWeight: regularWeight,
                                              color: bidBackground,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                        ),
                                        // TODO Otp Input Field
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: screenWidth * 0.08,
                                              right: screenWidth * 0.08),
                                          child: OTPInputField(
                                              _verificationCode, temp),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: space_3,
                                              right: screenWidth * 0.24),
                                          child: Obx(
                                            () => Container(
                                              child: timerController
                                                          .timeOnTimer.value ==
                                                      0
                                                  ? Obx(() => TextButton(
                                                      onPressed: () {
                                                        timerController
                                                            .startTimer();
                                                        // hudController.updateHud(true);

                                                        kIsWeb
                                                            ? _verifyPhoneNum_web()
                                                            : _verifyPhoneNumber();
                                                      },
                                                      child: Text(
                                                        'Resendotp'.tr,
                                                        // 'Resend OTP',
                                                        style: TextStyle(
                                                          letterSpacing: 0.5,
                                                          fontSize: size_12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: timerController
                                                                  .resendButton
                                                                  .value
                                                              ? navygreen
                                                              : unselectedGrey,
                                                          // decoration:
                                                          //     TextDecoration
                                                          //         .underline,
                                                        ),
                                                      )))
                                                  : Obx(
                                                      () => Text(
                                                        'Resendotp'.tr +
                                                            '${timerController.timeOnTimer}',
                                                        // 'Resend OTP in ${timerController.timeOnTimer}',
                                                        style: TextStyle(
                                                          letterSpacing: 0.5,
                                                          color: veryDarkGrey,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: space_4),
                                            child: Obx(
                                              () => Container(
                                                child: isOtpInvalidController
                                                        .isOtpInvalid.value
                                                    ? Text(
                                                        'Wrong OTP. Try Again!',
                                                        style: TextStyle(
                                                          letterSpacing: 0.5,
                                                          color: red,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              top: space_8,
                                            ),
                                            child: Obx(
                                              () => Container(
                                                child: hudController
                                                        .showHud.value
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("Verifying OTP"),
                                                          SizedBox(
                                                            width: space_1,
                                                          ),
                                                          Container(
                                                              width: space_3,
                                                              height: space_3,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 1,
                                                              ))
                                                        ],
                                                      )
                                                    : Text(""),
                                              ),
                                            )),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       left: screenWidth * 0.1,
                                        //       right: screenWidth * 0.1),
                                        //   child: PinCodeTextField(
                                        //     cursorColor: Colors.black,
                                        //     appContext: context,
                                        //     controller: textEditingController,
                                        //     pastedTextStyle: const TextStyle(
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.bold,
                                        //         fontFamily: 'Montserrat'),
                                        //     pinTheme: PinTheme(
                                        //       shape: PinCodeFieldShape.box,
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //       activeFillColor: Colors.white,
                                        //       activeColor: Colors.grey,
                                        //       inactiveColor: Colors.grey,
                                        //       selectedFillColor: Colors.white,
                                        //       selectedColor: Colors.black,
                                        //       inactiveFillColor: Colors.white,
                                        //       fieldHeight: 48,
                                        //       fieldWidth: 48,
                                        //     ),
                                        //     length: 6,
                                        //     enableActiveFill: true,
                                        //     keyboardType: TextInputType.phone,
                                        //     onCompleted: (pin) {
                                        //       hudController.updateHud(true);
                                        //       providerData.updateSmsCode(pin);
                                        //       print(
                                        //           "${providerData.smsCode}-----------------SMS Code");
                                        //       if (kIsWeb) {
                                        //         print(
                                        //             "$temp-------------------temp"); // For WEB Authentication
                                        //       }
                                        //       providerData
                                        //           .updateInputControllerLengthCheck(
                                        //               true);
                                        //       providerData.clearAll();
                                        //     },
                                        //     onChanged: (value) {
                                        //       setState(() {});
                                        //     },
                                        //   ),
                                        // ),
                                        // Padding(
                                        //     padding:
                                        //         EdgeInsets.only(top: space_3),
                                        //     child: Obx(
                                        //       () => Container(
                                        //         child: isOtpInvalidController
                                        //                 .isOtpInvalid.value
                                        //             ? Text(
                                        //                 'Wrong OTP. Try Again!',
                                        //                 style: TextStyle(
                                        //                   letterSpacing: 0.5,
                                        //                   color: red,
                                        //                 ),
                                        //               )
                                        //             : Text(""),
                                        //       ),
                                        //     )),
                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding: EdgeInsets.only(
                                        //           top: space_3,
                                        //           left: screenWidth * 0.1),
                                        //       child: Obx(
                                        //         () => Container(
                                        //           child: timerController
                                        //                       .timeOnTimer
                                        //                       .value ==
                                        //                   0
                                        //               ? Obx(() => TextButton(
                                        //                   onPressed: () {
                                        //                     timerController
                                        //                         .startTimer();
                                        //                     _verifyPhoneNum_web();
                                        //                   },
                                        //                   child: Text(
                                        //                     'Resendotp'.tr,
                                        //                     style: TextStyle(
                                        //                       letterSpacing:
                                        //                           0.5,
                                        //                       color: timerController
                                        //                               .resendButton
                                        //                               .value
                                        //                           ? navy
                                        //                           : unselectedGrey,
                                        //                       decoration:
                                        //                           TextDecoration
                                        //                               .underline,
                                        //                     ),
                                        //                   )))
                                        //               : Obx(
                                        //                   () => Text(
                                        //                     'Resendotp'.tr +
                                        //                         '${timerController.timeOnTimer}',
                                        //                     style: TextStyle(
                                        //                       letterSpacing:
                                        //                           0.5,
                                        //                       color:
                                        //                           veryDarkGrey,
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // ElevatedButton(
                                        //     onPressed: () {
                                        //       print(
                                        //           hudController.showHud.value);
                                        //     },
                                        //     child: Container(
                                        //       width: 100,
                                        //       height: 100,
                                        //     ))
                                        // Padding(
                                        //     padding: EdgeInsets.only(
                                        //         top: screenHeight * 0.1),
                                        //     child: ConfirmButton(
                                        //       text: 'Verify',
                                        //       onPressed: () {
                                        //         if (textEditingController
                                        //                 .text.length ==
                                        //             6) {
                                        //           authService
                                        //               .manualVerification_web(
                                        //                   smsCode:
                                        //                       textEditingController
                                        //                           .text,
                                        //                   temp: temp
                                        //           );
                                        //         } else {}
                                        //       },
                                        //     )),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: bidBackground,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: space_8, bottom: space_12),
                          child: Container(
                            width: space_34,
                            height: space_8,
                            child: Image(
                              image: AssetImage("assets/icons/Liveasy.png"),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(radius_3),
                                  topRight: Radius.circular(radius_3))),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                space_0, size_12, space_0, size_0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      space_2, space_0, space_0, space_4),
                                  child: Text(
                                    'OTPverify'.tr,
                                    // 'OTP Verification',
                                    style: TextStyle(
                                      fontSize: size_10,
                                      fontWeight: boldWeight,
                                      color: black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: space_5),
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'OTPsent'.tr,
                                        // 'OTP sent to',
                                        style: TextStyle(
                                          fontSize: size_6,
                                          fontWeight: regularWeight,
                                          color: darkCharcoal,
                                        ),
                                      ),
                                      Text(' +91${widget.phoneNumber} ',
                                          style: TextStyle(
                                              fontSize: size_7,
                                              fontWeight: regularWeight,
                                              color: black,
                                              fontFamily: "Roboto")),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'change'.tr,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: size_6,
                                            fontWeight: regularWeight,
                                            color: bidBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                                OTPInputField(_verificationCode, temp),
                                Padding(
                                    padding: EdgeInsets.only(top: space_3),
                                    child: Obx(
                                      () => Container(
                                        child: isOtpInvalidController
                                                .isOtpInvalid.value
                                            ? Text(
                                                'Wrong OTP. Try Again!',
                                                style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: red,
                                                ),
                                              )
                                            : Text(""),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: space_3),
                                  child: Obx(
                                    () => Container(
                                      child: timerController
                                                  .timeOnTimer.value ==
                                              0
                                          ? Obx(() => TextButton(
                                              onPressed: () {
                                                timerController.startTimer();
                                                // hudController.updateHud(true);

                                                kIsWeb
                                                    ? _verifyPhoneNum_web()
                                                    : _verifyPhoneNumber();
                                              },
                                              child: Text(
                                                'Resendotp'.tr,
                                                // 'Resend OTP',
                                                style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: timerController
                                                          .resendButton.value
                                                      ? navygreen
                                                      : unselectedGrey,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )))
                                          : Obx(
                                              () => Text(
                                                'Resendotp'.tr +
                                                    '${timerController.timeOnTimer}',
                                                // 'Resend OTP in ${timerController.timeOnTimer}',
                                                style: TextStyle(
                                                  letterSpacing: 0.5,
                                                  color: veryDarkGrey,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: space_5),
                                    child: Obx(
                                      () => Container(
                                        child: hudController.showHud.value
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Verifying OTP"),
                                                  SizedBox(
                                                    width: space_1,
                                                  ),
                                                  Container(
                                                      width: space_3,
                                                      height: space_3,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      ))
                                                ],
                                              )
                                            : Text(""),
                                      ),
                                    )),
                                // ElevatedButton(
                                //     onPressed: () {
                                //       print(hudController.showHud.value);
                                //     },
                                //     child: Container(
                                //       width: 100,
                                //       height: 100,
                                //     ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    timerController.startTimer();
    isOtpInvalidController.updateIsOtpInvalid(false);
    // hudController.updateHud(false);
    kIsWeb ? _verifyPhoneNum_web() : _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    // try {
    print('in verify phone ANDROID VERSION');
    print(widget.phoneNumber);

    await FirebaseAuth.instance.verifyPhoneNumber(
        //this value changes runtime
        forceResendingToken: _forceResendingToken,
        phoneNumber: '+91${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(credential.smsCode);
          hudController.updateHud(true);
          print(credential.smsCode);
          await FirebaseAuth.instance.signInWithCredential(credential);

          timerController.cancelTimer();
          await runTransporterApiPost(mobileNum: widget.phoneNumber);
          Get.offAll(() => NavigationScreen());
        },
        verificationFailed: (FirebaseAuthException e) {
          print('in verification failed');
          hudController.updateHud(false);
          print(e.message);
        },
        codeSent: (String? verificationId, int? resendToken) {
          setState(() {
            print('in codesent--------');
            _forceResendingToken = resendToken!;
            print(_forceResendingToken);
            _verificationCode = verificationId!;
            print(_verificationCode);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('in auto retrieval timeout');
          if (mounted) {
            hudController.updateHud(false);
            timerController.cancelTimer();
            setState(() {
              _verificationCode = verificationId;
            });
          }
        },
        timeout: Duration(seconds: 60));
    // } catch (e) {
    //   hudController.updateHud(false);
    // }
  }

  // WEB SIGN IN (WEB OTP AUTHENTICATION) FUNCTION -------------------------------------------

  void _verifyPhoneNum_web() async {
    try {
      print('in verify phone WEB VERSION');
      print(widget.phoneNumber);
      print(widget.phoneNumber.runtimeType);
      FirebaseAuth auth = FirebaseAuth.instance;

      ConfirmationResult result =
          await auth.signInWithPhoneNumber('+91${widget.phoneNumber}');
      setState(() {
        print('in codesent');
        temp = result;
        print("$_verificationCode--------------");
      });
    } catch (e) {
      print("ERROR------------$e");
      hudController.updateHud(false);
    }
  }

// ---------------------------------------
} // class end
