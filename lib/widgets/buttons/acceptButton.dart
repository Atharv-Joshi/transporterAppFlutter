import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bidApiCalls.dart';

// ignore: must_be_immutable
class AcceptButton extends StatelessWidget {

  String? bidId;
  bool? isBiddingDetails;
  final bool active;

  AcceptButton({required this.bidId , required this.isBiddingDetails , required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isBiddingDetails! ? null : 31,
      width: isBiddingDetails! ? null : 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(
              active ?liveasyGreen : inactiveBidding),
        ),
        onPressed: active ?
            () {
          putBidForAccept(bidId);
        }
        : null ,
        child: Container(
          margin: isBiddingDetails! ? EdgeInsets.symmetric(vertical: space_1 , horizontal: space_3) : null,
          child : Text(
            'Accept',
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_7,
            ),
          ),
        ),
      ),
    );
  }
}
