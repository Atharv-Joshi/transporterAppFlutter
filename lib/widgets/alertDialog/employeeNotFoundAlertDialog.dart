import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/alertOkButton.dart';

class EmployeeNotFoundDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          height: MediaQuery.of(context).size.height / 3.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage("assets/images/alert.png"),
                width: space_10,
                height: space_10,
              ),
              SizedBox(height: space_4),
              Text(
                "Employee Not Found.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: normalWeight, fontSize: size_8, color: red),
              ),
              SizedBox(height: space_3),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: AlertOkButton(),
              )
            ],
          )),
    );
  }
}
