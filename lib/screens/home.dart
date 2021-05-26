import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/widgets/suggestedLoadsWidget.dart';

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
        backgroundColor: backgroundColor,
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SizedBox(
              height: space_6,
            ),
            LiveasyTitleTextWidget(),
            SizedBox(
              height: space_4,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: space_4,
              ),
              child: SearchLoadWidget("Search"),
            ),
            SizedBox(
              height: space_5,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: space_4),
                child: SuggestedLoadsWidget()),

          ],
        ),
      ),
    );
  }
}
