import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/loadApis/findLoadByLoadID.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/indentCard.dart';
import 'package:liveasy/widgets/indentHeader.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'auctionScreen.dart';
import 'myLoadPages/bookLoadScreen.dart';

class IndentScreen extends StatefulWidget {
  IndentScreen({
    super.key,
  });

  @override
  State<IndentScreen> createState() => _IndentScreenState();
}

class _IndentScreenState extends State<IndentScreen> {
  ScrollController scrollController = ScrollController();
  int i = 0;
  List<LoadDetailsScreenModel> myLoadList = [];
  List<TruckModel> truckDetailsList = [];
  bool isLoading = true;
  bool bottomProgressLoad = false;
  Map data = {};
  bool bookNow = false;

  runSuggestedLoadApi(int i) async {
    if (this.mounted) {
      var suggestedLoadDataList = await runWidgetSuggestedLoadApiWithPageNo(i);
      if (suggestedLoadDataList.isEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        for (var suggestedLoadData in suggestedLoadDataList) {
          setState(() {
            myLoadList.add(suggestedLoadData);
          });
        }
      }
    }
  }

  String formatDate(String postLoadDate) {
    if (postLoadDate != 'NA') {
      DateTime date = DateFormat('EEE, MMM d yyyy').parse(postLoadDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } else {
      return 'NA';
    }
  }

  @override
  void initState() {
    super.initState();
    runSuggestedLoadApi(i);
    textEditingController.addListener(() {
      if (textEditingController.text.length > 0) {
        myLoadList = myLoadList
            .where((element) =>
                element.truckType
                    ?.toLowerCase()
                    .contains(textEditingController.text.toLowerCase()) ==
                true)
            .toList();
      } else {
        runSuggestedLoadApi(i);
      }
      setState(() {});
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        runSuggestedLoadApi(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  int switchIndex = 0;

  @override
  Widget build(BuildContext context) {
    return bookNow
        //When pressed on book button then bookNow bool value return true and BookLoadScreen is displayed.
        ? BookLoadScreen(
            loadDetailsScreenModel: loadDetailsScreenModel,
            directBooking: null,
          )
        //Data from myLoadList is empty then its in loading state else indent card is displayed.
        : myLoadList.isEmpty
            ? Center(
                child: CircularProgressIndicator(color: darkBlueColor),
              )
            : RefreshIndicator(
                color: lightNavyBlue,
                onRefresh: () async {
                  setState(() {
                    myLoadList.clear();
                    isLoading = true;
                    i = 0;
                  });
                  await runSuggestedLoadApi(i);
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: space_3,
                    ),
                    IndentHeader(context),
                    SizedBox(
                      height: space_3,
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        physics: BouncingScrollPhysics(),
                        controller: scrollController,
                        itemCount: myLoadList.length,
                        itemBuilder: (context, index) =>
                            (index == myLoadList.length) //removed -1 here
                                ? Visibility(
                                    visible: bottomProgressLoad,
                                    child: bottomProgressBarIndicatorWidget())
                                : IndentCard(
                                    loadDetailsScreenModel: myLoadList[index]),
                        separatorBuilder: (context, index) => const Divider(
                          color: greyDivider,
                          thickness: 1,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ));
  }
}
