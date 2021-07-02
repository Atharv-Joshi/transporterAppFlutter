import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: space_4),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size_10)),
          elevation: size_2,
          color: shareButtonColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(size_7, size_5, size_7, size_5),
              child: Text(
                "Accept",
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
