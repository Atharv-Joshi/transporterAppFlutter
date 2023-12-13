import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';

import '../constants/color.dart';

class UnSuccessScreen extends StatefulWidget {
  UnSuccessScreen({
    super.key,
  });

  @override
  State<UnSuccessScreen> createState() => _UnSuccessScreenState();
}

class _UnSuccessScreenState extends State<UnSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: screenWidth * 0.25),
          width: screenWidth * 0.5,
          height: screenHeight * 0.8,
          decoration: BoxDecoration(
              color: white,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/unSuccessImage.png"))),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.25),
          child: Text("Oops something went wrong",
              style: TextStyle(
                fontSize: 40,
                color: tryAgainButton,
                fontWeight: FontWeight.w700,
              )),
        ),
        Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.25, top: screenHeight * 0.02),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: tryAgainButton,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                    MediaQuery.of(context).size.height * 0.07),
              ),
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                'Try Again',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
      ],
    ));
  }
}
