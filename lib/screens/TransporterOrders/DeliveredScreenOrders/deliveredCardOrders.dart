import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/textOverFlow.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import '../../../widgets/linePainter.dart';
import '../../../widgets/loadLabelValueRowTemplate.dart';
import '../../shipperDetailsScreen.dart';
import 'package:get/get.dart';

class DeliveredCardOrders extends StatelessWidget {
  final String loadingPoint;
  final String unloadingPoint;
  final String startedOn;
  final String endedOn;
  final String truckNo;
  final String companyName;
  // final String phoneNum;
  final String driverName;
  final String transporterPhoneNumber;
  final String driverPhoneNum;
  final int rate;
  final String posterLocation;
  final bool companyApproved;
  final String posterName;
  final String truckType;
  final String noOfTrucks;
  final String productType;
  final String vehicleNo;
  final String unitValue;

  // final String imei;

  DeliveredCardOrders(
      {required this.transporterPhoneNumber,
      required this.driverPhoneNum,
      required this.loadingPoint,
      required this.unloadingPoint,
      required this.startedOn,
      required this.endedOn,
      required this.truckNo,
      required this.companyName,
      // required this.phoneNum,
      required this.driverName,
      required this.vehicleNo,

      // required this.imei
      required this.rate,
      required this.companyApproved,
      required this.posterLocation,
      required this.posterName,
      required this.truckType,
      required this.noOfTrucks,
      required this.productType,
      required this.unitValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(space_2),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoadLabelValueRowTemplate(
                          value: startedOn, label: 'Booking date'),
                    ],
                  ),
                  SizedBox(
                    height: space_2,
                  ),
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
                  Container(
                    margin: EdgeInsets.only(top: space_2),
                    child: Column(
                      children: [
                        LoadLabelValueRowTemplate(
                            value: endedOn, label: 'Completed date'),
                        LoadLabelValueRowTemplate(
                            value: "Rs.$rate/$unitValue", label: 'Price'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: space_2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: space_1),
                            child: Image(
                                height: 16,
                                width: 23,
                                color: black,
                                image: AssetImage(
                                    'assets/icons/buildingIcon.png')),
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
                      SizedBox(
                        height: space_2,
                      ),
                    ],
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
