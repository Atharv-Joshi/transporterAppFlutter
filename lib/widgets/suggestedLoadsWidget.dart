import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/SuggestedLoadsScreen.dart';
import 'package:liveasy/widgets/bodyTextWidget.dart';
import 'package:liveasy/widgets/homeScreenLoadsCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/loadApiModel.dart';
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class SuggestedLoadsWidget extends StatefulWidget {

  @override
  _SuggestedLoadsWidgetState createState() => _SuggestedLoadsWidgetState();
}

class _SuggestedLoadsWidgetState extends State<SuggestedLoadsWidget> {

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  //for pageNo
  int i = 0;

  //list for load models
  List<LoadDetailsScreenModel> data = [];

  //API CALL--------------------------------------------------------------------
  runSuggestedLoadApi(int i) async {

    String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
    var jsonData;

    Uri url = Uri.parse("$loadApiUrl?pageNo=$i");

    http.Response response = await http.get(url);
    jsonData = await jsonDecode(response.body);

    for (var json in jsonData) {
      LoadDetailsScreenModel model = LoadDetailsScreenModel();
      model.loadId = json["loadId"];
      model.loadingPointCity = json["loadingPointCity"];
      model.unloadingPointCity = json["unloadingPointCity"];
      setState(() {
        data.add(model);
      }
      );
    }
  }
  //API CALL--------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    runSuggestedLoadApi(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        runSuggestedLoadApi(i + 1);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space_2), color: darkBlueColor),
      child:
      data.isEmpty ?
      Column(children: [
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
      ]
      )
          : Column(children: [
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
                      ));
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
            data.length >= 10 ? 10 : data.length,
            itemBuilder: (context, index) =>
                HomeScreenLoadsCard(
                  loadingPointCity:
                  data[index].loadingPointCity,
                  unloadingPointCity:
                  data[index].unloadingPointCity,
                ),
          ),
        ),
      ]),
    );
  }
}
