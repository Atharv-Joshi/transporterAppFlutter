import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
import 'package:liveasy/widgets/loadDisplayCard.dart';

// ignore: must_be_immutable
class SuggestedLoadScreen extends StatefulWidget {
  var suggestedLoadData;

  SuggestedLoadScreen({Key? key, required this.suggestedLoadData})
      : super(key: key);

  @override
  _SuggestedLoadScreenState createState() => _SuggestedLoadScreenState();
}

class _SuggestedLoadScreenState extends State<SuggestedLoadScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: space_4 - 1),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: space_4),
                  BackButtonWidget(),
                  SizedBox(width: space_3),
                  HeadingTextWidget("Suggested Loads"),
                  SizedBox(width: space_6),
                  FilterButtonWidget(),
                ]),
                SizedBox(
                  height: space_4 - 1,
                ),
                Container(
                  height: widget.suggestedLoadData.length > 3
                      // ignore: todo
                      ? 655 //TODO: Height to be modified
                      : widget.suggestedLoadData.length * 269,
                  color: backgroundColor,
                  padding: EdgeInsets.only(bottom: space_3 + 2),
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: space_4),
                      itemCount: widget.suggestedLoadData.length,
                      itemBuilder: (BuildContext context, index) =>
                          LoadApiDataDisplayCard(
                            loadId: widget.suggestedLoadData[index].loadId,
                            loadingPointState: widget
                                .suggestedLoadData[index].loadingPointState,
                            loadingPointCity: widget
                                .suggestedLoadData[index].loadingPointCity,
                            unloadingPointState: widget
                                .suggestedLoadData[index].unloadingPointState,
                            unloadingPointCity: widget
                                .suggestedLoadData[index].unloadingPointCity,
                            productType:
                                widget.suggestedLoadData[index].productType,
                            truckType:
                                widget.suggestedLoadData[index].truckType,
                            noOfTrucks:
                                widget.suggestedLoadData[index].noOfTrucks,
                            weight: widget.suggestedLoadData[index].weight,
                            status: widget.suggestedLoadData[index].status,
                            comment: widget.suggestedLoadData[index].comment,
                            ordered: false,
                          )),
                ),
              ]),
            )));
  }
}
