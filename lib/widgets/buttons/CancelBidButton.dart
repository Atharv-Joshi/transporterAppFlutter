import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/functions/bidApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CancelBidButton extends StatelessWidget {
  BiddingModel biddingModel;

  final bool? active;

  CancelBidButton({required this.biddingModel, required this.active});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    NavigationIndexController navigationIndexController =
    Get.find<NavigationIndexController>();
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(
              active! ? bidBackground : inactiveBidding),
        ),
        onPressed: active!
            ? () {
          declineBidFromTransporterSideSide(
              bidId: biddingModel.bidId!,
              approvalVariable: biddingModel.transporterApproval == true
                  ? 'transporterApproval'
                  : 'shipperApproval');
          Get.offAll(NavigationScreen());
          navigationIndexController.updateIndex(3);
        }
            : null,
        child: Container(
          child: Text(
            "cancel".tr,
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
