import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/widgets/alertDialog/bidButtonAlertDialog.dart';

// ignore: must_be_immutable
class NegotiateButton extends StatelessWidget {

  final String? bidId;

  NegotiateButton(
      {
        required this.bidId,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 90,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>  BidButtonAlertDialog(isPost: false , bidId:  bidId,));
        },
        child: Container(
          child : Text(
                'Negotiate',
                style: TextStyle(
                  fontWeight: normalWeight,
                  color: white,
                  fontSize: size_6,
                ),
              ),
        ),
      ),
    );
  }
}
