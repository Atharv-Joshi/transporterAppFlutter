import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/callButton.dart';
import 'package:liveasy/widgets/loadLabelValueTemplate.dart';
import 'package:liveasy/widgets/trackButton.dart';
import 'linePainter.dart';

class DeliveredCard extends StatelessWidget {
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

                          LoadEndPointTemplate(text: 'Jabalpur', endPointType: 'loading'),

                          Container(
                              padding: EdgeInsets.only(left: 2),
                              height: space_6,
                              width: space_12,
                              child: CustomPaint(
                                foregroundPainter: LinePainter(),
                              )
                          ),

                          LoadEndPointTemplate(text: 'Jalandhar', endPointType: 'unloading'),

                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: space_4),
                    child: Column(
                      children: [
                        LoadLabelValueTemplate(value: 'AD 54 RF 4578', label: 'Truck No.'),
                        LoadLabelValueTemplate(value: 'Ravi Shah', label: 'Driver Name'),
                        LoadLabelValueTemplate(value: '20 Apr,2021', label: 'Started on'),
                        LoadLabelValueTemplate(value: '06 Mar,2021', label: 'Ended on'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: contactPlaneBackground,
              padding: EdgeInsets.symmetric(vertical: space_4 , horizontal: space_3),
              child: Row(
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
                        'D.K Transport',
                        style: TextStyle(
                          color: liveasyBlackColor,
                          fontWeight: mediumBoldWeight,
                        ),
                      )
                    ],
                  ) ,
            ),
          ],
        ) ,
      ),
    );
  }
}

