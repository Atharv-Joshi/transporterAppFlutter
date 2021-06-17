import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/cardLowerWidget.dart';
import 'package:liveasy/widgets/cardUpperWidget.dart';

import 'alertDialog/verifyAccountNotifyAlertDialog.dart';

// ignore: must_be_immutable
class DisplayLoadsCard extends StatefulWidget {
  String? loadId;
  String? loadingPoint;
  String? loadingPointCity;
  String? loadingPointState;
  String? id;
  String? unloadingPoint;
  String? unloadingPointCity;
  String? unloadingPointState;
  String? productType;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  String? comment;
  String? status;
  String? date;

  String? loadPosterId;
  String? loadPosterPhoneNo;
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  String? loadPosterKyc;
  String? loadPosterCompanyApproved;
  String? loadPosterApproved;

  DisplayLoadsCard(
      {this.loadId,
      this.loadingPoint,
      this.loadingPointCity,
      this.loadingPointState,
      this.id,
      this.unloadingPoint,
      this.unloadingPointCity,
      this.unloadingPointState,
      this.productType,
      this.truckType,
      this.noOfTrucks,
      this.weight,
      this.comment,
      this.status,
      this.date,
      this.loadPosterId,
      this.loadPosterPhoneNo,
      this.loadPosterLocation,
      this.loadPosterName,
      this.loadPosterCompanyName,
      this.loadPosterKyc,
      this.loadPosterCompanyApproved,
      this.loadPosterApproved});

  @override
  _DisplayLoadsCardState createState() => _DisplayLoadsCardState();
}

class _DisplayLoadsCardState extends State<DisplayLoadsCard> {
  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          // ignore: unrelated_type_equality_checks
          if (tIdController.transporterApproved ==
              false)//TODO: to be changed to true
          {
            Get.to(() => LoadDetailsScreen(
                loadId: widget.loadId,
                loadingPoint: widget.loadingPoint,
                loadingPointCity: widget.loadingPointCity,
                loadingPointState: widget.loadingPointState,
                id: widget.id,
                unloadingPoint: widget.unloadingPoint,
                unloadingPointCity: widget.unloadingPointCity,
                unloadingPointState: widget.unloadingPointCity,
                productType: widget.productType,
                truckType: widget.truckType,
                noOfTrucks: widget.noOfTrucks,
                weight: widget.weight,
                comment: widget.comment,
                status: widget.status,
                date: widget.date,
                loadPosterId: widget.loadPosterId,
                loadPosterPhoneNo: widget.loadPosterPhoneNo,
                loadPosterLocation: widget.loadPosterLocation,
                loadPosterName: widget.loadPosterName,
                loadPosterCompanyName: widget.loadPosterCompanyName,
                loadPosterKyc: widget.loadPosterKyc,
                loadPosterCompanyApproved: widget.loadPosterCompanyApproved,
                loadPosterApproved: widget.loadPosterApproved));
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
              CardUpperWidget(loadingPointCity: widget.loadingPointCity,
              unloadingPointCity: widget.unloadingPointCity,
              truckType: widget.truckType,
              weight: widget.weight,
              productType: widget.productType,
              loadId: widget.loadId,),
              SizedBox(
                height: space_2,
              ),
              CardLowerWidget(
                  loadPosterCompanyName: widget.loadPosterCompanyName,
                  loadPosterPhoneNo: widget.loadPosterPhoneNo)
            ],
          ),
        ),
      )
    ]);
  }
}
