import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/postBidApi.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BidButtonSendRequest extends StatelessWidget {
  String loadId, unitValue;

  BidButtonSendRequest(this.loadId, this.unitValue);

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context, listen: false);
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
        onPressed: () {
          if (Provider.of<ProviderData>(context, listen: false)
              .bidButtonSendRequestState ==
              "false") {
            return null;
          } else {
            if (Provider.of<ProviderData>(context, listen: false).rate == "" ||
                Provider.of<ProviderData>(context, listen: false).rate ==
                    null) {
              return null;
            } else {
              postBidAPi(
                  loadId,
                  Provider.of<ProviderData>(context, listen: false).rate,
                  tIdController.transporterId.value,
                  unitValue);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bidding Request Send')));
              providerData.updateRate("");
              providerData.updateBidButtonSendRequest(newValue: "false");
              Navigator.of(context).pop();
            }
          }
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius_4),
                )),
            overlayColor:
            Provider.of<ProviderData>(context).bidButtonSendRequestState ==
                "true"
                ? null
                : MaterialStateProperty.all(Colors.transparent),
            backgroundColor:
            Provider.of<ProviderData>(context).bidButtonSendRequestState ==
                "true"
                ? activeButtonColor
                : deactiveButtonColor),
      ),
    );
  }
}