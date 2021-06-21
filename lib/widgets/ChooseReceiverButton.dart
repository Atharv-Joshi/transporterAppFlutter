import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class ChooseReceiverButton extends StatelessWidget {
  final String label;
  final dynamic function ;

  ChooseReceiverButton({required this.label , required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 163,
      height: 40,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: darkBlueColor),
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: space_1),
              child: Image(
                height: 16,
                width: 11,
                image:AssetImage(
                  'assets/icons/callButtonIcon.png',
                ),
              ),
            ),
            Text(
              '$label',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.7,
                fontWeight: mediumBoldWeight,
                color: bidBackground,
                fontSize: size_8,
              ),
            ),
          ],
        ),
        onPressed: function,
      ),
    );
  }
}
