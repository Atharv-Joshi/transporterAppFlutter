import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';

class WebLoginLeftPart extends StatelessWidget {
  const WebLoginLeftPart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        double maxContainerWidth = screenWidth * 0.5;
        double containerWidth = constraints.maxWidth < maxContainerWidth
            ? constraints.maxWidth
            : maxContainerWidth;
        return Container(
          width: containerWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
              color: white,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/WebLoginImage.png"))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.04),
                      child: Text("Welcome to Liveasy",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: white,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004),
                    Text(
                        "One-stop solution for all your logistics operations.\nSign in to unlock new levels of efficiency, transparency, and success.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            color: white,
                            fontSize: MediaQuery.of(context).size.width * 0.01))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.1),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Elevate your business to new heights of success!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: white,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text("Quality experience on all device",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: white,
                              fontSize: 13))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
