import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';
import 'package:liveasy/screens/SuggestedLoadsScreen.dart';
import 'package:liveasy/widgets/bodyTextWidget.dart';
import 'package:liveasy/widgets/suggestedLoadDataDisplayCard.dart';
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

  List<LoadApiModel> data = [];

  runSuggestedLoadApi(int i) async {
    String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
    var jsonData;
    Uri url = Uri.parse("$loadApiUrl?pageNo=$i");
    http.Response response = await http.get(url);
    jsonData = await jsonDecode(response.body);

    for (var json in jsonData) {
      LoadApiModel cardsModal = LoadApiModel();
      cardsModal.loadId = json["loadId"];
      cardsModal.loadingPoint = json["loadingPoint"];
      cardsModal.loadingPointCity = json["loadingPointCity"];
      cardsModal.loadingPointState = json["loadingPointState"];
      cardsModal.postLoadId = json["postLoadId"];
      cardsModal.unloadingPoint = json["unloadingPoint"];
      cardsModal.unloadingPointCity = json["unloadingPointCity"];
      cardsModal.unloadingPointState = json["unloadingPointState"];
      cardsModal.productType = json["productType"];
      cardsModal.truckType = json["truckType"];
      cardsModal.noOfTrucks = json["noOfTrucks"];
      cardsModal.weight = json["weight"];
      cardsModal.comment = json["comment"];
      cardsModal.status = json["status"];
      cardsModal.loadDate = json["loadDate"];
      cardsModal.rate = json["rate"];
      cardsModal.unitValue = json["unitValue"];
      setState(() {
        data.add(cardsModal);
      });

    }

  }

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
              ])

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
                                  suggestedLoadData: data));
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
                        SuggestedLoadDataDisplayCard(
                            loadingPointCity:
                                data[index].loadingPointCity,
                            unloadingPointCity:
                               data[index].unloadingPointCity,
                            onTap: () {
                              Get.to(
                                () => SuggestedLoadScreen(
                                  suggestedLoadData: data
                                      .getRange(index, data.length)
                                      .toList(),
                                ),
                              );
                            }),
                  ),
                ),
              ]),
    );
  }
}
