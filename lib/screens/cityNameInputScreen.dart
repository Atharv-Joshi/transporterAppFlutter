import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/tokenMMIController.dart';
import 'package:liveasy/functions/autoFillMMI.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/widgets/backButtonWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/textFieldWidget.dart';

class CityNameInputScreen extends StatefulWidget {
  final String valueType;

  CityNameInputScreen(this.valueType);

  @override
  _CityNameInputScreenState createState() => _CityNameInputScreenState();
}

class _CityNameInputScreenState extends State<CityNameInputScreen> {
  TokenMMIController tokenMMIController = Get.put(TokenMMIController());
  var locationCard;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: ListView(
          children: [
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
                  HelpButtonWidget()
                ],
              ),
            ),
            SizedBox(
              height: smallMediumSpace,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: smallSpace),
              child: TextFieldWidget(
                onChanged: (String value) {
                  setState(() {
                    locationCard = fillCityName(value);
                  });
                },
                controller: controller,
                hintText: "Enter City Name",
              ),
            ),
            locationCard == null
                ? Container()
                : SizedBox(
                    height: smallMediumSpace,
                  ),
            locationCard != null
                ? Container(
                    color: backgroundColor,
                    height: 600, //TODO: to be modified
                    child: FutureBuilder(
                        future: locationCard,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                              reverse: false,
                              padding: EdgeInsets.symmetric(
                                horizontal: verySmallSpace,
                              ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => buildCard(
                                    snapshot.data[index].placeName,
                                    snapshot.data[index].placeAddress,
                                  ));
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildCard(String placeName, String placeAddress) {
    return GestureDetector(
      onTap: () {
        setState(() {
          locationCard = null;
          controller =
              TextEditingController(text: '$placeName ($placeAddress)');
        });
        if (widget.valueType == "loading point") {
          Get.off(FindLoadScreen(),
              arguments: {"loading point": "$placeName ($placeAddress)"});
        } else if (widget.valueType == "unloading point") {
          Get.off(FindLoadScreen(),
              arguments: {"unloading point": "$placeName ($placeAddress)"});
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: minutelySmallSpace),
        child: Material(
          elevation: 4,
          child: Container(
            color: white,
            padding: EdgeInsets.all(minutelySmallSpace),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.location_on),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '$placeName',
                        style: TextStyle(fontSize: xxxlSize),
                      ),
                    ),
                    Container(
                      child: Text(
                        '($placeAddress)',
                        style: TextStyle(fontSize: xlSize),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
