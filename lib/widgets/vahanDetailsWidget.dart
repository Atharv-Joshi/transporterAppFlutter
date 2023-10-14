import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/spaces.dart';

class VahanDetailsWidget extends StatelessWidget {
  final String title1; //left side title
  final String text1; //left side text
  final String title2; // right side title
  final String text2; //right side text
  final String? text3; // right side text used for vehicle class and body type
  final bool isText1Bold;
  final Color text1Color;
  final bool isText2Bold;
  final Color text2Color;

  VahanDetailsWidget({
    required this.title1,
    required this.text1,
    required this.title2,
    required this.text2,
    this.text3,
    this.isText1Bold = false,
    this.text1Color = Colors.black,
    this.isText2Bold = false,
    this.text2Color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    TextStyle textStyle(bool isBold, Color color) {
      return TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: space_1,
            bottom: space_1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title1,
                    ),
                    Text(
                      text1,
                      style: textStyle(isText1Bold, text1Color),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: width * 0.03),
                width: width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title2,
                    ),
                    Text(
                      text2,
                      style: textStyle(isText2Bold, text2Color),
                    ),
                    if (text3 != null)
                      Text(
                        text3!,
                        style: textStyle(isText2Bold, text2Color),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(2, space_1, 2, space_2),
          child: Container(
            color: black,
            width: width,
            height: 0.5,
          ),
        ),
      ],
    );
  }
}
