import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'loadCardFooter.dart';
import 'loadCardHeader.dart';
import 'loadingWidget.dart';
import 'package:get/get.dart';

class SuggestedLoadsCard extends StatefulWidget {
  final LoadDetailsScreenModel model;

  SuggestedLoadsCard({required this.model});

  @override
  _SuggestedLoadsCardState createState() => _SuggestedLoadsCardState();
}

class _SuggestedLoadsCardState extends State<SuggestedLoadsCard> {

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadPosterDetailsFromApi(
            loadPosterId: widget.model.postLoadId.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          //saving load poster data in earlier model
          widget.model.loadPosterId =  snapshot.data.loadPosterId;
          widget.model.phoneNo = snapshot.data.loadPosterPhoneNo;
          widget.model.loadPosterLocation = snapshot.data.loadPosterLocation;
          widget.model.loadPosterName = snapshot.data.loadPosterName;
          widget.model.loadPosterCompanyName = snapshot.data.loadPosterCompanyName;
          widget.model.loadPosterKyc = snapshot.data.loadPosterKyc;
          widget.model.loadPosterCompanyApproved = snapshot.data.loadPosterCompanyApproved;
          widget.model.loadPosterApproved = snapshot.data.loadPosterApproved;

          return Container(
            margin: EdgeInsets.only(bottom: space_2),
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  if (tIdController.transporterApproved.value) {
                    Get.to(() => LoadDetailsScreen(loadDetails: widget.model));
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
                        loadDetails: widget.model,
                      ),

                      LoadCardFooter(
                          loadPosterCompanyName:
                          widget.model.loadPosterCompanyName,
                          loadPosterPhoneNo: widget.model.phoneNo)
                    ],
                  ),
                ),
              )
            ]),
          );
        }
        );
  }
}
