import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/biddingsCard.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

class BiddingScreens extends StatefulWidget {




  final String? loadId;
  final String? loadingPointCity;
  final String? unloadingPointCity;

  BiddingScreens({required this.loadId , required this.loadingPointCity , required this.unloadingPointCity});

  @override
  _BiddingScreensState createState() => _BiddingScreensState();
}


class _BiddingScreensState extends State<BiddingScreens> {

  final String biddingApiUrl = FlutterConfig.get('biddingApiUrl');

  int i = 0;

  late List jsonData;

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  List<BiddingModel> biddingModelList = [];

  getBidDataByLoadId(int i) async {

    http.Response response = await http.get(Uri.parse('$biddingApiUrl?loadId=${widget.loadId}&pageNo=$i'));
    jsonData = json.decode(response.body);

    for(var json in jsonData){
      BiddingModel biddingModel = BiddingModel();
      biddingModel.bidId = json['bidId'];
      biddingModel.transporterId = json['transporterId'];
      biddingModel.currentBid = json['currentBid'] == null ? 'NA' : json['currentBid'].toString() ;
      biddingModel.previousBid =json['previousBid'] == null ? 'NA' : json['previousBid'].toString() ;
      biddingModel.unitValue = json['unitValue'];
      biddingModel.loadId = json['loadId'];
      biddingModel.biddingDate = json['biddingDate'] != null ? json['biddingDate'] : 'NA';
      biddingModel.truckIdList = json['truckId'];
      biddingModel.transporterApproval = json['transporterApproval'];
      biddingModel.shipperApproval = json['shipperApproval'];
      setState(() {
        biddingModelList.add(biddingModel);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBidDataByLoadId(i);


    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getBidDataByLoadId(i + 1);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:Container(
            margin: EdgeInsets.symmetric(vertical: space_4 , horizontal: space_4),
            child: Column(
              children: [
                Header(reset: false, text: 'Biddings', backButton: true),
                Container(
                  margin: EdgeInsets.only(top: space_1),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.83,
                  child: biddingModelList.isEmpty ? Text('No bids yet') : ListView.builder(
                      itemCount: biddingModelList.length ,
                      itemBuilder: (context,index){
                        if(biddingModelList.length == 0){
                          return LoadingWidget();
                        }
                        return FutureBuilder(
                          future : transporterApiCalls.getDataByTransporterId(biddingModelList[index].transporterId),
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return LoadingWidget();
                            }
                            return BiddingCard(
                              loadId: widget.loadId,
                              loadingPointCity: widget.loadingPointCity,
                              unloadingPointCity:  widget.unloadingPointCity,
                              currentBid: biddingModelList[index].currentBid,
                              previousBid: biddingModelList[index].previousBid,
                              unitValue: biddingModelList[index].unitValue,
                              companyName: snapshot.data.companyName,
                              biddingDate: biddingModelList[index].biddingDate,
                              bidId: biddingModelList[index].bidId,
                              transporterPhoneNum: snapshot.data.transporterPhoneNum ,
                              transporterLocation: snapshot.data.transporterLocation,
                              transporterName: snapshot.data.transporterName,
                              shipperApproved: biddingModelList[index].shipperApproval,
                              transporterApproved: biddingModelList[index].transporterApproval,
                              loadPostApproval: snapshot.data.companyApproved,
                            );
                          },
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }}//class end
