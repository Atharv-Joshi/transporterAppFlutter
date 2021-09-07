import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getDeliveredDataWithPageNo.dart';
import 'package:liveasy/functions/bookingApi/getOngoingDataWithPageNo.dart';
import 'package:liveasy/functions/loadDeliveredData.dart';
import 'package:liveasy/functions/loadOnGoingData.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/models/deliveredCardModel.dart';
import 'package:liveasy/widgets/deliveredCard.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/widgets/loadingWidgets/completedLoadingWidgets.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  _DeliveredScreenState createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  //for counting page numbers
  int i = 0;
  bool loading = false;
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

  List<DeliveredCardModel> modelList = [];

  ScrollController scrollController = ScrollController();

  getDataByPostLoadIdDelivered(int i) async {
    var bookingDataListWithPagei = await getDeliveredDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getDataByPostLoadIdDelivered(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getDataByPostLoadIdDelivered(i);
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
        child: loading? OnGoingLoadingWidgets() : modelList.length == 0
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
                      'Looks like you have not added any Loads!',
                      style: TextStyle(fontSize: size_8, color: grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: space_15),
                controller: scrollController,
                itemCount: modelList.length,
                itemBuilder: (context, index) {
                  return  DeliveredCard(
                          model: modelList[index],
                        );
                } //builder
                ),
    );
  }
} //class end
