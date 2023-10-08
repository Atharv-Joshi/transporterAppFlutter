import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import '../../screens/vahanScreen.dart';

class VahanButton extends StatelessWidget {
  final String? truckNo;

  VahanButton({
    required this.truckNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: space_38,
      decoration: BoxDecoration(
          color: darkBlueColor, borderRadius: BorderRadius.circular(space_2)),
      child: TextButton(
        onPressed: () {
          Get.to(() => VahanScreen(truckNo: truckNo));
        },
        child: Text(
          "Verify Vehicle Details",
          style: TextStyle(color: white),
        ),
      ),
    );
  }
}
