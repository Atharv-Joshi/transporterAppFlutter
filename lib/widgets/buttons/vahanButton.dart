import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/responsive.dart';
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
          color: Responsive.isMobile(context) ? darkBlueColor : white,
          border: Border.all(color: darkBlueColor),
          borderRadius: BorderRadius.circular(space_2)),
      child: TextButton(
        onPressed: () {
          Responsive.isMobile(context)
              ? Get.to(() => VahanScreen(truckNo: truckNo))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                            visibleWidget: VahanScreen(truckNo: truckNo),
                            index: 1000,
                            selectedIndex: screens.indexOf(ordersScreen),
                          )),
                );
        },
        child: Text(
          Responsive.isMobile(context)
              ? "Verify Vehicle Details"
              : "View Detail",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Responsive.isMobile(context) ? white : darkBlueColor),
        ),
      ),
    );
  }
}
