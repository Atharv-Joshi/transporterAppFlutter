import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TransporterOrders/OrderButtons/trackButtonOrder.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
import 'linePainter.dart';

class OngoingCard extends StatelessWidget {
  //variables
  final String loadingPoint;
  final String unloadingPoint;
  final String startedOn;
  final String endedOn;
  final String truckNo;
  String companyName;
  final String driverPhoneNum;
  String driverName;
  final String imei;
  final String transporterPhoneNumber;
  // final String transporterName;

  OngoingCard({
    required this.loadingPoint,
    required this.unloadingPoint,
    required this.startedOn,
    required this.endedOn,
    required this.truckNo,
    required this.companyName,
    required this.driverPhoneNum,
    required this.driverName,
    required this.imei,
    required this.transporterPhoneNumber,
    // required this.transporterName,
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
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: space_1),
                            child: Image(
                                height: 16,
                                width: 23,
                                color: black,
                                image:
                                    AssetImage('assets/icons/TruckIcon.png')),
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
                            value: startedOn, label: 'Started on')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: contactPlaneBackground,
              padding: EdgeInsets.symmetric(
                vertical: space_2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TrackButton(truckApproved: false),
                  CallButton(
                    directCall: false,
                    transporterPhoneNum: transporterPhoneNumber.toString(),
                    driverPhoneNum: driverPhoneNum,
                    driverName: driverName,
                    transporterName: companyName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
