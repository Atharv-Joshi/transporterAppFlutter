import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bigApis/getBidDataWithPageNo.dart';
import 'package:liveasy/widgets/biddingsCardTransporterSide.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class BiddingScreenTransporterSide extends StatefulWidget {
  @override
  _BiddingScreenTransporterSideState createState() =>
      _BiddingScreenTransporterSideState();
}

class _BiddingScreenTransporterSideState
    extends State<BiddingScreenTransporterSide> {
  final String biddingApiUrl = dotenv.get('biddingApiUrl');
  final String loadApiUrl = dotenv.get('loadApiUrl');

  int i = 0;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  List biddingModelList = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (this.mounted) {
      setState(() {
        loading = true;
      });
    }

    getBidData(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
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
            : biddingModelList.length == 0
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
                          'Looks like you have no bid yet!',
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
                        biddingModelList.clear();
                        loading = true;
                      });
                      return getBidData(0);
                    },
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 60),
                        controller: scrollController,
                        itemCount: biddingModelList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == biddingModelList.length) {
                            return loading
                                ? Container(
                                    child: bottomProgressBarIndicatorWidget(),
                                    margin: EdgeInsets.only(bottom: space_2),
                                  )
                                : SizedBox.shrink();
                          } else {
                            return BiddingsCardTransporterSide(
                              biddingModel: biddingModelList[index],
                            );
                          }
                        }),
                  ));
  }

  getBidData(int i) async {
    var bidDataListForPagei = await getBidDataWithPageNo(i);
    for (var bidData in bidDataListForPagei) {
      biddingModelList.add(bidData);
    }
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
