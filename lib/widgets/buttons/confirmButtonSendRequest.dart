import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getLoadDetailsFromLoadId.dart';
import 'package:liveasy/functions/postBookingApi.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConfirmButtonSendRequest extends StatefulWidget {
  bool? directBooking;
  String? loadId;
  String? rate;
  String? transporterId;
  String? unit;
  List? truckId;
  String? postLoadId;
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  ConfirmButtonSendRequest(
      {required this.directBooking,
      this.loadId,
      this.rate,
      this.transporterId,
      this.unit,
      this.truckId,
      this.postLoadId,
      this.bidsModel,
      this.loadDetailsScreenModel});

  @override
  _ConfirmButtonSendRequestState createState() =>
      _ConfirmButtonSendRequestState();
}

class _ConfirmButtonSendRequestState extends State<ConfirmButtonSendRequest> {
  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (widget.directBooking == true) {
          postBookingApi(widget.loadId, widget.rate, widget.unit,
              widget.truckId, widget.postLoadId, context);
          print("directBooking");
        } else {
          postBookingApi(
              widget.bidsModel!.loadId,
              widget.bidsModel!.rate,
              widget.bidsModel!.unitValue,
              widget.truckId,
              widget.loadDetailsScreenModel!.postLoadId,
              context);
          print("Booking by bid");
        }
        providerData.updateDropDownValue1(newValue: null);
        providerData.updateDropDownValue2(newValue: null);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(
                color: white, fontWeight: normalWeight, fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}
