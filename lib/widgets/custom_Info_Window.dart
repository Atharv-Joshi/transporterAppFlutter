import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';

class customInfoWindow extends StatelessWidget {
  final String duration;
  final String stoppageTime;
  final String stopAddress;

  const customInfoWindow(
      {Key? key,
      required this.duration,
      required this.stoppageTime,
      required this.stopAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.7),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(stopAddress,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: white)),
          Text(duration,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: white)),
          Text(stoppageTime,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: white)),
        ],
      ),
    );
  }
}
