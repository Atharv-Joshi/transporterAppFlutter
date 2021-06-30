import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/CompletedDateController.dart';
import 'package:liveasy/screens/TransporterOrders/OrderApi/bookingApiCallsOrders.dart';
import 'package:get/get.dart';

import '../completedTextField.dart';

class OkButtonCompletedDate extends StatelessWidget {
  CompletedDateController completedDateController =
      Get.find<CompletedDateController>();
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
            bookingApiCallsOrders.updateBookingApi(
                completedDateController.completedDate.value, bookingId);
            Get.back();
            completedController.text = "";
            print(completedDateController.completedDate.value);
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
