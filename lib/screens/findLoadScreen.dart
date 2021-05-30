import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/cancelIconWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/widgets/addressInputWidget.dart';
import 'package:liveasy/widgets/backButtonWidget.dart';

class FindLoadScreen extends StatefulWidget {
  @override
  _FindLoadScreenState createState() => _FindLoadScreenState();
}

class _FindLoadScreenState extends State<FindLoadScreen> {

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (Provider.of<ProviderData>(context).loadingPointCity != "") {
      controller1 = TextEditingController(
          text:
              ("${Provider.of<ProviderData>(context, listen: false).loadingPointCity} (${Provider.of<ProviderData>(context, listen: false).loadingPointState})"));
    }
    if (Provider.of<ProviderData>(context).unloadingPointCity != "") {
      controller2 = TextEditingController(
          text:
              ("${Provider.of<ProviderData>(context, listen: false).unloadingPointCity} (${Provider.of<ProviderData>(context, listen: false).unloadingPointState})"));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: space_4),
          child: Column(children: [
            SizedBox(
              height: space_8,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonWidget(),
                      SizedBox(
                        width: space_3,
                      ),
                      HeadingTextWidget("Find Load"),
                      // HelpButtonWidget(),
                    ],
                  ),
                  HelpButtonWidget(),
                ],
              ),
            ),
            SizedBox(
              height: space_5,
            ),
            AddressInputWidget(
              hintText: "Loading Point",
              icon: LoadingPointImageIcon(
                height: 12,
                width: 12,
              ),
              controller: controller1,
              clearIcon: IconButton(
                onPressed: () {
                  Provider.of<ProviderData>(context, listen: false)
                      .clearLoadingPoint();
                },
                icon: CancelIconWidget(),
              ),
            ),
            SizedBox(
              height: space_4,
            ),
            AddressInputWidget(
              hintText: "Unloading Point",
              icon: UnloadingPointImageIcon(
                height: 12,
                width: 12,
              ),
              controller: controller2,
              clearIcon: IconButton(
                onPressed: () {
                  Provider.of<ProviderData>(context, listen: false)
                      .clearUnloadingPoint();
                },
                icon: CancelIconWidget(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}