import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';

class AddTruckButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: space_33,
      height: space_8,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed:
            () {
          Get.to(() => AddNewTruck());
        },
        child: Text(
          'Add Truck',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: size_9,
            color: white,
          ),
        ),
      ),
    );
  }
}
