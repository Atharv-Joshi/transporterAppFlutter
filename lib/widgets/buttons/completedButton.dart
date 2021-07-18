import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bookingApiCallsOrders.dart';
import 'package:liveasy/widgets/alertDialog/ProductTypeEnterAlertDialog.dart';
import 'package:liveasy/widgets/alertDialog/completedOrdersAlertDialog.dart';

class CompletedButton extends StatelessWidget {
  final String bookingId;
  CompletedButton({Key? key, required this.bookingId}) : super(key: key);

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
        print("$bookingId");
        // bookingApiCallsOrders.updateBookingApi("20-08-2021", bookingId);
      },
      child: Container(
        width: double.infinity,
        child: Text(
          'Completed',
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 0.7,
            fontWeight: mediumBoldWeight,
            color: white,
            fontSize: size_7,
          ),
        ),
      ),
    );
  }
}
