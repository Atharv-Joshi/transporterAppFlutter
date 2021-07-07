import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/alertDialog/bidButtonAlertDialog.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';

// ignore: must_be_immutable
class BidButton extends StatefulWidget {
  LoadDetailsScreenModel loadDetails;

  BidButton({required this.loadDetails});

  @override
  _BidButtonState createState() => _BidButtonState();
}

class _BidButtonState extends State<BidButton> {
  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (tIdController.transporterApproved.value) {
          await showDialog(
              context: context,
              builder: (context) => BidButtonAlertDialog(
                isPost: true,
                    loadId: widget.loadDetails.loadId,
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) => VerifyAccountNotifyAlertDialog());
        }
      },
      child: Container(
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "Bid",
            style: TextStyle(
                color: white, fontWeight: normalWeight, fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}
