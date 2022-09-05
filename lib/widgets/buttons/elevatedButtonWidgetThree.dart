import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class ElevatedButtonWidgetThree extends StatelessWidget {
  final bool condition;
  final String text;
  var onPressedConditionTrue;

  ElevatedButtonWidgetThree(
      {required this.condition,
      required this.text,
      required this.onPressedConditionTrue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50, left: 10, right: 10),
      padding: EdgeInsets.only(top: space_4),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  condition ? activeButtonColor : deactiveButtonColor,
            ),
            child: Container(
              height: space_17,
              width: space_45 + 80,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: white,
                      fontSize: size_12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onPressed: condition ? onPressedConditionTrue : null,
          )),
    );
  }
}
