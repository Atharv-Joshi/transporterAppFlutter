import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenTwo.dart';

class CompletedTextField extends StatefulWidget {
  const CompletedTextField({Key? key}) : super(key: key);

  @override
  _CompletedTextFieldState createState() => _CompletedTextFieldState();
}

class _CompletedTextFieldState extends State<CompletedTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(space_3, space_0, space_0, space_0),
      height: space_8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: borderWidth_8),
        color: widgetBackGroundColor,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Others",
        ),
      ),
    );
  }
}
