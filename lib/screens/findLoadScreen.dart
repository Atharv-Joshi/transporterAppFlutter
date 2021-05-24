import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addressInputWidget.dart';
import 'package:liveasy/widgets/backButtonWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';

class FindLoadScreen extends StatefulWidget {
  @override
  _FindLoadScreenState createState() => _FindLoadScreenState();
}

class _FindLoadScreenState extends State<FindLoadScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments["loading point"] != null) {
        controller1 = TextEditingController(
            text: (Get.arguments["loading point"].toString()));
      }
      if (Get.arguments["unloading point"] != null) {
        controller2 = TextEditingController(
            text: (Get.arguments["unloading point"].toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: smallSpace,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: smallSpace),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(),
                LiveasyTitleTextWidget(),
                HelpButtonWidget(),
              ],
            ),
          ),
          SizedBox(
            height: smallMediumSpace - 2,
          ),
          AddressInputWidget(
              "Loading Point",
              Padding(
                padding: EdgeInsets.only(top: 3, left: 13),
                child: Image.asset("assets/icons/circleIcon.png"),
              ),
              controller1,
              "loading point"),
          SizedBox(
            height: minutelySmallSpace,
          ),
          AddressInputWidget(
              "Unloading Point",
              Padding(
                padding: EdgeInsets.only(top: 3, left: 13),
                child: Image.asset("assets/icons/rectangleIcon.png"),
              ),
              controller2,
              "unloading point"),
        ]),
      ),
    );
  }
}
