import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class DeclineButton extends StatelessWidget {
  const DeclineButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size_10),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size_10)),
          elevation: size_4,
          color: Colors.red,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(size_7, size_5, size_7, size_5),
              child: Text(
                "Decline",
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_6,
                    color: backgroundColor,
                    fontFamily: "Montserrat"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
