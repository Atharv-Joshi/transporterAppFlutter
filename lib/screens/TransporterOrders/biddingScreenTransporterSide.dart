import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/middleDataforOrderSideBids.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/biddingsCardTransporterSide.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:get/get.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:provider/provider.dart';

class BiddingScreenTransporterSide extends StatefulWidget {
  @override
  _BiddingScreenTransporterSideState createState() =>
      _BiddingScreenTransporterSideState();
}

class _BiddingScreenTransporterSideState
    extends State<BiddingScreenTransporterSide> {
  final String biddingApiUrl = FlutterConfig.get('biddingApiUrl');

  int i = 0;

  late List jsonData;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  List<BiddingModel> biddingModelList = [];

  bool loading = false;

  List<TruckModel> truckDetailsList = [];

  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();

  getBidsFromBidApi(int i) async {
    http.Response response = await http.get(Uri.parse(
        "$biddingApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i"));
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      BiddingModel biddingModel = BiddingModel();
      biddingModel.bidId = json['bidId'] == null ? 'NA' : json['bidId'];
      biddingModel.transporterId =
          json['transporterId'] == null ? 'NA' : json['transporterId'];
      biddingModel.loadId = json['loadId'] == null ? 'NA' : json['loadId'];
      biddingModel.currentBid =
          json['currentBid'] == null ? 'NA' : json['currentBid'].toString();
      biddingModel.previousBid =
          json['previousBid'] == null ? 'NA' : json['previousBid'].toString();
      biddingModel.unitValue =
          json['unitValue'] == null ? 'NA' : json['unitValue'];
      biddingModel.truckIdList =
          json['truckId'] == null ? 'NA' : json['truckId'];
      biddingModel.shipperApproval = json["shipperApproval"];
      biddingModel.transporterApproval = json['transporterApproval'];
      biddingModel.biddingDate =
          json['biddingDate'] != null ? json['biddingDate'] : 'NA';
      setState(() {
        biddingModelList.add(biddingModel);
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });
    getBidsFromBidApi(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getBidsFromBidApi(i);
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
            : ListView.builder(
                controller: scrollController,
                itemCount: biddingModelList.length,
                itemBuilder: (context, index) {
                  if (biddingModelList.length == 0) {
                    //TODO:put empty bids pg
                    return Text('No Bids');
                  }
                  return FutureBuilder(
                    future: MiddleDataForOrderSideBids(
                        loadId: biddingModelList[index].loadId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        // return LoadingWidget();
                        return OnGoingLoadingWidgets();
                      }
                      print('bid id : ${biddingModelList[index].bidId}');
                      return BiddingsCardTransporterSide(
                        biddingModel: biddingModelList[index],
                        loadingPointCity: snapshot.data['loadingPointCity'],
                        unloadingPointCity: snapshot.data['unloadingPointCity'],
                        companyName: snapshot
                            .data['loadPosterModel'].loadPosterCompanyName,
                        transporterPhoneNum:
                            snapshot.data['loadPosterModel'].loadPosterPhoneNo,
                        transporterLocation:
                            snapshot.data['loadPosterModel'].loadPosterLocation,
                        transporterName:
                            snapshot.data['loadPosterModel'].loadPosterName,
                        isLoadPosterVerified: snapshot
                            .data['loadPosterModel'].loadPosterCompanyApproved,
                        postLoadId: snapshot.data['postLoadId'],
                      );
                    },
                  );
                }));
  }
}
