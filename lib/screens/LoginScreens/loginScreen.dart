import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/LoginScreens/otpVerificationScreen.dart';
import 'package:liveasy/widgets/phoneNumberTextField.dart';
// import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../../widgets/webHeader.dart';
import '../../widgets/webLoginLeftPart.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  HudController hudController = Get.put(HudController());
  TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  bool isError = false;
  bool size = true;

  void initState() {
    super.initState();
    hudController.updateHud(
        false); // so that if user press the back button in between verification verifying stop
    // getLocationPermission();
  }

  //
  // PermissionStatus? permission1;
  // Position? userPosition;
  //
  // getLocationPermission() async {
  //   await LocationPermissions().requestPermissions();
  //   permission1 = await LocationPermissions().checkPermissionStatus();
  //   // userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   // final coordinates = new Coordinates(userPosition!.latitude, userPosition!.longitude);
  //   // var addresses =
  //   //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   // var first = addresses.first;
  //   // print(first.addressLine);
  // }

  @override
  Widget build(BuildContext context) {
    // if (permission1 == PermissionStatus.denied ||
    //     permission1 == PermissionStatus.restricted) {
    //   //return LocationDisabledScreen();
    // }
    ProviderData providerData = Provider.of<ProviderData>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: (kIsWeb && Responsive.isDesktop(context))
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
                                        const WebHeader(),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: screenHeight * 0.04,
                                                left: screenWidth * 0.03),
                                            child: Text(
                                                "Efficiency at your finger tips",
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w400,
                                                    color: blueTitleColor,
                                                    fontSize: size_11)),
                                          ),
                                        ),
                                        //TODO : Phone Number text field title
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: screenWidth * 0.07,
                                                  top: screenHeight * 0.07),
                                              child: Text(
                                                'Phone Number',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 25,
                                                  color: blueTitleColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        //TODO : Email text field
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenHeight * 0.05,
                                              right: screenWidth * 0.05),
                                          child: Container(
                                            width: size
                                                ? screenWidth * 0.3
                                                : screenWidth * 0.03,
                                            child: TextFormField(
                                              onChanged: (_controller) {
                                                if (_controller.length == 10) {
                                                  providerData
                                                      .updateInputControllerLengthCheck(
                                                          true);
                                                  providerData
                                                      .updateButtonColor(
                                                          activeButtonColor);
                                                } else {
                                                  providerData
                                                      .updateInputControllerLengthCheck(
                                                          false);
                                                  providerData
                                                      .updateButtonColor(
                                                          deactiveButtonColor);
                                                }
                                                providerData
                                                    .updatePhoneController(
                                                        _controller);
                                              },
                                              controller: _controller,
                                              inputFormatters: <TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              maxLength: 10,
                                              validator: (value) =>
                                                  value!.length == 10
                                                      ? null
                                                      : 'EnterPhoneNumber'.tr,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                disabledBorder:
                                                    InputBorder.none,
                                                filled: true,
                                                fillColor: white,
                                                hintText: 'EnterPhoneNumber'.tr,
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                        color: borderLightColor,
                                                        fontSize: size_7),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //TODO : Sign In button
                                        Container(
                                          width: size
                                              ? screenWidth * 0.2
                                              : screenWidth * 0.05,
                                          height: size ? space_10 : space_4,
                                          margin: EdgeInsets.only(
                                              top: screenHeight * 0.09,
                                              right: screenWidth * 0.05),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    providerData.buttonColor,
                                              ),
                                              child: Text(
                                                'sendOtp'.tr,
                                                // 'Send OTP',
                                                style: TextStyle(
                                                  color: white,
                                                  fontSize:
                                                      size ? size_9 : size_2,
                                                ),
                                              ),
                                              onPressed: providerData
                                                      .inputControllerLengthCheck
                                                  ? () {
                                                      print(
                                                          "${providerData.phoneController}----------------------------");
                                                      Get.to(() =>
                                                          NewOTPVerificationScreen(
                                                              providerData
                                                                  .phoneController));
                                                      providerData.clearAll();
                                                    }
                                                  : () {}),
                                        )
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
          : Stack(
              children: [
                // OrangeCurve(),
                // GreenCurve(),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: space_7),
                              child: Text(
                                'welcomeTo'.tr,
                                // 'Welcome To Liveasy',
                                style: TextStyle(
                                  fontSize: size_10,
                                  fontWeight: boldWeight,
                                  color: black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  space_0, space_3, space_0, space_6),
                              child: Text(
                                '6-digitOtp'.tr,
                                // 'A 6-digit OTP will be sent via SMS to verify \n your number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: regularWeight,
                                  fontSize: size_6,
                                  color: lightNavyBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: space_9, right: space_9),
                              child: Form(
                                key: _formKey,
                                child: PhoneNumberTextField(),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: space_9,
                              margin: EdgeInsets.fromLTRB(
                                  space_8, space_11, space_8, space_0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(space_10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: providerData.buttonColor,
                                    ),
                                    child: Text(
                                      'sendOtp'.tr,
                                      // 'Send OTP',
                                      style: TextStyle(
                                        color: white,
                                      ),
                                    ),
                                    onPressed:
                                        providerData.inputControllerLengthCheck
                                            ? () {
                                                print(
                                                    "${providerData.phoneController}----------------------------------");
                                                Get.to(() =>
                                                    NewOTPVerificationScreen(
                                                        providerData
                                                            .phoneController));

                                                //null safety error here , needs to be resolved
                                                // if (_formKey.currentState!.validate()) {
                                                //   Get.to(() => NewOTPVerificationScreen(
                                                //       providerData.phoneController));

                                                providerData.clearAll();
                                              } // if

                                            : () {}),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
