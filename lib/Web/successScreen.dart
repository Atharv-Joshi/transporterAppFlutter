import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/screens/navigationScreen.dart';

import '../constants/color.dart';
import '../controller/transporterIdController.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({
    super.key,
  });

  // TransporterIdController transporterIdController =
  //     Get.put(TransporterIdController(), permanent: true);
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
                  image: AssetImage("assets/images/successScreen.png"))),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.25),
          child: Text("Successful!!!",
              style: TextStyle(
                fontSize: 40,
                color: continueButton,
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
                backgroundColor: continueButton,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
                    MediaQuery.of(context).size.height * 0.07),
              ),
              onPressed: () {
                Get.offAll(NavigationScreen());
              },
              child: Text(
                'Continue',
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
