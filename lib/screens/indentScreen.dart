import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/functions/loadApis/findLoadByLoadID.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/radius.dart';
import '../constants/spaces.dart';
import '../functions/loadApis/runSuggestedLoadApiWithPageNo.dart';
import '../models/loadDetailsScreenModel.dart';
import '../models/truckModel.dart';
import '../widgets/LoadEndPointTemplateWeb.dart';
import '../widgets/buttons/indentCard.dart';
import '../widgets/indentHeader.dart';
import '../widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
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
        ? BookLoadScreen(
            loadDetailsScreenModel: loadDetailsScreenModel,
            directBooking: null,
          )
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

  Widget indentDetail(
    BuildContext context,
    String loadId,
    String postLoadDate,
    String truckType,
    String productType,
    String weight,
    String loadingCityPoint,
    String unloadingCityPoint,
  ) {
    return Container(
      color: white,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formatDate(postLoadDate),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              color: greyDivider,
              thickness: 1,
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        truckType,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              color: greyDivider,
              thickness: 1,
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        productType,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                        ),
                      ),
                      Text(
                        weight + ' ' + 'tonne'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: truckGreen,
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              color: greyDivider,
              thickness: 1,
            ),
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: space_2),
                          child: LoadEndPointTemplateWeb(
                              text: loadingCityPoint, endPointType: 'loading'),
                        ),
                        Container(
                            height: space_5,
                            padding: EdgeInsets.only(right: space_40),
                            child: DottedLine(
                              alignment: WrapAlignment.center,
                              direction: Axis.vertical,
                              dashColor: Colors.black,
                              dashGapColor: Colors.white,
                              lineThickness: 1.5,
                              dashLength: 3.5,
                              dashGapLength: 2.25,
                              lineLength: 26,
                              dashGapRadius: 0,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: space_2),
                          child: LoadEndPointTemplateWeb(
                              text: unloadingCityPoint,
                              endPointType: 'unloading'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              color: greyDivider,
              thickness: 1,
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'NA' + '' + '(per tonne)'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              color: greyDivider,
              thickness: 1,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      data.addAll({
                        "loadId": loadId,
                      });
                      setState(() {
                        bookNow = true;
                      });
                      // widget.changeScreen();
                    },
                    child: Container(
                      height: space_6 + 1,
                      width: space_16,
                      decoration: BoxDecoration(
                          color: darkBlueColor,
                          borderRadius: BorderRadius.circular(radius_4)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Image(
                              image: AssetImage('assets/icons/auctionIcon.png'),
                            ),
                          ),
                          SizedBox(
                            width: space_1,
                          ),
                          Text(
                            'book',
                            style: TextStyle(
                                color: white,
                                fontWeight: normalWeight,
                                fontSize: size_6 + 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
