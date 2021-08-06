import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/screens/SuggestedLoadsScreen.dart';
import 'package:liveasy/widgets/homeScreenLoadsCard.dart';

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
    var suggestedLoadDataList = await runSuggestedLoadApiWithPageNo(i);
    for (var suggestedLoadData in suggestedLoadDataList){
      setState(() {
        data.add(suggestedLoadData);
      });
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
        i = i+1;
        runSuggestedLoadApi(i);
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
      child: data.isEmpty
          ? Column(children: [
              Row(
                children: [
                  Text(
                    "Suggested Loads",
                    style: TextStyle(
                        color: liveasyBlackColor,
                        fontFamily: 'montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: size_8),
                  ),
                  Spacer(),
                  Text(
                    "See All",
                    style: TextStyle(
                        color: liveasyGreen,
                        fontFamily: 'montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: size_8),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(top: space_6),
                  child: CircularProgressIndicator(color: white))
            ])
          : Column(children: [
            Row(
              children: [
                Text(
                  "Suggested Loads",
                  style: TextStyle(
                      color: liveasyBlackColor,
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Get.to(() => SuggestedLoadScreen());
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: liveasyGreen,
                        fontFamily: 'montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: size_8),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: space_2,
            ),
            Container(
              padding: EdgeInsets.only(bottom: space_2),
              height: 2*space_40,
              width: double.infinity,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: (context, index) => HomeScreenLoadsCard(
                  loadDetailsScreenModel: data[index],
                ),
              ),
            )
          ]),
    );
  }
}