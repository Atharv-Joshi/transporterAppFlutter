import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/loadCardFooter.dart';
import 'package:liveasy/widgets/loadCardHeader.dart';

import 'alertDialog/verifyAccountNotifyAlertDialog.dart';

// ignore: must_be_immutable
class DisplayLoadsCard extends StatefulWidget {
  String? loadId;
  String? loadingPoint;
  String? loadingPointCity;
  String? loadingPointState;
  String? postLoadId;
  String? unloadingPoint;
  String? unloadingPointCity;
  String? unloadingPointState;
  String? productType;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  String? comment;
  String? status;
  String? loadDate;
  String? rate;
  String? unitValue;

  String? loadPosterId;
  String? loadPosterPhoneNo;
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  String? loadPosterKyc;
  String? loadPosterCompanyApproved;
  String? loadPosterApproved;
  String? loadPosterAccountVerificationInProgress;

  DisplayLoadsCard(
      {this.loadId,
      this.loadingPoint,
      this.loadingPointCity,
      this.loadingPointState,
      this.postLoadId,
      this.unloadingPoint,
      this.unloadingPointCity,
      this.unloadingPointState,
      this.productType,
      this.truckType,
      this.noOfTrucks,
      this.weight,
      this.comment,
      this.status,
      this.loadDate,
      this.rate,
      this.unitValue,
      this.loadPosterId,
      this.loadPosterPhoneNo,
      this.loadPosterLocation,
      this.loadPosterName,
      this.loadPosterCompanyName,
      this.loadPosterKyc,
      this.loadPosterCompanyApproved,
      this.loadPosterApproved,
      this.loadPosterAccountVerificationInProgress});

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
          if (tIdController.transporterApproved.value) {
            LoadDetailsScreenModel loadDetailsScreenModel =
                LoadDetailsScreenModel();
            loadDetailsScreenModel.loadId = widget.loadId;
            loadDetailsScreenModel.loadingPoint = widget.loadingPoint;
            loadDetailsScreenModel.loadingPointCity = widget.loadingPointCity;
            loadDetailsScreenModel.loadingPointState = widget.loadingPointState;
            loadDetailsScreenModel.postLoadId = widget.postLoadId;
            loadDetailsScreenModel.unloadingPoint = widget.unloadingPoint;
            loadDetailsScreenModel.unloadingPointCity =
                widget.unloadingPointCity;
            loadDetailsScreenModel.unloadingPointState =
                widget.unloadingPointState;
            loadDetailsScreenModel.productType = widget.productType;
            loadDetailsScreenModel.truckType = widget.truckType;
            loadDetailsScreenModel.noOfTrucks = widget.noOfTrucks;
            loadDetailsScreenModel.weight = widget.weight;
            loadDetailsScreenModel.comment = widget.comment;
            loadDetailsScreenModel.status = widget.status;
            loadDetailsScreenModel.loadDate = widget.loadDate;
            loadDetailsScreenModel.rate = widget.rate;
            loadDetailsScreenModel.unitValue = widget.unitValue;
            loadDetailsScreenModel.loadPosterId = widget.loadPosterId;
            loadDetailsScreenModel.phoneNo = widget.loadPosterPhoneNo;
            loadDetailsScreenModel.loadPosterLocation =
                widget.loadPosterLocation;
            loadDetailsScreenModel.loadPosterName = widget.loadPosterName;
            loadDetailsScreenModel.loadPosterCompanyName =
                widget.loadPosterCompanyName;
            loadDetailsScreenModel.loadPosterKyc = widget.loadPosterKyc;
            loadDetailsScreenModel.loadPosterCompanyApproved =
                widget.loadPosterCompanyApproved;
            loadDetailsScreenModel.loadPosterApproved =
                widget.loadPosterApproved;
            loadDetailsScreenModel.loadPosterAccountVerificationInProgress =
                widget.loadPosterAccountVerificationInProgress;

            Get.to(() => LoadDetailsScreen(
                loadDetailsScreenModel: loadDetailsScreenModel));
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
                loadingPointCity: widget.loadingPointCity,
                unloadingPointCity: widget.unloadingPointCity,
                truckType: widget.truckType,
                weight: widget.weight,
                productType: widget.productType,
                loadId: widget.loadId,
                rate: widget.rate,
                unitValue: widget.unitValue,
              ),
              SizedBox(
                height: space_2,
              ),
              LoadCardFooter(
                  loadPosterCompanyName: widget.loadPosterCompanyName,
                  /*loadPosterPhoneNo: widget.loadPosterPhoneNo*/)
            ],
          ),
        ),
      )
    ]);
  }
}
