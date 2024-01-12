import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

// ignore: non_constant_identifier_names
Container AuctionHeader(context) {
  bool small = true;
  double leftRightPadding, textFontSize, containerWidth;
  var screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 1400 && screenWidth > 1099) {
    small = true;
  } else {
    small = false;
  }

  if (small) {
    leftRightPadding = 0;
    textFontSize = 12;
    containerWidth = 56;
  } else {
    leftRightPadding = 20;
    textFontSize = 16;
    containerWidth = 100;
  }
  //Header which has fixed attributes.
  return Container(
    height: 70,
    decoration: const BoxDecoration(
        color: Color(0xfff2f5ff),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: size_8,
                        color: Colors.black,
                        fontWeight: mediumBoldWeight,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: greyDivider,
            thickness: 1,
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'Truck Type',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: size_8,
                        color: Colors.black,
                        fontWeight: mediumBoldWeight,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: greyDivider,
            thickness: 1,
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'Product Type/Weight',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: size_8,
                        color: Colors.black,
                        fontWeight: mediumBoldWeight,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: greyDivider,
            thickness: 1,
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        'Route',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: size_8,
                          color: Colors.black,
                          fontWeight: mediumBoldWeight,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: greyDivider,
            thickness: 1,
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'Bid Price',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: size_8,
                        color: Colors.black,
                        fontWeight: mediumBoldWeight,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: greyDivider,
            thickness: 1,
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  'Bid',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: size_8,
                    color: Colors.black,
                    fontWeight: mediumBoldWeight,
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    ),
  );

  // return Container(
  //   height: 70,
  //   decoration: const BoxDecoration(
  //       color: Color(0xfff2f5ff),
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(10), topRight: Radius.circular(10))),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Expanded(
  //           flex: 23,
  //           child: Center(
  //               child: Text(
  //             'Date',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.montserrat(
  //               color: Colors.black,
  //               fontSize: size_8,
  //               fontWeight: mediumBoldWeight,
  //             ),
  //           ))),
  //       const VerticalDivider(color: greyDivider, thickness: 1),
  //       Expanded(
  //           flex: 29,
  //           child: Center(
  //               child: Text(
  //             'Truck Type',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.montserrat(
  //                 color: Colors.black,
  //                 fontSize: size_8,
  //                 fontWeight: mediumBoldWeight),
  //           ))),
  //       const VerticalDivider(color: greyDivider, thickness: 1),
  //       Expanded(
  //           flex: 23,
  //           child: Center(
  //               child: Text(
  //             'Product Type/Weight',
  //             textAlign: TextAlign.center,
  //             selectionColor: sideBarTextColor,
  //             style: GoogleFonts.montserrat(
  //               color: Colors.black,
  //               fontSize: size_8,
  //               fontWeight: mediumBoldWeight,
  //             ),
  //           ))),
  //       const VerticalDivider(
  //         color: greyDivider,
  //         thickness: 1,
  //       ),
  //       Expanded(
  //           flex: 27,
  //           child: Center(
  //               child: Text(
  //             'Route',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.montserrat(
  //               fontSize: size_8,
  //               color: Colors.black,
  //               fontWeight: mediumBoldWeight,
  //             ),
  //           ))),
  //       const VerticalDivider(
  //         color: greyDivider,
  //         thickness: 1,
  //       ),
  //       Expanded(
  //           flex: 22,
  //           child: Center(
  //               child: Text(
  //             'Bid Price',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.montserrat(
  //               fontSize: size_8,
  //               color: Colors.black,
  //               fontWeight: mediumBoldWeight,
  //             ),
  //           ))),
  //       const VerticalDivider(color: greyDivider, thickness: 1),
  //       Expanded(
  //           flex: 15,
  //           child: Center(
  //               child: Text(
  //             'Bid',
  //             textAlign: TextAlign.center,
  //             style: GoogleFonts.montserrat(
  //               fontSize: size_8,
  //               color: Colors.black,
  //               fontWeight: mediumBoldWeight,
  //             ),
  //           ))),
  //     ],
  //   ),
  // );
}
