import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/okButton.dart';

class OrderFailedAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                image: AssetImage("assets/images/alert.png"),
                width: space_22,
                height: space_22,
              ),
              Text(
                "Something went Wrong.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight, fontSize: size_8, color: red),
              ),
              Text(
                "Please Try Again!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight, fontSize: size_8, color: red),
              ),
              OkButton()
            ],
          )),
    );
  }
}
