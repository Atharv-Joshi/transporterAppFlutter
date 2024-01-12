import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';

//this table header will be used for showing the ongoing details on web
// ignore: non_constant_identifier_names
Container LoadsTableHeader(
    {required String loadingStatus, required double screenWidth}) {
  bool small = true;
  double textFontSize;
  if (screenWidth < 1400 && screenWidth > 1099) {
    small = true;
  } else {
    small = false;
  }

  if (small) {
    textFontSize = 10;
  } else {
    textFontSize = 14;
  }

  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: lightBlueTable,
      boxShadow: const [
        BoxShadow(color: lightGrey, blurRadius: 5, offset: Offset(0, 5)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 3,
            child: Center(
                child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      (loadingStatus == 'MyLoads')
                          ? "Scheduled\nDate & Time"
                          : "Booking\nOn",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: textFontSize,
                      ),
                    )))),
        VerticalDivider(color: Colors.grey, thickness: 1),
        Expanded(
            flex: 5,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Image(
                    image: AssetImage('assets/icons/greenFilledCircleIcon.png'),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Text(
                    "Loading\nPoint",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: black,
                      fontWeight: FontWeight.w600,
                      fontSize: textFontSize,
                    ),
                  ))
                ]))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 5,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Image(
                    image: AssetImage('assets/icons/red_circle.png'),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Text(
                    "Unloading\nPoint",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: black,
                      fontWeight: FontWeight.w600,
                      fontSize: textFontSize,
                    ),
                  ))
                ]))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: (loadingStatus == 'MyLoads') ? 4 : 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads')
                  ? "Truck Type /\nNo. of Tyres"
                  : "Truck\nNumber",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: black,
                fontWeight: FontWeight.w600,
                fontSize: textFontSize,
              ),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads')
                  ? "Product Type /\nWeight"
                  : "Driver's\nName",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: black,
                fontWeight: FontWeight.w600,
                fontSize: textFontSize,
              ),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads') ? "Publishing\nMethod" : "Freight",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: black,
                fontWeight: FontWeight.w600,
                fontSize: textFontSize,
              ),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              (loadingStatus == 'MyLoads') ? "Status" : 'Transporter',
              style: GoogleFonts.montserrat(
                color: black,
                fontWeight: FontWeight.w600,
                fontSize: textFontSize,
              ),
            ))),
        VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
        Expanded(flex: 4, child: Container()),
      ],
    ),
  );
}
