import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:get/get.dart';

import 'displayLoadsCard.dart';
import 'loadingWidget.dart';

// ignore: must_be_immutable
class LoadApiDataDisplayCard extends StatefulWidget {
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
  int? rate;
  String? unitValue;
  bool? ordered;

  LoadApiDataDisplayCard(
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
      this.ordered});

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  _LoadApiDataDisplayCardState createState() => _LoadApiDataDisplayCardState();
}

class _LoadApiDataDisplayCardState extends State<LoadApiDataDisplayCard> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadPosterDetailsFromApi(
            loadPosterId: widget.postLoadId.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          return DisplayLoadsCard(
            loadId: widget.loadId,
            loadingPoint: widget.loadingPoint,
            loadingPointCity: widget.loadingPointCity,
            loadingPointState: widget.loadingPointState,
            postLoadId: widget.postLoadId,
            unloadingPoint: widget.unloadingPoint,
            unloadingPointCity: widget.unloadingPointCity,
            unloadingPointState: widget.unloadingPointState,
            truckType: widget.truckType,
            productType: widget.productType,
            weight: widget.weight,
            status: widget.status,
            loadDate: widget.loadDate,
            comment: widget.comment,
            rate: widget.rate,
            unitValue: widget.unitValue,
            noOfTrucks: widget.noOfTrucks,
            loadPosterId: snapshot.data.loadPosterId,
            loadPosterPhoneNo: snapshot.data.loadPosterPhoneNo,
            loadPosterLocation: snapshot.data.loadPosterLocation,
            loadPosterName: snapshot.data.loadPosterName,
            loadPosterCompanyName: snapshot.data.loadPosterCompanyName,
            loadPosterKyc: snapshot.data.loadPosterKyc,
            loadPosterCompanyApproved: snapshot.data.loadPosterCompanyApproved,
            loadPosterApproved: snapshot.data.loadPosterApproved,
            loadPosterAccountVerificationInProgress:
                snapshot.data.loadPosterAccountVerificationInProgress,
          );
        });
  }
}
