import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/screens/myLoadPages/biddingDetails.dart';
import 'package:liveasy/widgets/buttons/CancelBidButton.dart';
import 'package:liveasy/widgets/buttons/acceptButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:liveasy/widgets/buttons/confirmOrderButton.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';

import 'LoadEndPointTemplate.dart';
import 'linePainter.dart';

class BiddingsCardTransporterSide extends StatelessWidget {
  BiddingModel biddingModel;
  final String? loadingPointCity;
  final String? unloadingPointCity;
  final String? companyName;
  final String? transporterPhoneNum;
  final String? transporterName;
  final String? transporterLocation;
  final bool? loadPostApproval;
  String orderStatus = '';
  Color orderStatusColor = Colors.white;

  BiddingsCardTransporterSide({
    required this.biddingModel,
    required this.loadPostApproval,
    required this.loadingPointCity ,
    required this.unloadingPointCity,
    required this.companyName,
    required this.transporterPhoneNum,
    required this.transporterName,
    required this.transporterLocation,
  });

  @override
  Widget build(BuildContext context) {

    biddingModel.unitValue = biddingModel.unitValue == 'PER_TON' ? 'tonne' : 'truck';


     if(biddingModel.transporterApproval == false && biddingModel.shipperApproval == false){
      orderStatus = 'Order Cancelled';
      orderStatusColor = red;
    }
    else if(biddingModel.transporterApproval == true && biddingModel.shipperApproval == false){
      orderStatus = 'Waiting for response';
      orderStatusColor = liveasyOrange;
    }

    return GestureDetector(
      onTap: biddingModel.shipperApproval == false && biddingModel.transporterApproval == false
          ? null
          : (){
        Get.to(()=> BiddingDetails(
          biddingModel: biddingModel,
          loadId :  biddingModel.loadId,
          bidId:  biddingModel.bidId,
          rate:  biddingModel.currentBid,
          unitValue:  biddingModel.unitValue,
          companyName: companyName,
          biddingDate:  biddingModel.biddingDate,
          transporterPhoneNum: transporterPhoneNum,
          transporterName : transporterName,
          transporterLocation: transporterLocation,
          shipperApproved:  biddingModel.shipperApproval,
          transporterApproved:  biddingModel.transporterApproval,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: space_2),
        child: Card(
          elevation: 3,
          child: Container(
            color: biddingModel.shipperApproval == false && biddingModel.transporterApproval == false ? cancelledBiddingBackground : Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
                  child: Column(
                    children: [
                      Container(
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bidding date : ${biddingModel.biddingDate}',
                              style: TextStyle(
                                  fontSize: size_6,
                                  color: veryDarkGrey
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoadEndPointTemplate(text: loadingPointCity, endPointType: 'loading'),

                          Container(
                              padding: EdgeInsets.only(left: 2),
                              height: space_3,
                              width: space_12,
                              child: CustomPaint(
                                foregroundPainter: LinePainter(height: space_3),
                              )
                          ),

                          LoadEndPointTemplate(text: unloadingPointCity, endPointType: 'unloading'),
                        ],
                      ),

                      SizedBox(height: space_2,),
                      NewRowTemplate(label: 'Shipper', value: companyName!.length > 24 ? companyName!.substring(0,22) + '..' : companyName),
                      biddingModel.previousBid != 'NA' ?  NewRowTemplate(label: ' Previous Bidding', value: 'Rs.${ biddingModel.previousBid}/${biddingModel.unitValue}') : Container(),
                      NewRowTemplate(label: 'Current Bidding', value: 'Rs.${biddingModel.currentBid}/${biddingModel.unitValue}'),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: space_2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              orderStatus,
                              style: TextStyle(
                                color: orderStatusColor,
                                fontWeight:  mediumBoldWeight,
                                fontSize: size_8,
                              ),),
                            CallButton(directCall: true , phoneNum: transporterPhoneNum,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                biddingModel.shipperApproval == false && biddingModel.transporterApproval == false

                    ? Container()
                    :  Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: contactPlaneBackground,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CancelBidButton(biddingModel:  biddingModel, active: !(biddingModel.shipperApproval == false && biddingModel.transporterApproval == false)),
                      ConfirmOrderButton(biddingModel: biddingModel)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
