import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/bonusWidget.dart';
import 'package:liveasy/widgets/buyGpsWidget.dart';
import 'package:liveasy/widgets/drawerWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/referAndEarnWidget.dart';
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
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Icon(
                          Icons.list,
                          size: space_6,
                        ),
                      ),
                      SizedBox(
                        width: space_2,
                      ),
                      LiveasyTitleTextWidget(),
                    ],
                  ),
                  HelpButtonWidget()
                ],
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(space_0, space_4, space_0, space_5),
                child: SearchLoadWidget("Search"),
              ),
              SuggestedLoadsWidget(),
              SizedBox(height: space_4,),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ReferAndEarnWidget(height: 100, width: 180),
                    SizedBox(width: space_4,),
                    BuyGpsWidget(height: 100, width: 180,),
                    SizedBox(width: space_4,),
                    BonusWidget(height: 100, width: 180,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
