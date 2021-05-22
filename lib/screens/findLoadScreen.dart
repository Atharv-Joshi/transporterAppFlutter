import 'package:flutter/material.dart';
import 'package:liveasy/widgets/addressInputWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';

class FindLoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: 14,
          ),
          LiveasyTitleTextWidget(),
          SizedBox(
            height: 18,
          ),
          AddressInputWidget(
            "Loading Point",
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10),
              child: Image.asset("assets/icons/circleIcon.png"),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          AddressInputWidget(
            "Unloading Point",
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Image.asset("assets/icons/rectangleIcon.png"),
            ),
          ),

        ]),
      ),
    );
  }
}
