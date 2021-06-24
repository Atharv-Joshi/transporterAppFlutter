import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';
import 'package:liveasy/functions/suggestedLoadsApi.dart';
import 'package:liveasy/screens/SuggestedLoadsScreen.dart';
import 'package:liveasy/widgets/bodyTextWidget.dart';
import 'package:liveasy/widgets/suggestedLoadDataDisplayCard.dart';

// ignore: must_be_immutable
class SuggestedLoadsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space_2), color: darkBlueColor),
      child: FutureBuilder(
          future: runSuggestedLoadApi(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Column(children: [
                Container(
                    height: space_8 + 2,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: borderWidth_10,
                          color: lightGreyishBlueColor,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: space_3),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyTextWidget(
                                text: "Suggested Loads",
                                color: greyishWhiteColor),
                            BodyTextWidget(
                                text: "See All", color: liveasyGreenColor)
                          ]),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 30),
                    child: CircularProgressIndicator(color: white))
              ]);
            } else {
              return Column(children: [
                Container(
                  height: space_8 + 2,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: borderWidth_10,
                        color: lightGreyishBlueColor,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: space_3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BodyTextWidget(
                              text: "Suggested Loads",
                              color: greyishWhiteColor),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Get.to(() => SuggestedLoadScreen(
                                  suggestedLoadData: snapshot.data));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(color: liveasyGreenColor),
                            ),
                          ),
                        ]),
                  ),
                ),
                Container(
                  height: 106,
                  width: 309,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        snapshot.data.length >= 10 ? 10 : snapshot.data.length,
                    itemBuilder: (context, index) =>
                        SuggestedLoadDataDisplayCard(
                            loadingPointCity:
                                snapshot.data[index].loadingPointCity,
                            unloadingPointCity:
                                snapshot.data[index].unloadingPointCity,
                            onTap: () {
                              Get.to(
                                () => SuggestedLoadScreen(
                                  suggestedLoadData: snapshot.data
                                      .getRange(index, snapshot.data.length)
                                      .toList(),
                                ),
                              );
                            }),
                  ),
                ),
              ]);
            }
          }),
    );
  }
}
