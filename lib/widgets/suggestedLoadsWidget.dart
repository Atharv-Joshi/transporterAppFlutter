import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/suggestedLoadsApi.dart';
import 'package:liveasy/widgets/bodyTextWidget.dart';
import 'package:liveasy/widgets/suggestedLoadDataDisplayCard.dart';

class SuggestedLoadsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space_2), color: darkBlueColor),
      child: Column(
        children: [
          Container(
            height: space_8,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: borderWidth_10,
                  color: lightGreyishBlueColor,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: space_3), //28
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyTextWidget(
                      text: "Suggested Loads", color: greyishWhiteColor),
                  BodyTextWidget(text: "See All", color: liveasyGreenColor),
                ],
              ),
            ),
          ),
          Container(
            child: FutureBuilder(
              future: runSuggestedLoadApi(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return Container(
                  height: 106,
                  width: 309,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length >= 10? 10 : snapshot.data.length,
                      itemBuilder: (context, index) =>
                          SuggestedLoadDataDisplayCard(
                              loadingPointCity: snapshot.data[index]
                                  .loadingPointCity,
                              unloadingPointCity: snapshot
                                  .data[index].unloadingPointCity,
                              onTap: () {})),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
