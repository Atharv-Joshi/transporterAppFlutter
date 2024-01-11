import 'dart:convert';
import 'dart:core';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/urlGetter.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/widgets/auctionDetails.dart';
import 'package:liveasy/widgets/auctionHeader.dart';

import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/radius.dart';
import '../models/loadDetailsScreenModel.dart';
import '../widgets/LoadEndPointTemplateWeb.dart';
import '../widgets/LoadPointTemplateForBidScreen.dart';
import '../widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import '../widgets/placeBidButton.dart';
import 'auctionScreen.dart';

class AuctionDetailScreen extends StatefulWidget {
  AuctionDetailScreen({super.key, required this.changeScreen});
  Function changeScreen;
  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  List<LoadDetailsScreenModel> myLoadList = [];
  LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
  ScrollController scrollController = ScrollController();

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  List<LoadDetailsScreenModel> details = [];
  int i = 0;
  bool loading = false;
  bool bottomProgressLoad = false;
  String transporterId = "";
  int switchIndex = 0;
  bool isLoading = true;

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
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    loading = true;
    getDataByPostLoadId();
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
        getDataByPostLoadId();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: space_3,
        ),
        AuctionHeader(context),
        SizedBox(
          height: space_3,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 5, right: 5),
            physics: BouncingScrollPhysics(),
            // padding: EdgeInsets.only(bottom: space_15),
            controller: scrollController,
            itemCount: myLoadList.length,
            itemBuilder: (context, index) =>
                (index == myLoadList.length) //removed -1 here
                    ? Visibility(
                        visible: bottomProgressLoad,
                        child: bottomProgressBarIndicatorWidget())
                    : auctionDetail(
                        context,
                        myLoadList[index].loadId ?? 'NA',
                        myLoadList[index].postLoadDate ?? 'NA',
                        myLoadList[index].truckType ?? 'NA',
                        myLoadList[index].productType ?? 'NA',
                        myLoadList[index].weight ?? 'NA',
                        myLoadList[index].loadingPointCity ?? 'NA',
                        myLoadList[index].unloadingPointCity ?? 'NA',
                        myLoadList[index].rate ?? 'NA',
                        myLoadList[index].noOfTyres ?? 'NA',
                        myLoadList[index].loadPosterCompanyName ?? 'NA',
                      ),
            separatorBuilder: (context, index) => const Divider(
              color: greyDivider,
              thickness: 1,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget auctionDetail(
    BuildContext context,
    String loadId,
    String postLoadDate,
    String truckType,
    String productType,
    String weight,
    String loadingCityPoint,
    String unloadingCityPoint,
    String? rate,
    String? noOfTyres,
    String? loadPosterCompanyName,
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
                        rate! + '' + '(per tonne)'.tr,
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
                        "postLoadDate": postLoadDate,
                        "truckType": truckType,
                        "productType": productType,
                        "weight": weight,
                        "loadingCityPoint": loadingCityPoint,
                        "unloadingCityPoint": unloadingCityPoint,
                        "rate": rate,
                        "noOfTyres": noOfTyres,
                        "loadPosterCompanyName": loadPosterCompanyName,
                      });
                      widget.changeScreen();
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
                            'bids'.tr,
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

  Widget loadDetails(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: teamBar),
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showDetails = !showDetails;
                        data.clear();
                      });
                    },
                    icon: Icon(Icons.arrow_back, color: navy),
                  ),
                  Text(
                    'Place Your Bid',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: space_2, top: space_2),
          child: Card(
            color: Colors.white,
            elevation: 3,
            child: Container(
              padding: EdgeInsets.only(
                  top: space_2, bottom: space_2, left: space_4, right: space_2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadPointTemplateForBidScreen(
                      text: data["loadingCityPoint"], endPointType: 'loading'),
                  Container(
                      height: space_8,
                      padding: EdgeInsets.only(left: space_2),
                      child: DottedLine(
                        alignment: WrapAlignment.center,
                        direction: Axis.vertical,
                        dashColor: Colors.black,
                        dashGapColor: Colors.white,
                        lineThickness: 1.5,
                        dashLength: 3.5,
                        dashGapLength: 2.25,
                        lineLength: 40,
                        dashGapRadius: 0,
                      )),
                  LoadPointTemplateForBidScreen(
                      text: data["unloadingCityPoint"],
                      endPointType: 'unloading'),
                ],
                // [Text(data['loadId'])],
              ),
            ),
          ),
        ),
        AuctionDetails(
          truckType: data['truckType'] ?? 'NA',
          noOfTyres: data['noOfTyres'] ?? 'NA',
          weight: data['weight'] ?? 'NA',
          productType: data['productType'] ?? 'NA',
          loadPosterCompanyName: data['loadPosterCompanyName'] ?? 'NA',
          rate: data['rate'] ?? 'NA',
        ),
        PlaceBidButton(
          loadId: data['loadId'] ?? 'NA',
          loadingPointCity: data['loadingPointCity'] ?? 'NA',
          unloadingPointCity: data['unloadingPointCity'] ?? 'NA',
          postLoadId: data['unloadingPointCity'] ?? 'NA',
        )
      ],
    );
  }

  getDataByPostLoadId() async {
    transporterId = transporterIdController.transporterId.value;
    final String loadApiUrl = await UrlGetter.get('loadApiUrl');

    if (this.mounted) {
      setState(() {
        bottomProgressLoad = true;
      });
    }
    http.Response response = await http
        .get(Uri.parse('$loadApiUrl?postLoadId=$transporterId&pageNo=$i'));
    var jsonData = json.decode(response.body);
    for (var json in jsonData) {
      LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
      loadDetailsScreenModel.loadId = json['loadId'];
      loadDetailsScreenModel.loadingPointCity =
          json['loadingPointCity'] != null ? json['loadingPointCity'] : 'NA';
      loadDetailsScreenModel.loadingPoint =
          json['loadingPoint'] != null ? json['loadingPoint'] : 'NA';
      loadDetailsScreenModel.loadingPointState =
          json['loadingPointState'] != null ? json['loadingPointState'] : 'NA';
      loadDetailsScreenModel.loadingPointCity2 =
          json['loadingPointCity2'] != null ? json['loadingPointCity2'] : 'NA';
      loadDetailsScreenModel.loadingPoint2 =
          json['loadingPoint2'] != null ? json['loadingPoint2'] : 'NA';
      loadDetailsScreenModel.loadingPointState2 =
          json['loadingPointState2'] != null
              ? json['loadingPointState2']
              : 'NA';
      loadDetailsScreenModel.unloadingPointCity =
          json['unloadingPointCity'] != null
              ? json['unloadingPointCity']
              : 'NA';
      loadDetailsScreenModel.unloadingPoint =
          json['unloadingPoint'] != null ? json['unloadingPoint'] : 'NA';
      loadDetailsScreenModel.unloadingPointState =
          json['unloadingPointState'] != null
              ? json['unloadingPointState']
              : 'NA';
      loadDetailsScreenModel.unloadingPointCity2 =
          json['unloadingPointCity2'] != null
              ? json['unloadingPointCity2']
              : 'NA';
      loadDetailsScreenModel.unloadingPoint2 =
          json['unloadingPoint2'] != null ? json['unloadingPoint2'] : 'NA';
      loadDetailsScreenModel.unloadingPointState2 =
          json['unloadingPointState2'] != null
              ? json['unloadingPointState2']
              : 'NA';
      loadDetailsScreenModel.postLoadId = json['postLoadId'];
      loadDetailsScreenModel.truckType =
          json['truckType'] != null ? json['truckType'] : 'NA';
      loadDetailsScreenModel.weight =
          json['weight'] != null ? json['weight'] : 'NA';
      loadDetailsScreenModel.productType =
          json['productType'] != null ? json['productType'] : 'NA';
      loadDetailsScreenModel.rate =
          json['rate'] != null ? json['rate'].toString() : 'NA';
      loadDetailsScreenModel.unitValue =
          json['unitValue'] != null ? json['unitValue'] : 'NA';
      loadDetailsScreenModel.noOfTyres =
          json['noOfTyres'] != null ? json['noOfTyres'] : 'NA';
      loadDetailsScreenModel.loadDate =
          json['loadDate'] != null ? json['loadDate'] : 'NA';
      loadDetailsScreenModel.postLoadDate =
          json['postLoadDate'] != null ? json['postLoadDate'] : 'NA';
      loadDetailsScreenModel.status = json['status'];
      if (this.mounted) {
        setState(() {
          myLoadList.add(loadDetailsScreenModel);
        });
      }
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        bottomProgressLoad = false;
      });
    }
  }
}
