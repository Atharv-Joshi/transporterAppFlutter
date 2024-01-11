import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadPointTemplateForBidScreen extends StatelessWidget {
  final String? endPointType;
  String? text;

  LoadPointTemplateForBidScreen(
      {required this.text, required this.endPointType});

  @override
  Widget build(BuildContext context) {
    if (text!.length > 20) {
      text = text!.substring(0, 19) + '..';
    }
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: space_1),
          child: Image(
              height: 20,
              width: 20,
              image: endPointType == 'loading'
                  ? AssetImage('assets/icons/loadGreenMark.png')
                  : AssetImage('assets/icons/loadRedMark.png')),
        ),
        Text(
          '$text'.tr,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
