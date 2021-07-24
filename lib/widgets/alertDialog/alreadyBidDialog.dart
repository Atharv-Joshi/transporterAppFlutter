import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

class AlreadyBidDialog extends StatelessWidget {
  const AlreadyBidDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "You have already bid on this Load",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_15,
                    color: liveasyBlackColor),
              ),
            ],
          )),
    );
  }
}
