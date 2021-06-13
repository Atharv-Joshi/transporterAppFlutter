import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/widgets/displayLoadsCard.dart';
import 'loadingWidget.dart';

// ignore: must_be_immutable
class LoadApiDataDisplayCard extends StatefulWidget {
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

  LoadApiDataDisplayCard({
    this.loadId,
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
  });

  @override
  _LoadApiDataDisplayCardState createState() => _LoadApiDataDisplayCardState();
}

class _LoadApiDataDisplayCardState extends State<LoadApiDataDisplayCard> {

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadPosterDetailsFromApi(loadPosterId: widget.id.toString()),
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
            unloadingPoint: widget.unloadingPoint,
            unloadingPointCity: widget.unloadingPointCity,
            truckType: widget.truckType,
            weight: widget.weight,
            noOfTrucks: widget.noOfTrucks,
            loadPosterId: snapshot.data.loadPosterId,
            loadPosterPhoneNo: snapshot.data.loadPosterPhoneNo,
            loadPosterLocation: snapshot.data.loadPosterLocation,
            loadPosterName: snapshot.data.loadPosterName,
            loadPosterCompanyName:
            snapshot.data.loadPosterCompanyName,
            loadPosterKyc: snapshot.data.loadPosterKyc,
            loadPosterCompanyApproved:
            snapshot.data.loadPosterCompanyApproved,
            loadPosterApproved: snapshot.data.loadPosterApproved,
          );
        });
  }
}