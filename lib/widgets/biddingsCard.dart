import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/myLoadPages/biddingDetails.dart';
import 'package:liveasy/widgets/buttons/acceptButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/buttons/negotiateButton.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
import 'package:liveasy/widgets/priceContainer.dart';

import 'LoadEndPointTemplate.dart';
import 'linePainter.dart';

class BiddingCard extends StatelessWidget {
  final String? loadId;
  final String? bidId;
  final String? loadingPointCity;
  final String? unloadingPointCity;
  final String? currentBid;
  final String? previousBid;
  final String? unitValue;
  final String? companyName;
  final String? biddingDate;
  final String? transporterPhoneNum;
  final String? transporterName;
  final String? transporterLocation;
  final bool? companyApproved;
  final bool? transporterApproved;

  BiddingCard({
    required this.loadId ,
    required this.loadingPointCity ,
    required this.unloadingPointCity,
    required this.biddingDate,
    required this.unitValue,
    required this.currentBid,
    required this.previousBid,
    required this.companyName,
    required this.transporterPhoneNum,
    required this.bidId,
    required this.transporterName,
    required this.transporterLocation,
    required this.companyApproved,
    required this.transporterApproved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> BiddingDetails(
          loadId : loadId,
          bidId: bidId,
          rate: currentBid,
          unitValue: unitValue,
          companyName: companyName,
          biddingDate: biddingDate,
          transporterPhoneNum: transporterPhoneNum,
          transporterName : transporterName,
          transporterLocation: transporterLocation,
          companyApproved: companyApproved,
          transporterApproved: transporterApproved,
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 3,
          child: Container(
            margin: EdgeInsets.all(space_4),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoadEndPointTemplate(text: loadingPointCity, endPointType: 'loading'),

                        Container(
                            padding: EdgeInsets.only(left: 2),
                            height: space_6,
                            width: space_12,
                            child: CustomPaint(
                              foregroundPainter: LinePainter(),
                            )
                        ),

                        LoadEndPointTemplate(text: unloadingPointCity, endPointType: 'unloading'),
                      ],
                    ),
                    PriceContainer(rate: currentBid , unitValue: unitValue,),
                  ],
                ),
                SizedBox(height: space_2,),
                LoadLabelValueRowTemplate(value: companyName!.length > 24 ? companyName!.substring(0,22) + '..' : companyName, label: 'Transporter'),
                LoadLabelValueRowTemplate(value: biddingDate, label: 'Bidding Date'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Confirmed'),
                    CallButton(directCall: true , phoneNum: transporterPhoneNum,),
                  ],
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0 , space_4 , 0 , 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: MediaQuery.of(context).size.width,
                  color: contactPlaneBackground,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NegotiateButton(bidId: bidId),
                      AcceptButton(
                        isBiddingDetails: false,
                          bidId : bidId
                      ),
                    ],
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
