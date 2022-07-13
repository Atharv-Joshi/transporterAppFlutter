import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bookingApi/getOngoingDataWithPageNo.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:liveasy/widgets/onGoingCard.dart';
import 'package:geocoding/geocoding.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';

class OngoingScreen extends StatefulWidget {
  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  //for counting page numbers
  int i = 0;

  bool OngoingProgress = false;

  final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

  List<OngoingCardModel> modelList = [];

  getDataByPostLoadIdOnGoing(int i) async {
    if (this.mounted) {
      setState(() {
        OngoingProgress = true;
      });
    }
    var bookingDataListWithPagei = await getOngoingDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
    }
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        loading = false;
        OngoingProgress = false;
      });
    }
  }

  @override
  void initState() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    super.initState();
    setState(() {
      loading = true;
    });
    getDataByPostLoadIdOnGoing(i);
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
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
                        'noOnGoingLoad'.tr,
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
                    return getDataByPostLoadIdOnGoing(0);
                  },
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: space_15),
                    itemCount: modelList.length,
                    itemBuilder: (context, index) =>
                        (index == modelList.length)
                            ? Visibility(
                                visible: OngoingProgress,
                                child: bottomProgressBarIndicatorWidget())
                            : OngoingCard(
                                loadAllDataModel: modelList[index],
                              ),
                  ),
                ),
    );
  }
} //class end
