import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/CompletedDateController.dart';
import 'package:liveasy/functions/bookingApiCallsOrders.dart';
import 'package:get/get.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

import '../completedTextField.dart';

class OkButtonCompletedDate extends StatelessWidget {
  CompletedDateController completedDateController =
      Get.find<CompletedDateController>();
  final String bookingId;
  OkButtonCompletedDate({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();
    ProviderData providerData = Provider.of<ProviderData>(context);
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
            Navigator.of(context).pop();
            providerData.updateLowerAndUpperNavigationIndex(3, 2);
            Get.offAll(() => NavigationScreen());
            completedController.text = "";
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
