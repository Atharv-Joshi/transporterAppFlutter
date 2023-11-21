import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getDeliveredDataWithPageNo.dart';
import 'package:liveasy/models/deliveredCardModel.dart';
import 'package:liveasy/widgets/deliveredCard.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  _DeliveredScreenState createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  //for counting page numbers
  int i = 0;
  bool loading = false;
  bool DeliveredProgress = false;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  List<DeliveredCardModel> modelList = [];

  ScrollController scrollController = ScrollController();

  getDataByPostLoadIdDelivered(int i) async {
    print("RUNNING GETDATA BY POST----------------------");

    if (this.mounted) {
      setState(() {
        DeliveredProgress = true;
      });
    }
    var bookingDataListWithPagei = await getDeliveredDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
    }
    inspect(modelList);
    print("MODEL LIST LENGTH ------------------------- : ${modelList.length}");
    if (this.mounted) {
      setState(() {
        loading = false;
        DeliveredProgress = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getDataByPostLoadIdDelivered(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
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
      child: loading
          ? OnGoingLoadingWidgets()
          : modelList.length == 0
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
                        'stoppedLoad'.tr,
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
                      modelList.clear();
                      loading = true;
                    });
                    return getDataByPostLoadIdDelivered(0);
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: space_15),
                      controller: scrollController,
                      itemCount: modelList.length,
                      itemBuilder: (context, index) =>
                          (index == modelList.length)
                              ? Visibility(
                                  visible: DeliveredProgress,
                                  child: bottomProgressBarIndicatorWidget())
                              : DeliveredCard(
                                  model: modelList[index],
                                )
                      // {
                      //   return  DeliveredCard(
                      //           model: modelList[index],
                      //         );
                      // } //builder
                      ),
                ),
    );
  }
} //class end
