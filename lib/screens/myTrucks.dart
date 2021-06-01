import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//constants
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addTruckButton.dart';
//widgets
import 'package:liveasy/widgets/backButtonWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';

class MyTrucks extends StatefulWidget {
  const MyTrucks({Key? key}) : super(key: key);

  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_8, space_4, space_4),
        child: Column(
          children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButtonWidget(),
                    SizedBox(
                      width: space_3,
                    ),
                    HeadingTextWidget("My Trucks"),
                    // HelpButtonWidget(),
                  ],
                ),
                HelpButtonWidget(),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: space_3
              ),
                //TODO: make search widget dynamic
                child: SearchLoadWidget('Search')),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyTruckCard(),
                    MyTruckCard(),
                    MyTruckCard()
                  ],
                ),
              ),
            ),
            AddTruckButton(),
          ],
        ),
      ),
    );
  }


}
