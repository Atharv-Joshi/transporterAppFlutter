import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadEndPointTemplateWeb extends StatelessWidget {
  final String? endPointType;
  String? text;

  LoadEndPointTemplateWeb({required this.text, required this.endPointType});

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
              height: 10,
              width: 10,
              image: endPointType == 'loading'
                  ? AssetImage('assets/icons/greenFilledColorSmall.png')
                  : AssetImage('assets/icons/redFilledCircle.png')),
        ),
        Text(
          '$text'.tr,
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: size_8,
            fontWeight: mediumBoldWeight,
          ),
        ),
      ],
    );
  }
}
