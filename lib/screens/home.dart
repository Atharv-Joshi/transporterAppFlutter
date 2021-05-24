import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/constants/color.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  String searchedLoad = "";

  void onChanged(String value) {
    searchedLoad = value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SizedBox(
              height: smallSpace,
            ),
            LiveasyTitleTextWidget(),
            SizedBox(
              height: smallMediumSpace - 2,
              // Want To Ask IF doing this contradicts the logic of using a seperate file of spaces
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: smallSpace,
              ),
              child: SearchLoadWidget("Search Load"),
            ),
            SizedBox(
              height: mediumSpace,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: mediumLargeSpace), //28
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Suggested Loads",
                    style: TextStyle(
                        fontSize: mediumLargeSize,
                        fontWeight: normalWeight,
                        color: grey),
                  ),
                  Text(
                    "see more",
                    style: TextStyle(
                      fontSize: mediumSize,
                      fontWeight: regularWeight,
                      color: grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
