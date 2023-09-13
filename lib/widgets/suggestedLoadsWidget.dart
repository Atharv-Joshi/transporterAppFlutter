import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/homeScreenLoadsCard.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';

class SuggestedLoadsWidget extends StatefulWidget {
  @override
  _SuggestedLoadsWidgetState createState() => _SuggestedLoadsWidgetState();
}

class _SuggestedLoadsWidgetState extends State<SuggestedLoadsWidget> {
  ScrollController scrollController = ScrollController();
  int i = 0;
  List<LoadDetailsScreenModel> data = [];
  bool isLoading = true;

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
            data.add(suggestedLoadData);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    runSuggestedLoadApi(i);

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

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: CircularProgressIndicator(color: darkBlueColor),
          )
        : RefreshIndicator(
            color: lightNavyBlue,
            onRefresh: () async {
              setState(() {
                data.clear();
                isLoading = true;
                i = 0;
              });
              await runSuggestedLoadApi(i);
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemCount: isLoading ? data.length + 1 : data.length,
              itemBuilder: (context, index) {
                if (isLoading && index == data.length) {
                  return bottomProgressBarIndicatorWidget();
                } else {
                  return HomeScreenLoadsCard(
                    loadDetailsScreenModel: data[index],
                  );
                }
              },
            ),
          );
  }
}
