import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/constants/color.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  String searchedLoad = "";

  void onChanged(String value) {
    print(value);
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
              height: 14,
            ),
            LiveasyTitleTextWidget(),
            SizedBox(
              height: 18,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: SearchLoadWidget("Search Load"),
            ),
            SizedBox(
              height: 26,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Suggested Loads",
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500, color: grey),
                  ),
                  Text(
                    "see more",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
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
