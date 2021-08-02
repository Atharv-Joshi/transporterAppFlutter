import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
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
    String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
    var jsonData;

    Uri url = Uri.parse("$loadApiUrl?pageNo=$i&suggestedLoads=true");

    http.Response response = await http.get(url);
    jsonData = await jsonDecode(response.body);
    LoadPosterModel loadPosterModel = LoadPosterModel();

    for (var json in jsonData) {
      LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
      loadDetailsScreenModel.loadId =
          json["loadId"] != null ? json['loadId'] : 'NA';
      loadDetailsScreenModel.loadingPoint =
          json["loadingPoint"] != null ? json['loadingPoint'] : 'NA';
      loadDetailsScreenModel.loadingPointCity =
          json["loadingPointCity"] != null ? json['loadingPointCity'] : 'NA';
      loadDetailsScreenModel.loadingPointState =
          json["loadingPointState"] != null ? json['loadingPointState'] : 'NA';
      loadDetailsScreenModel.postLoadId =
          json["postLoadId"] != null ? json['postLoadId'] : 'NA';
      loadDetailsScreenModel.unloadingPoint =
          json["unloadingPoint"] != null ? json['unloadingPoint'] : 'NA';
      loadDetailsScreenModel.unloadingPointCity =
          json["unloadingPointCity"] != null
              ? json['unloadingPointCity']
              : 'NA';
      loadDetailsScreenModel.unloadingPointState =
          json["unloadingPointState"] != null
              ? json['unloadingPointState']
              : 'NA';
      loadDetailsScreenModel.productType =
          json["productType"] != null ? json['productType'] : 'NA';
      loadDetailsScreenModel.truckType =
          json["truckType"] != null ? json['truckType'] : 'NA';
      loadDetailsScreenModel.noOfTrucks =
          json["noOfTrucks"] != null ? json['noOfTrucks'] : 'NA';
      loadDetailsScreenModel.weight =
          json["weight"] != null ? json['weight'] : 'NA';
      loadDetailsScreenModel.comment =
          json["comment"] != null ? json['comment'] : 'NA';
      loadDetailsScreenModel.status =
          json["status"] != null ? json['status'] : 'NA';
      loadDetailsScreenModel.loadDate =
          json["loadDate"] != null ? json['loadDate'] : 'NA';
      loadDetailsScreenModel.rate =
          json["rate"] != null ? json['rate'].toString() : 'NA';
      loadDetailsScreenModel.unitValue =
          json["unitValue"] != null ? json['unitValue'] : 'NA';

      if (json["postLoadId"].contains('transporter') ||
          json["postLoadId"].contains('shipper')) {
        loadPosterModel = await getLoadPosterDetailsFromApi(
            loadPosterId: json["postLoadId"].toString());
      } else {
        continue;
      }

      if (loadPosterModel != null) {
        loadDetailsScreenModel.loadPosterId = loadPosterModel.loadPosterId;
        loadDetailsScreenModel.phoneNo = loadPosterModel.loadPosterPhoneNo;
        loadDetailsScreenModel.loadPosterLocation =
            loadPosterModel.loadPosterLocation;
        loadDetailsScreenModel.loadPosterName = loadPosterModel.loadPosterName;
        loadDetailsScreenModel.loadPosterCompanyName =
            loadPosterModel.loadPosterCompanyName;
        loadDetailsScreenModel.loadPosterKyc = loadPosterModel.loadPosterKyc;
        loadDetailsScreenModel.loadPosterCompanyApproved =
            loadPosterModel.loadPosterCompanyApproved;
        loadDetailsScreenModel.loadPosterApproved =
            loadPosterModel.loadPosterApproved;
      } else {
        //this will run when postloadId value is something different than uuid , like random text entered from postman
        loadDetailsScreenModel.loadPosterId = 'NA';
        loadDetailsScreenModel.phoneNo = '';
        loadDetailsScreenModel.loadPosterLocation = 'NA';
        loadDetailsScreenModel.loadPosterName = 'NA';
        loadDetailsScreenModel.loadPosterCompanyName = 'NA';
        loadDetailsScreenModel.loadPosterKyc = 'NA';
        loadDetailsScreenModel.loadPosterCompanyApproved = true;
        loadDetailsScreenModel.loadPosterApproved = true;
      }

      setState(() {
        data.add(loadDetailsScreenModel);
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