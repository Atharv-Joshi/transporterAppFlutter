import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/drawerWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/widgets/suggestedLoadsWidget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchedLoad = "";

  void onChanged(String value) {
    searchedLoad = value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        backgroundColor: backgroundColor,
        body: ListView(
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_3),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Icon(
                          Icons.list,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: space_2,),
                      LiveasyTitleTextWidget(),
                    ],
                  ),
                  HelpButtonWidget()
                ],
              ),
            ),
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
