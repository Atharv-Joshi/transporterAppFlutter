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
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/LoadPointTemplateForBidScreen.dart';
import 'package:liveasy/widgets/auctionDetails.dart';
import 'package:liveasy/widgets/buttons/auctionScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/placeBidButton.dart';

import 'auctionDetailsScreen.dart';
import 'indentScreen.dart';

Map data = {};
bool showDetails = false;
final TextEditingController textEditingController = TextEditingController();

class AuctionScreen extends StatefulWidget {
  @override
  _AuctionScreenState createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  List<LoadDetailsScreenModel> myLoadList = [];
  LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
  ScrollController scrollController = ScrollController();
  late PageController pageController;
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  List<LoadDetailsScreenModel> details = [];
  int i = 0;
  bool loading = false;
  bool bottomProgressLoad = false;
  String transporterId = "";
  int switchIndex = 0;

  String formatDate(String postLoadDate) {
    //To convert the date format as required.
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
    pageController = PageController(initialPage: 0);
    loading = true;
    getDataByPostLoadId();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  refresh() {
    setState(() {
      getDataByPostLoadId();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: teamBar,
        body: showDetails
            ? loadDetails(context)
            //loadDetails are contents of place bid screen.
            : Column(
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
                            Text(
                              //If index 0 displays auction screen else indent screen.
                              switchIndex == 0 ? 'Auction' : 'Indent',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            width: screenWidth * 0.3,
                            height: 50,
                            child: Card(
                              elevation: 10,
                              surfaceTintColor: transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: searchBar,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: greyDivider),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                                controller: textEditingController,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: space_3,
                  ),
                  Container(
                    child: Row(
                      children: [
                        AuctionScreenNavigationBarButton(
                            text: 'Bids',
                            value: 0,
                            pageController: pageController),
                        AuctionScreenNavigationBarButton(
                            text: 'Indent',
                            value: 1,
                            pageController: pageController),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        switchIndex = index;
                        setState(() {});
                        print(index);
                      },
                      children: [
                        AuctionDetailScreen(
                          changeScreen: () {
                            showDetails = !showDetails;
                            setState(() {});
                          },
                        ),
                        IndentScreen()
                      ],
                    ),
                  ),
                ],
              ));
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
  } //builder
} //class end
