import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/responsive.dart';
//TryAgain screens for showing error and retyring
class TryAgain extends StatelessWidget {
  final VoidCallback retryCallback;
  const TryAgain({super.key, required this.retryCallback});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    return Scaffold(
        backgroundColor: white,
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: isMobile ? screenHeight * 0.02 : 0,
                      left: isMobile ? screenWidth * 0.04 : 0),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: skyBlue,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin:
                      EdgeInsets.only(top: isMobile ? screenHeight * 0.15 : 0),
                  color: Colors.amberAccent,
                  child: Image.asset('assets/images/tryAgain.png',
                      height:
                          isMobile ? screenHeight * 0.4 : screenHeight * 0.72),
                ),
              ),
              Center(
                child: Text('Something went wrong!!!',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: skyBlue,
                        fontSize: isMobile
                            ? screenHeight * 0.035
                            : screenWidth * 0.02)),
              ),
              const SizedBox(height: 10),
              Center(
                child: InkWell(
                  hoverColor: skyBlue,
                  focusColor: darkBlueTextColor,
                  highlightColor: okButtonColor,
                  onTap: retryCallback,
                  child: Container(
                      height: screenHeight * 0.04,
                      width: isMobile ? screenWidth * 0.3 : screenWidth * 0.075,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(
                            color: skyBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Try again',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: skyBlue,
                            fontSize: isMobile
                                ? screenWidth * 0.04
                                : screenHeight * 0.02),
                      )),
                ),
              )
            ])));
  }
}
