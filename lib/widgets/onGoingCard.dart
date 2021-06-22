import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/callButton.dart';
import 'package:liveasy/widgets/loadLabelValueTemplate.dart';
import 'package:liveasy/widgets/trackButton.dart';
import 'linePainter.dart';

class OngoingCard extends StatelessWidget {

  //variables
  final String loadingPoint;
  final String unloadingPoint;
  final String startedOn;
  final String endedOn;
  final String truckNo;
  final String companyName;
  final String phoneNum;
  final String driverName;
  final String imei;

  OngoingCard({
    required this.loadingPoint,
    required this.unloadingPoint,
    required this.startedOn,
    required this.endedOn,
    required this.truckNo,
    required this.companyName,
    required this.phoneNum,
    required this.driverName,
    required this.imei
  });

  @override
  Widget build(BuildContext context) {
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

                          LoadEndPointTemplate(text: loadingPoint, endPointType: 'loading'),

                          Container(
                              padding: EdgeInsets.only(left: 2),
                              height: space_6,
                              width: space_12,
                              child: CustomPaint(
                                foregroundPainter: LinePainter(),
                              )
                          ),

                          LoadEndPointTemplate(text: unloadingPoint, endPointType: 'unloading'),

                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin : EdgeInsets.only(right: space_1) ,
                            child: Image(
                                height: 16,
                                width: 23,
                                color: black,
                                image: AssetImage('assets/icons/TruckIcon.png')
                            ),
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
                        LoadLabelValueTemplate(value: truckNo, label: 'Truck No.'),
                        LoadLabelValueTemplate(value: driverName, label: 'Driver Name'),
                        LoadLabelValueTemplate(value: startedOn, label: 'Started on')
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: contactPlaneBackground,
              padding: EdgeInsets.symmetric(vertical: space_2,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TrackButton(truckApproved: false),
                  CallButton(directCall: false,),
                ],
              ),
            ),
          ],
        ) ,
      ),
    );
  }
}
