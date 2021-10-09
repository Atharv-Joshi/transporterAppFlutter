import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApi/getOngoingDataWithPageNo.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:liveasy/widgets/onGoingCard.dart';

class OngoingScreen extends StatefulWidget {
  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  //for counting page numbers
  int i = 0;

  bool loading = false;
  bool OngoingProgress = false;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

  List<OngoingCardModel> modelList = [];

  ScrollController scrollController = ScrollController();

  getDataByPostLoadIdOnGoing(int i) async {
    setState(() {
      OngoingProgress = true;
    });
    var bookingDataListWithPagei = await getOngoingDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
    }
    setState(() {
      loading = false;
      OngoingProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getDataByPostLoadIdOnGoing(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getDataByPostLoadIdOnGoing(i);
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
                        'Looks like you have not added any Loads!',
                        style: TextStyle(fontSize: size_8, color: grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: space_15),
                  itemCount: modelList.length,
                  itemBuilder: (context, index) =>
                      (index == modelList.length - 1)
                          ? Visibility(
                              visible: OngoingProgress,
                              child: bottomProgressBarIndicatorWidget())
                          : OngoingCard(
                              loadAllDataModel: modelList[index],
                            )),
    );
  }
} //class end
