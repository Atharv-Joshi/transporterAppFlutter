import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import '../../screens/fastagScreen.dart';

class FastagButton extends StatelessWidget {
  final String? bookingDate;
  final String? truckNo;
  String? loadingPoint;
  String? unloadingPoint;

  FastagButton(
      {this.truckNo, this.loadingPoint, this.unloadingPoint, this.bookingDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: space_26,
      decoration: BoxDecoration(
          color: darkBlueColor, borderRadius: BorderRadius.circular(space_2)),
      child: IconButton(
        onPressed: () {
          Get.to(() => FastagScreen(
                bookingDate: bookingDate,
                truckNo: truckNo,
                loadingPoint: loadingPoint,
                unloadingPoint: unloadingPoint,
              ));
        },
        icon: Image.asset(
          'assets/icons/fastagButton.png',
          width: space_20,
          height: space_5,
        ),
      ),
    );
  }
}
