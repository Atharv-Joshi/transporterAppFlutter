import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class TrackButton extends StatelessWidget {
  bool truckApproved = false;

  TrackButton({required this.truckApproved});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
      ),
      onPressed: () {
        print('Track button pressed');
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(
                  space_5,
                  size_1,
                  space_5,
                  size_1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                        height: 16,
                        width: 23,
                        color: white,
                        image: AssetImage('assets/icons/lockIcon.png')),
                    Text(
                      'Track',
                      style: TextStyle(
                        letterSpacing: 0.7,
                        fontWeight: normalWeight,
                        color: white,
                        fontSize: size_7,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
