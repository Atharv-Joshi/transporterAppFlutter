import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bidApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/myLoadPages/biddingScreen.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AcceptButton extends StatelessWidget {

  String? bidId;
  String? loadId;
  bool? isBiddingDetails;
   bool? shipperApproved;
   bool? transporterApproved;
   bool? fromTransporterSide;
   bool? activeButtonCondition;

  AcceptButton({
    required this.bidId ,
    required this.isBiddingDetails ,
    this.shipperApproved,
    this.fromTransporterSide,
    this.loadId,
  this.transporterApproved});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    if(fromTransporterSide!){
      activeButtonCondition = (transporterApproved == false && shipperApproved == true) ;
    }
    else{
      activeButtonCondition = (transporterApproved == true && shipperApproved == false) ;
    }

    print('bid id : $bidId');
    return Container(
      height: isBiddingDetails! ? null : 31,
      width: isBiddingDetails! ? null : 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(
              activeButtonCondition! ?liveasyGreen : inactiveBidding),
        ),
        onPressed: activeButtonCondition!
            ?
            () {
          putBidForAccept(bidId);
          if(fromTransporterSide!){
            // providerData.updateIndex(3);
            providerData.updateLowerAndUpperNavigationIndex(3, 0);
            Get.offAll(NavigationScreen());
          }
          else{
            providerData.updateIndex(2);
            Get.offAll(NavigationScreen());
            Get.to(() => BiddingScreens(loadId: loadId, loadingPointCity: providerData.bidLoadingPoint, unloadingPointCity: providerData.bidUnloadingPoint));
          }
        }
        : null ,
        child: Container(
          margin: isBiddingDetails! ? EdgeInsets.symmetric(vertical: space_1 , horizontal: space_3) : null,
          child : Text(
            'Accept',
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_7,
            ),
          ),
        ),
      ),
    );
  }
}
