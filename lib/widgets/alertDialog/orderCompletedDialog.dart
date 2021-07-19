import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class OrderCompletedDialog extends StatefulWidget {
  const OrderCompletedDialog({Key? key}) : super(key: key);

  @override
  _OrderCompletedDialogState createState() => _OrderCompletedDialogState();
}

class _OrderCompletedDialogState extends State<OrderCompletedDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.network(
                "https://cdn.dribbble.com/users/2185205/screenshots/7886140/02-lottie-tick-01-instant-2.gif",
                width: space_22,
                height: space_22,
              ),
              Text(
                "Congratulations!",
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8,
                    color: liveasyBlackColor),
              ),
              Text(
                "You have completed your order!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: mediumBoldWeight,
                    fontSize: size_8,
                    color: liveasyBlackColor),
              ),
            ],
          )),
    );
  }
}
