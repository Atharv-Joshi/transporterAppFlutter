import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/filterButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:liveasy/widgets/suggestedLoadsCard.dart';

class SuggestedLoadScreen extends StatefulWidget {
  @override
  _SuggestedLoadScreenState createState() => _SuggestedLoadScreenState();
}

class _SuggestedLoadScreenState extends State<SuggestedLoadScreen> {
  ScrollController scrollController = ScrollController();
  int i = 0;
  List data = [];
  bool loading = false;
  bool allDataLoaded = false; // Track if all data is loaded

  Future<void> _loadMoreData() async {
    if (!loading && !allDataLoaded) {
      setState(() {
        loading = true;
      });

      //API call------------------------------------------------------
      var suggestedLoadDataList = await runSuggestedLoadApiWithPageNo(i);

      setState(() {
        loading = false;

        //Checking whether all the data is loaded or not
        if (suggestedLoadDataList.isNotEmpty) {
          data.addAll(suggestedLoadDataList);
          i++;
        } else {
          allDataLoaded = true; // No more data to load
        }
      });
    }
  }

  //For refreshing the page
  Future<void> _refreshData() async {
    setState(() {
      data.clear();
      allDataLoaded = false;
      i = 0;
    });
    await _loadMoreData();
  }

  @override
  void initState() {
    super.initState();
    _loadMoreData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _loadMoreData();
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
            margin: EdgeInsets.fromLTRB(space_3, space_4, space_3, 0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: space_4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Header(
                          reset: false,
                          text: 'suggestedLoad'.tr,
                          // AppLocalizations.of(context)!.suggestedLoad,
                          backButton: true),
                      FilterButtonWidget()
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight -
                      space_6,
                  color: backgroundColor,
                  child: loading &&
                          data.isEmpty // Show loading indicator if loading and no data
                      ? OnGoingLoadingWidgets()
                      : RefreshIndicator(
                          color: lightNavyBlue,
                          onRefresh: _refreshData,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: scrollController,
                            itemCount: data.length +
                                (loading || !allDataLoaded ? 1 : 0),
                            //if one of the condition is true then it takes value 1 otherwise it takes 0
                            itemBuilder: (BuildContext context, index) {
                              if (index == data.length) {
                                if (loading || !allDataLoaded) {
                                  return bottomProgressBarIndicatorWidget(); //Circular Progress Indicator at the bottom
                                } else {
                                  return SizedBox
                                      .shrink(); // Hide progress indicator
                                }
                              } else {
                                return SuggestedLoadsCard(
                                  loadDetailsScreenModel: data[index],
                                );
                              }
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
