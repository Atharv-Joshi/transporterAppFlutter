import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
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

    for (var json in jsonData) {
      LoadDetailsScreenModel model = LoadDetailsScreenModel();
      model.loadId = json["loadId"] != null ? json['loadId'] : 'NA';
      model.loadingPoint = json["loadingPoint"] != null ? json['loadingPoint'] : 'NA';
      model.loadingPointCity = json["loadingPointCity"] != null ? json['loadingPointCity'] : 'NA';
      model.loadingPointState = json["loadingPointState"] != null ? json['loadingPointState'] : 'NA';
      model.postLoadId = json["postLoadId"] != null ? json['postLoadId'] : 'NA';
      model.unloadingPoint = json["unloadingPoint"] != null ? json['unloadingPoint'] : 'NA';
      model.unloadingPointCity = json["unloadingPointCity"] != null ? json['unloadingPointCity'] : 'NA';
      model.unloadingPointState = json["unloadingPointState"] != null ? json['unloadingPointState'] : 'NA';
      model.productType = json["productType"] != null ? json['productType'] : 'NA';
      model.truckType = json["truckType"] != null ? json['truckType'] : 'NA';
      model.noOfTrucks = json["noOfTrucks"] != null ? json['noOfTrucks'] : 'NA';
      model.weight = json["weight"] != null ? json['weight'] : 'NA';
      model.comment = json["comment"] != null ? json['comment'] : 'NA';
      model.status = json["status"] != null ? json['status'] : 'NA';
      model.loadDate = json["loadDate"] != null ? json['loadDate'] : 'NA';
      model.rate = json["rate"] != null ? json['rate'].toString() : 'NA';
      model.unitValue = json["unitValue"] != null ? json['unitValue'] : 'NA';
      setState(() {
        data.add(model);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(space_3 , space_4 , space_3 , 0),
            child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: space_4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Header(reset: false, text: 'Suggested Loads', backButton: true),
                        FilterButtonWidget()
                      ],
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height),
                    color: backgroundColor,
                    child:
                    loading == true
                        ? LoadingWidget()
                        :
                    ListView.builder(
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
