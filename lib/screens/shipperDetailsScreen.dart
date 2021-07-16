import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
import 'package:liveasy/widgets/shipperPosterDetails.dart';

import 'TransporterOrders/OrderButtons/completedButtonOrders.dart';

class ShipperDetails extends StatefulWidget {
  String? loadingPoint;
  String? unloadingPoint;
  String? vehicleNo;
  int? rate;
  String? shipperPosterLocation;
  String? shipperPosterName;
  String? shipperPosterCompanyName;
  bool? shipperPosterCompanyApproved;
  String? posterName;
  String? truckType;
  String? noOfTrucks;
  String? productType;
  String? bookingId;

  ShipperDetails({
    Key? key,
    this.posterName,
    this.truckType,
    this.noOfTrucks,
    this.productType,
    this.loadingPoint,
    this.unloadingPoint,
    this.vehicleNo,
    this.rate,
    this.shipperPosterLocation,
    this.shipperPosterName,
    this.shipperPosterCompanyName,
    this.shipperPosterCompanyApproved,
    this.bookingId,
  }) : super(key: key);

  @override
  _ShipperDetailsState createState() => _ShipperDetailsState();
}

class _ShipperDetailsState extends State<ShipperDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: space_2),
          child: Column(
            children: [
              SizedBox(
                height: space_4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButtonWidget(),
                  SizedBox(
                    width: space_3,
                  ),
                  HeadingTextWidget("Order Details"),
                  // HelpButtonWidget(),
                ],
              ),
              SizedBox(
                height: space_3,
              ),
              Stack(
                children: [
                  ShipperPosterDetails(
                    shipperPosterCompanyApproved:
                        widget.shipperPosterCompanyApproved,
                    shipperPosterName: widget.shipperPosterName,
                    shipperPosterLocation: widget.shipperPosterLocation,
                    shipperPosterCompanyName: widget.shipperPosterCompanyName,
                  ),
                ],
              ),
              SizedBox(
                height: space_5,
              ),
              Card(
                elevation: 5,
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(space_3, space_2, space_3, space_3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LoadLabelValueRowTemplate(
                          value:
                              "${widget.loadingPoint}-${widget.unloadingPoint}",
                          label: 'Location'),
                      LoadLabelValueRowTemplate(
                          value: widget.vehicleNo, label: 'Truck no.'),
                      LoadLabelValueRowTemplate(
                          value: widget.truckType, label: 'Truck Type'),
                      LoadLabelValueRowTemplate(
                          value: widget.noOfTrucks, label: 'No.Of Trucks'),
                      LoadLabelValueRowTemplate(
                          value: widget.productType, label: 'Product Type'),
                      LoadLabelValueRowTemplate(
                          value: "Rs.${widget.rate}/tonne", label: 'Price'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: space_2,
              ),
              CompletedButtonOrders(
                bookingId: widget.bookingId!,
                fontSize: size_9,
              )
            ],
          ),
        ),
      ),
    );
  }
}
