import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bidApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/alertDialog/alreadyBidDialog.dart';
import 'package:liveasy/widgets/alertDialog/loadingAlertDialog.dart';
import 'package:liveasy/widgets/alertDialog/CompletedDialog.dart';
import 'package:liveasy/widgets/alertDialog/orderFailedAlertDialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BidButtonSendRequest extends StatelessWidget {
  String? loadId;
  String? bidId;
  bool? isPost;
  bool? isNegotiating;

  BidButtonSendRequest({
    this.loadId,
    this.bidId,
    required this.isPost,
    required this.isNegotiating,
  });

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData =
        Provider.of<ProviderData>(context, listen: false);
    getBidData() async {
      String? bidResponse = "";
      if (bidResponse == "") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LoadingAlertDialog();
          },
        );
      }

      isPost!
          ? bidResponse = await postBidAPi(loadId, providerData.rate1,
              tIdController.transporterId.value, providerData.unitValue1)
          : putBidForNegotiate(
              bidId, providerData.rate1, providerData.unitValue1);

      if (bidResponse == "success") {
        print(bidResponse);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return completedDialog(
              upperDialogText: "You have completed the bid!",
              lowerDialogText: "wait for the shippers response",
            );
          },
        );
        Timer(
            Duration(seconds: 3),
            () => {
                  providerData.updateUpperNavigatorIndex(0),
                  providerData.updateIndex(3),
                  Get.offAll(() => NavigationScreen()),
                  providerData.updateBidButtonSendRequest(false),
                });
      } else if (bidResponse == "conflict") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlreadyBidDialog();
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OrderFailedAlertDialog();
          },
        );
        // Get.snackbar("${postLoadErrorController.error.value}", "failed");
        // postLoadErrorController.resetPostLoadError();
        // print(postLoadErrorController.error.value.toString());
        // Timer(
        //     Duration(seconds: 1),
        //     () => {
        //           showDialog(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return OrderFailedAlertDialog(
        //                   postLoadErrorController.error.value.toString());
        //             },
        //           )
        //         });
      }
    }

    return Container(
      margin: EdgeInsets.only(right: space_3),
      height: space_6 + 1,
      width: space_16,
      child: TextButton(
        child: Center(
          child: Text(
            "Bid",
            style: TextStyle(
                color: Colors.white,
                fontWeight: normalWeight,
                fontSize: size_6 + 2),
          ),
        ),
        onPressed: providerData.bidButtonSendRequestState
            ? () {
                getBidData();
              }
            : null,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius_4),
            )),
            overlayColor: providerData.bidButtonSendRequestState == true
                ? null
                : MaterialStateProperty.all(Colors.transparent),
            backgroundColor: providerData.bidButtonSendRequestState == true
                ? activeButtonColor
                : deactiveButtonColor),
      ),
    );
  }
}
