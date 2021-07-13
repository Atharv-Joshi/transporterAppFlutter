import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
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
      model.loadingPoint = json["loadingPoint"];
      model.loadingPointCity = json["loadingPointCity"];
      model.loadingPointState = json["loadingPointState"];
      model.postLoadId = json["postLoadId"];
      model.unloadingPoint = json["unloadingPoint"];
      model.unloadingPointCity = json["unloadingPointCity"];
      model.unloadingPointState = json["unloadingPointState"];
      model.productType = json["productType"];
      model.truckType = json["truckType"];
      model.noOfTrucks = json["noOfTrucks"];
      model.weight = json["weight"];
      model.comment = json["comment"];
      model.status = json["status"];
      model.loadDate = json["loadDate"];
      model.rate = json["rate"].toString();
      model.unitValue = json["unitValue"];
      setState(() {
        data.add(model);
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
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, index) =>
                      SuggestedLoadsCard(
                        model: data[index],
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
