import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';

class HelpButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Text(
                "HELP",
                style: TextStyle(fontSize: mediumLargeSize, color: lightBlue),
              ),
              SizedBox(
                width: 2,
              ),
              Image.asset("assets/icons/helpIcon.png"),
            ],
          ),
        ),
      ),
    );
  }
}
