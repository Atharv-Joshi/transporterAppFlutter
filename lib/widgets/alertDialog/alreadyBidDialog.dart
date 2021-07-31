import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/alertOkButton.dart';

class AlreadyBidDialog extends StatelessWidget {
  const AlreadyBidDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You have already bid on this Load",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8,
                    color: liveasyBlackColor),
              ),
              SizedBox(height: space_4),
              AlertOkButton()
            ],
          )),
    );
  }
}
