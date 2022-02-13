import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bookingApiCallsOrders.dart';
import 'package:liveasy/widgets/alertDialog/completedOrdersAlertDialog.dart';

class CompletedButtonOrders extends StatelessWidget {
  final String bookingId;
  final double? fontSize;

  CompletedButtonOrders(
      {Key? key, required this.bookingId, required this.fontSize})
      : super(key: key);

  BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(shareButtonColor),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CompletedOrdersAlertDialog(
              bookingId: bookingId,
            );
          },
        );
      },
      child: Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            space_5,
            size_1,
            space_5,
            size_1,
          ),
          child: Text(
            'complete'.tr,
            // AppLocalizations.of(context)!.complete,
            style: TextStyle(
              letterSpacing: 0.7,
              fontWeight: normalWeight,
              color: white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
