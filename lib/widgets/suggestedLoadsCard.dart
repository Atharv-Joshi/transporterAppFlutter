import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'loadCardFooter.dart';
import 'loadCardHeader.dart';
import 'loadingWidget.dart';
import 'package:get/get.dart';

class SuggestedLoadsCard extends StatefulWidget {
  final LoadDetailsScreenModel loadDetailsScreenModel;


  SuggestedLoadsCard(
      {
        required this.loadDetailsScreenModel,

      }
      );

  @override
  _SuggestedLoadsCardState createState() => _SuggestedLoadsCardState();
}

class _SuggestedLoadsCardState extends State<SuggestedLoadsCard> {

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            if (tIdController.transporterApproved.value) {
              Get.to(() => LoadDetailsScreen(loadDetailsScreenModel: widget.loadDetailsScreenModel));
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
                  loadDetails: widget.loadDetailsScreenModel,
                ),
                LoadCardFooter(
                    loadPosterCompanyName:widget.loadDetailsScreenModel.loadPosterCompanyName.toString(),
                    loadPosterPhoneNo: widget.loadDetailsScreenModel.phoneNo.toString(),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

