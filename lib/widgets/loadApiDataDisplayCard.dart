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
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadPosterDetailsFromApi(widget.loadId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);
          print(snapshot.hasData);
          print(snapshot);
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          return ListView.builder(
              itemCount: (snapshot.data.length),
              itemBuilder: (BuildContext context, index) => DisplayLoadsCard(
                    loadPosterId: snapshot.data[index].loadPosterId,
                    loadPosterPhoneNo: snapshot.data[index].loadPosterPhoneNo,
                    loadPosterLocation: snapshot.data[index].loadPosterLocation,
                    loadPosterName: snapshot.data[index].loadPosterName,
                    loadPosterCompanyName:
                        snapshot.data[index].loadPosterCompanyName,
                    loadPosterKyc: snapshot.data[index].loadPosterKyc,
                    loadPosterCompanyApproved:
                        snapshot.data[index].loadPosterCompanyApproved,
                    loadPosterApproved: snapshot.data[index].loadPosterApproved,
                  ));
        });
  }
}
