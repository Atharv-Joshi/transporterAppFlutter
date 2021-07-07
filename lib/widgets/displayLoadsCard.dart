import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/MyLoadsCard.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/loadCardFooter.dart';
import 'package:liveasy/widgets/loadCardHeader.dart';

import 'alertDialog/verifyAccountNotifyAlertDialog.dart';

// ignore: must_be_immutable
class DisplayLoadsCard extends StatefulWidget {
  LoadDetailsScreenModel loadDetails;

  DisplayLoadsCard({
    required this.loadDetails,
  });

  @override
  _DisplayLoadsCardState createState() => _DisplayLoadsCardState();
}

class _DisplayLoadsCardState extends State<DisplayLoadsCard> {
  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            if (tIdController.transporterApproved.value) {
              Get.to(() => LoadDetailsScreen(loadDetails: widget.loadDetails));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => VerifyAccountNotifyAlertDialog());
            }
          },
          child: Card(
            elevation: elevation_2,
            child: Column(
              children: [
                LoadCardHeader(
                  loadDetails: widget.loadDetails,
                ),

                LoadCardFooter(
                    loadPosterCompanyName:
                        widget.loadDetails.loadPosterCompanyName,
                    loadPosterPhoneNo: widget.loadDetails.phoneNo)
              ],
            ),
          ),
        )
      ]),
    );
  }
}
