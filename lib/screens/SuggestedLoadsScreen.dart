import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:liveasy/widgets/suggestedLoadsCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class SuggestedLoadScreen extends StatefulWidget {
  @override
  _SuggestedLoadScreenState createState() => _SuggestedLoadScreenState();
}

class _SuggestedLoadScreenState extends State<SuggestedLoadScreen> {
  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  //for pageNo
  int i = 0;

  List<LoadDetailsScreenModel> data = [];

  bool loading = false;

  //API CALL--------------------------------------------------------------------
  runSuggestedLoadApi(int i) async {
    String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
    var jsonData;
    Uri url = Uri.parse("$loadApiUrl?pageNo=$i");
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
    setState(() {
      loading = false;
    });
  }
  //API CALL--------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    runSuggestedLoadApi(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(space_3, space_4, space_3, 0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: space_4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Header(
                        reset: false,
                        text: 'Suggested Loads',
                        backButton: true),
                    FilterButtonWidget()
                  ],
                ),
              ),
              Container(
                // height: (MediaQuery.of(context).size.height),
                height:  MediaQuery.of(context).size.height -  kBottomNavigationBarHeight - space_6,
                color: backgroundColor,
                child: loading == true
                    ? OnGoingLoadingWidgets()
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, index) =>
                            SuggestedLoadsCard(
                          loadDetailsScreenModel: data[index],
                        ),
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
