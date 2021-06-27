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
            SizedBox(height: space_4),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: space_4),
              BackButtonWidget(),
              SizedBox(width: space_3),
              HeadingTextWidget("Suggested Loads"),
              SizedBox(width: space_6),
              FilterButtonWidget(),
            ]),
            SizedBox(
              height: space_4,
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                  space_4 -
                  space_4 -
                  space_6 -
                  space_3),
              color: backgroundColor,
              margin: EdgeInsets.only(bottom: space_3),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: space_4),
                itemCount: widget.suggestedLoadData.length,
                itemBuilder: (BuildContext context, index) =>
                    LoadApiDataDisplayCard(
                  loadId: widget.suggestedLoadData[index].loadId,
                  loadingPointState:
                      widget.suggestedLoadData[index].loadingPointState,
                  loadingPointCity:
                      widget.suggestedLoadData[index].loadingPointCity,
                  unloadingPointState:
                      widget.suggestedLoadData[index].unloadingPointState,
                  unloadingPointCity:
                      widget.suggestedLoadData[index].unloadingPointCity,
                  productType: widget.suggestedLoadData[index].productType,
                  truckType: widget.suggestedLoadData[index].truckType,
                      postLoadId: widget.suggestedLoadData[index].postLoadId,
                  noOfTrucks: widget.suggestedLoadData[index].noOfTrucks,
                  weight: widget.suggestedLoadData[index].weight,
                  status: widget.suggestedLoadData[index].status,
                  comment: widget.suggestedLoadData[index].comment,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
