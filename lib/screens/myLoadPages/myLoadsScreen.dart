import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/urlGetter.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/MyLoadsCard.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class MyLoadsScreen extends StatefulWidget {
  @override
  _MyLoadsScreenState createState() => _MyLoadsScreenState();
}

class _MyLoadsScreenState extends State<MyLoadsScreen> {
  List<LoadDetailsScreenModel> myLoadList = [];

  ScrollController scrollController = ScrollController();

  TransporterIdController transporterIdController =
  Get.find<TransporterIdController>();

  int i = 0;

  bool loading = false;
  bool bottomProgressLoad = false;
  String transporterId = "";

  @override
  void initState() {
    super.initState();

    loading = true;
    getDataByPostLoadId(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        getDataByPostLoadId(i);
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
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_8,
        child: loading
            ? OnGoingLoadingWidgets()
            : myLoadList.length == 0
            ? Container(
          margin: EdgeInsets.only(top: 153),
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/EmptyLoad.png'),
                height: 127,
                width: 127,
              ),
              Text(
                'noLoadAdded'.tr,
                // 'Looks like you have not added any Loads!',
                style: TextStyle(fontSize: size_8, color: grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : RefreshIndicator(
          color: lightNavyBlue,
          onRefresh: () {
            setState(() {
              myLoadList.clear();
              loading = true;
            });
            return getDataByPostLoadId(0);
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: space_15),
            controller: scrollController,
            itemCount: myLoadList.length,
            itemBuilder: (context, index) =>
            (index == myLoadList.length)//removed -1 here
                ? Visibility(
                visible: bottomProgressLoad,
                child: bottomProgressBarIndicatorWidget())
                : MyLoadsCard(
              loadDetailsScreenModel: myLoadList[index],
            ),
          ),
        ));
  }

  getDataByPostLoadId(int i) async {
    transporterId = transporterIdController.transporterId.value;

    final String loadApiUrl = await UrlGetter.get('loadApiUrl');

    if (this.mounted) {
      setState(() {
        bottomProgressLoad = true;
      });
    }
    http.Response response = await http.get(Uri.parse('$loadApiUrl?postLoadId=$transporterId&pageNo=$i'));
    var jsonData = json.decode(response.body);
    for (var json in jsonData) {
      LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
      loadDetailsScreenModel.loadId = json['loadId'];
      loadDetailsScreenModel.loadingPointCity =
      json['loadingPointCity'] != null ? json['loadingPointCity'] : 'NA';
      loadDetailsScreenModel.loadingPoint =
      json['loadingPoint'] != null ? json['loadingPoint'] : 'NA';
      loadDetailsScreenModel.loadingPointState =
      json['loadingPointState'] != null ? json['loadingPointState'] : 'NA';
      loadDetailsScreenModel.loadingPointCity2 =
      json['loadingPointCity2'] != null ? json['loadingPointCity2'] : 'NA';
      loadDetailsScreenModel.loadingPoint2 =
      json['loadingPoint2'] != null ? json['loadingPoint2'] : 'NA';
      loadDetailsScreenModel.loadingPointState2 =
      json['loadingPointState2'] != null ? json['loadingPointState2'] : 'NA';
      loadDetailsScreenModel.unloadingPointCity =
      json['unloadingPointCity'] != null
          ? json['unloadingPointCity']
          : 'NA';
      loadDetailsScreenModel.unloadingPoint =
      json['unloadingPoint'] != null ? json['unloadingPoint'] : 'NA';
      loadDetailsScreenModel.unloadingPointState =
      json['unloadingPointState'] != null
          ? json['unloadingPointState']
          : 'NA';
      loadDetailsScreenModel.unloadingPointCity2 =
      json['unloadingPointCity2'] != null
          ? json['unloadingPointCity2']
          : 'NA';
      loadDetailsScreenModel.unloadingPoint2 =
      json['unloadingPoint2'] != null ? json['unloadingPoint2'] : 'NA';
      loadDetailsScreenModel.unloadingPointState2 =
      json['unloadingPointState2'] != null
          ? json['unloadingPointState2']
          : 'NA';
      loadDetailsScreenModel.postLoadId = json['postLoadId'];
      loadDetailsScreenModel.truckType =
      json['truckType'] != null ? json['truckType'] : 'NA';
      loadDetailsScreenModel.weight =
      json['weight'] != null ? json['weight'] : 'NA';
      loadDetailsScreenModel.productType =
      json['productType'] != null ? json['productType'] : 'NA';
      loadDetailsScreenModel.rate =
      json['rate'] != null ? json['rate'].toString() : 'NA';
      loadDetailsScreenModel.unitValue =
      json['unitValue'] != null ? json['unitValue'] : 'NA';
      loadDetailsScreenModel.noOfTyres =
      json['noOfTyres'] != null ? json['noOfTyres'] : 'NA';
      loadDetailsScreenModel.loadDate =
      json['loadDate'] != null ? json['loadDate'] : 'NA';
      loadDetailsScreenModel.postLoadDate =
      json['postLoadDate'] != null ? json['postLoadDate'] : 'NA';
      loadDetailsScreenModel.status = json['status'];
      if (this.mounted) {
        setState(() {
          myLoadList.add(loadDetailsScreenModel);
        });
      }
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        bottomProgressLoad = false;
      });
    }
  } //builder
} //class end
