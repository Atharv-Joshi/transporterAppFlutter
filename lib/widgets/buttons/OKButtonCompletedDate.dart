import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/bookingApiCallsOrders.dart';
import 'package:get/get.dart';

class OkButtonCompletedDate extends StatelessWidget {
  final String bookingId;
  OkButtonCompletedDate({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();
    return Container(
      width: space_16,
      height: space_6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(space_10),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: activeButtonColor),
          onPressed: () {
            bookingApiCallsOrders.updateBookingApi("20-08-2021", bookingId);
            Get.back();
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: size_6,
            ),
          ),
        ),
      ),
    );
  }
}
