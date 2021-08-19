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
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/buttons/confirmOrderButton.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';

import 'LoadEndPointTemplate.dart';
import 'linePainter.dart';

class BiddingsCardTransporterSide extends StatelessWidget {
  BiddingModel biddingModel;
  String orderStatus = '';
  Color orderStatusColor = Colors.white;

  BiddingsCardTransporterSide({
    required this.biddingModel
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
    // else if(biddingModel.transporterApproval == true && biddingModel.shipperApproval == true){
    //   orderStatus = 'Bid accepted by shipper ! Confirm to continue!';
    //   orderStatusColor = liveasyGreen;
    // }
    // else if(biddingModel.transporterApproval == false && biddingModel.shipperApproval == true){
    //   orderStatus = 'Shipper updated price. Confirm to continue';
    //   orderStatusColor = liveasyGreen;
    // }


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
          companyName: biddingModel.loadPosterCompanyName,
          biddingDate:  biddingModel.biddingDate,
          transporterPhoneNum: biddingModel.loadPosterPhoneNo,
          transporterName : biddingModel.loadPosterName,
          transporterLocation: biddingModel.loadPosterLocation,
          shipperApproved:  biddingModel.shipperApproval,
          transporterApproved:  biddingModel.transporterApproval,
          isLoadPosterVerified: biddingModel.loadPosterCompanyApproved,
          fromTransporterSide: true,
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
                          LoadEndPointTemplate(text: biddingModel.loadingPointCity, endPointType: 'loading'),

                          Container(
                              padding: EdgeInsets.only(left: 2),
                              height: space_3,
                              width: space_12,
                              child: CustomPaint(
                                foregroundPainter: LinePainter(height: space_3),
                              )
                          ),

                          LoadEndPointTemplate(text: biddingModel.unloadingPointCity, endPointType: 'unloading'),
                        ],
                      ),

                      SizedBox(height: space_2,),
                      NewRowTemplate(label: 'Shipper', value: biddingModel.loadPosterCompanyName!.length > 24 ? biddingModel.loadPosterCompanyName!.substring(0,22) + '..' : biddingModel.loadPosterCompanyName , width: 98,),
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
                              ),
                            ),
                            CallButton(directCall: true , phoneNum: biddingModel.loadPosterPhoneNo,),
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
                      ConfirmOrderButton(
                        biddingModel: biddingModel ,
                        postLoadId : biddingModel.postLoadId,
                        shipperApproval: biddingModel.shipperApproval,
                        transporterApproval: biddingModel.transporterApproval,)
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