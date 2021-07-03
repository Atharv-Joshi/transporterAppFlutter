import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'displayLoadsCard.dart';
import 'loadingWidget.dart';

class LoadApiDataDisplayCard extends StatefulWidget {
  final LoadApiModel loadApiData;

  LoadApiDataDisplayCard({required this.loadApiData});

  @override
  _LoadApiDataDisplayCardState createState() => _LoadApiDataDisplayCardState();
}

class _LoadApiDataDisplayCardState extends State<LoadApiDataDisplayCard> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadPosterDetailsFromApi(
            loadPosterId: widget.loadApiData.postLoadId.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          LoadDetailsScreenModel loadDetails = LoadDetailsScreenModel(
            loadId: widget.loadApiData.loadId,
            loadingPoint: widget.loadApiData.loadingPoint,
            loadingPointCity: widget.loadApiData.loadingPointCity,
            loadingPointState: widget.loadApiData.loadingPointState,
            postLoadId: widget.loadApiData.postLoadId,
            unloadingPoint: widget.loadApiData.unloadingPoint,
            unloadingPointCity: widget.loadApiData.unloadingPointCity,
            unloadingPointState: widget.loadApiData.unloadingPointState,
            truckType: widget.loadApiData.truckType,
            productType: widget.loadApiData.productType,
            weight: widget.loadApiData.weight,
            loadDate: widget.loadApiData.loadDate,
            noOfTrucks: widget.loadApiData.noOfTrucks,
            status: widget.loadApiData.status,
            rate: widget.loadApiData.rate,
            unitValue: widget.loadApiData.unitValue,
            loadPosterId: snapshot.data.loadPosterId,
            phoneNo: snapshot.data.loadPosterPhoneNo,
            loadPosterLocation: snapshot.data.loadPosterLocation,
            loadPosterName: snapshot.data.loadPosterName,
            loadPosterCompanyName: snapshot.data.loadPosterCompanyName,
            loadPosterKyc: snapshot.data.loadPosterKyc,
            loadPosterCompanyApproved: snapshot.data.loadPosterCompanyApproved,
            loadPosterApproved: snapshot.data.loadPosterApproved,
          );
          return DisplayLoadsCard(
            loadDetails: loadDetails,
          );
        });
  }
}
