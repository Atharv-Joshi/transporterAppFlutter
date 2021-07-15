import 'package:flutter/material.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/middleDataforOrderSideBids.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/widgets/biddingsCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import '../widgets/loadingWidget.dart';
import 'package:get/get.dart';

class GetBids extends StatefulWidget {
  @override
  _GetBidsState createState() => _GetBidsState();
}

class _GetBidsState extends State<GetBids> {

  final String biddingApiUrl = FlutterConfig.get('biddingApiUrl');

  int i = 0;

  late List jsonData;

  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  List<BiddingModel> biddingModelList = [];

    getBidsFromBidApi(int i) async {
    http.Response response = await http.get(Uri.parse("$biddingApiUrl?transporterId=${transporterIdController.transporterId.value}&pageNo=$i"));
    jsonData = json.decode(response.body);
    for (var json in jsonData) {
      BiddingModel biddingModel = BiddingModel();
      biddingModel.bidId = json["bidId"];
      biddingModel.transporterId = json["transporterId"];
      biddingModel.loadId = json["loadId"];
      biddingModel.currentBid = json["currentBid"].toString();
      biddingModel.previousBid = json['previousBid'].toString();
      biddingModel.unitValue = json["unitValue"];
      biddingModel.truckIdList = json["truckId"];
      biddingModel.shipperApproval= json["shipperApproval"];
      biddingModel.transporterApproval = json['transporterApproval'];
      biddingModel.biddingDate = json['biddingDate'];
      setState(() {
        biddingModelList.add(biddingModel);
      });

    }
  }

  @override
  void initState() {

    super.initState();

    getBidsFromBidApi(i);


    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getBidsFromBidApi(i + 1);
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
      height: MediaQuery.of(context).size.height * 0.67,
      child: ListView.builder(
          controller: scrollController,
          itemCount: biddingModelList.length,
          itemBuilder: (context,index){
            if(biddingModelList.length == 0){
              return LoadingWidget();
            }
            return FutureBuilder(
              future : MiddleDataForOrderSideBids(loadId: biddingModelList[index].loadId),
              builder: (BuildContext context,
                  AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return LoadingWidget();
                }
                return Text('');
                // return BiddingsCard(
                //   loadId: biddingModelList[index].loadId,
                //   loadingPointCity:snapshot.data['loadingPointCity'],
                //   unloadingPointCity: snapshot.data['unloadingPointCity'],
                //   currentBid: biddingModelList[index].currentBid,
                //   previousBid: biddingModelList[index].previousBid,
                //   unitValue: biddingModelList[index].unitValue,
                //   companyName: snapshot.data['loadPosterModel'].loadPosterCompanyName,
                //   biddingDate: biddingModelList[index].biddingDate,
                //   bidId: biddingModelList[index].bidId,
                //   transporterPhoneNum: snapshot.data['loadPosterModel'].loadPosterPhoneNo,
                //   transporterLocation: snapshot.data['loadPosterModel'].loadPosterLocation,
                //   transporterName:  snapshot.data['loadPosterModel'].loadPosterName,
                //   shipperApproved:  biddingModelList[index].shipperApproval,
                //   transporterApproved: biddingModelList[index].transporterApproval,
                //   loadPostApproval: snapshot.data['loadPosterModel'].loadPosterCompanyApproved,
                // );
              },
            );
          }
          )
    );

  }
}
