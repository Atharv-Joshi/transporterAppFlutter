import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

import '../responsive.dart';

// ignore: must_be_immutable
class ElevatedButtonWidgetTwo extends StatelessWidget {
  final bool condition;
  final String text;
  var onPressedConditionTrue;

  ElevatedButtonWidgetTwo(
      {required this.condition,
      required this.text,
      required this.onPressedConditionTrue});

  @override
  Widget build(BuildContext context) {
    return (kIsWeb && (Responsive.isDesktop(context)))
        ? Container(
            padding: EdgeInsets.only(top: space_4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(space_1),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        condition ? activeButtonColor : deactiveButtonColor,
                  ),
                  child: Container(
                    height: space_10,
                    width: space_20,
                    child: Center(
                      child: Text(
                        text,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: condition ? onPressedConditionTrue : null,
                )),
          )
        : Container(
            padding: EdgeInsets.only(top: space_4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(space_5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        condition ? activeButtonColor : deactiveButtonColor,
                  ),
                  child: Container(
                    height: space_10,
                    width: space_34,
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                            color: white,
                            fontSize: size_11,
                            fontWeight: mediumBoldWeight),
                      ),
                    ),
                  ),
                  onPressed: condition ? onPressedConditionTrue : null,
                )),
          );
  }
}
