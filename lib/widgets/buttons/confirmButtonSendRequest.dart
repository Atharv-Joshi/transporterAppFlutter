import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/postBookingApi.dart';

// ignore: must_be_immutable
class ConfirmButtonSendRequest extends StatefulWidget {
  String? loadId;
  String? rate;
  String? transporterId;
  String? unit;
  List truckId;

  ConfirmButtonSendRequest(
      {required this.loadId,
      required this.rate,
      required this.transporterId,
      required this.unit,
      required this.truckId});

  @override
  _ConfirmButtonSendRequestState createState() =>
      _ConfirmButtonSendRequestState();
}

class _ConfirmButtonSendRequestState extends State<ConfirmButtonSendRequest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        postBookingApi(widget.loadId, widget.rate, widget.transporterId,
            widget.unit, widget.truckId);
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
