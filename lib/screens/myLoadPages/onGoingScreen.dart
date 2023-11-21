import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
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
  late ScrollController scrollController;

  bool loading = true; //false
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  //for counting page numbers
  int i = 0;

  bool OngoingProgress = true;
  bool moreitems = true;
  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  List<OngoingCardModel> modelList = [];

  getDataByPostLoadIdOnGoing(int i) async {
    if (this.mounted) {
      setState(() {
        OngoingProgress = true;
      });
    }
    if(moreitems) {
      List<OngoingCardModel> bookingdata = await getOngoingDataWithPageNo(i);
      if(bookingdata.isEmpty)
        {
          setState(() {
            moreitems = false;
            loading = false;
          });
        }
      if(moreitems)
        {
          modelList.addAll(bookingdata);
        }
    }
    if (modelList.isNotEmpty) {
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          loading = false;
          OngoingProgress = false;
        });
      }
    }
    print("${modelList.length}---------------------");
  }

  @override
  void initState() {
    //Scroll Controller for Pagination
    scrollController = ScrollController();
    super.initState();
    loading = true;
    getDataByPostLoadIdOnGoing(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          i = i + 1;
          if(moreitems)
            {
              getDataByPostLoadIdOnGoing(i);
            }
        });
      }
    });
  }

  @override
  void dispose() {
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
                          print(modelList);
                          modelList.clear();
                          moreitems = true;
                          i = 0;
                          loading = true;
                          print(modelList);
                        });
                        return getDataByPostLoadIdOnGoing(i);
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: space_15),
                            itemCount: modelList.length + 1,
                            itemBuilder: (context, index) =>
                              (index == modelList.length)
                                  ? Visibility(
                                      visible: OngoingProgress,
                                      child: bottomProgressBarIndicatorWidget())
                                  : OngoingCard(
                                          loadAllDataModel: modelList[index],
                                        )
                            ),
                      ),
                    )
    );
  }
} //class end
