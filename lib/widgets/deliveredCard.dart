import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';

import 'linePainter.dart';

class DeliveredCard extends StatelessWidget {
  final String loadingPoint;
  final String unloadingPoint;
  final String startedOn;
  final String endedOn;
  final String truckNo;
  String companyName;
  // final String phoneNum;
  String driverName;
  // final String imei;

  DeliveredCard({
    required this.loadingPoint,
    required this.unloadingPoint,
    required this.startedOn,
    required this.endedOn,
    required this.truckNo,
    required this.companyName,
    // required this.phoneNum,
    required this.driverName,
    // required this.imei
  });

  @override
  Widget build(BuildContext context) {
    driverName = driverName.length >= 12
        ? driverName.substring(0, 10) + '..'
        : driverName;
    companyName = companyName.length >= 15
        ? companyName.substring(0, 13) + '..'
        : companyName;
    return Container(
      child: Card(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(space_4),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoadEndPointTemplate(
                              text: loadingPoint, endPointType: 'loading'),
                          Container(
                              padding: EdgeInsets.only(left: 2),
                              height: space_6,
                              width: space_12,
                              child: CustomPaint(
                                foregroundPainter: LinePainter(),
                              )),
                          LoadEndPointTemplate(
                              text: unloadingPoint, endPointType: 'unloading'),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: space_4),
                    child: Column(
                      children: [
                        LoadLabelValueRowTemplate(
                            value: truckNo, label: 'Truck No.'),
                        LoadLabelValueRowTemplate(
                            value: driverName, label: 'Driver Name'),
                        LoadLabelValueRowTemplate(
                            value: startedOn, label: 'Started on'),
                        LoadLabelValueRowTemplate(
                            value: endedOn, label: 'Ended on'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: contactPlaneBackground,
              padding:
                  EdgeInsets.symmetric(vertical: space_4, horizontal: space_3),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: space_1),
                    child: Image(
                        height: 16,
                        width: 23,
                        color: black,
                        image: AssetImage('assets/icons/TruckIcon.png')),
                  ),
                  Text(
                    companyName,
                    style: TextStyle(
                      color: liveasyBlackColor,
                      fontWeight: mediumBoldWeight,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
