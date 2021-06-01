import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class CallButtonReal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: darkBlueColor),
          )),
        ),
        onPressed: (){print('Call Button Pressed');},
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: space_1),
              child: Icon(
                  Icons.call,
                  size: 20,
                  color: black ,
              ),
            ),
            Text(
              'Call',
              style: TextStyle(
                letterSpacing: 0.7,
                fontWeight: mediumBoldWeight,
                color: Colors.black,
                fontSize: space_3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

