import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/responsive.dart';
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
      height: Responsive.isMobile(context) ? space_8 : space_6,
      width: Responsive.isMobile(context) ? space_26 : space_18 - 5,
      decoration: BoxDecoration(
          color: darkBlueColor,
          borderRadius: BorderRadius.circular(
              Responsive.isMobile(context) ? space_2 : space_1)),
      child: IconButton(
        onPressed: () {
          Responsive.isMobile(context)
          //onPressed user will be directed to MapScreen for displaying Fastag Details
              ? Get.to(() => MapScreen(
                    truckNumber: truckNo,
                    loadingPoint: loadingPoint,
                    unloadingPoint: unloadingPoint,
                  ))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                            visibleWidget: MapScreen(
                              truckNumber: truckNo,
                              loadingPoint: loadingPoint,
                              unloadingPoint: unloadingPoint,
                            ),
                            index: 1000,
                            selectedIndex: screens.indexOf(ordersScreen),
                          )),
                );
        },
        icon: Image.asset(
          'assets/icons/fastagButton.png',
          width: Responsive.isMobile(context) ? space_20 : space_18 - 5,
          height: Responsive.isMobile(context) ? space_5 : space_6,
        ),
      ),
    );
  }
}
