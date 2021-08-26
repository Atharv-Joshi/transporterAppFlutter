import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bigApis/getBidDataWithPageNo.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/widgets/biddingsCardTransporterSide.dart';
import 'package:get/get.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class BiddingScreenTransporterSide extends StatefulWidget {
  @override
  _BiddingScreenTransporterSideState createState() =>
      _BiddingScreenTransporterSideState();
}

class _BiddingScreenTransporterSideState
    extends State<BiddingScreenTransporterSide> {
  final String biddingApiUrl = FlutterConfig.get('biddingApiUrl');

  int i = 0;

  late List jsonData;

  TransporterIdController transporterIdController =
  Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  List biddingModelList = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });
    getBidData(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getBidData(i);
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
            : ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            controller: scrollController,
            itemCount: biddingModelList.length,
            itemBuilder: (context, index) {
              return BiddingsCardTransporterSide(
                biddingModel: biddingModelList[index],
              );
            })
    );
  }

  getBidData(int i) async {
    var bidDataListForPagei = await getBidDataWithPageNo(i);
    for (var bidData in bidDataListForPagei){
      biddingModelList.add(bidData);}
    setState(() {
      loading = false;
    });
  }
}