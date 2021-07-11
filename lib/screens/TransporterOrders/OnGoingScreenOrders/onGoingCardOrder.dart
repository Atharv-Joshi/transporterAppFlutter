import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TransporterOrders/DeliveredScreenOrders/deliveredScreenOrders.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:get/get.dart';
import '../../../functions/textOverFlow.dart';
import '../../../widgets/buttons/callButton.dart';
import '../../shipperDetailsScreen.dart';
import '../OrderButtons/completedButtonOrders.dart';
import '../OrderButtons/trackButtonOrder.dart';
import '../../../widgets/linePainter.dart';
import '../../../widgets/loadLabelValueRowTemplate.dart';

class OngoingCardOrders extends StatelessWidget {
  //variables
  final String loadingPoint;
  final String unloadingPoint;
  final String startedOn;
  final String endedOn;
  final String vehicleNo;
  final String companyName;
  final String driverPhoneNum;
  final String driverName;
  final String imei;
  final String transporterPhoneNumber;
  final String bookingId;
  final int rate;
  final String posterLocation;
  final bool companyApproved;
  final String posterName;
  final String truckType;
  final String noOfTrucks;
  final String productType;

  // final String transporterName;

  OngoingCardOrders({
    required this.loadingPoint,
    required this.unloadingPoint,
    required this.startedOn,
    required this.endedOn,
    required this.vehicleNo,
    required this.companyName,
    required this.driverPhoneNum,
    required this.driverName,
    required this.imei,
    required this.bookingId,
    required this.transporterPhoneNumber,
    required this.rate,
    required this.companyApproved,
    required this.posterLocation,
    required this.posterName,
    required this.truckType,
    required this.noOfTrucks,
    required this.productType,

    // required this.transporterName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: space_3),
      child: Container(
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
                                text: unloadingPoint,
                                endPointType: 'unloading'),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.to(ShipperDetails(
                                truckType: truckType,
                                noOfTrucks: noOfTrucks,
                                productType: productType,
                                loadingPoint: loadingPoint,
                                unloadingPoint: unloadingPoint,
                                rate: rate,
                                vehicleNo: vehicleNo,
                                shipperPosterCompanyApproved: companyApproved,
                                shipperPosterCompanyName: companyName,
                                shipperPosterLocation: posterLocation,
                                shipperPosterName: posterName,
                              ));
                            },
                            child: Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: space_4),
                      child: Column(
                        children: [
                          LoadLabelValueRowTemplate(
                              value: vehicleNo, label: 'Truck no.'),
                          LoadLabelValueRowTemplate(
                              value: driverName, label: 'Driver Name'),
                          LoadLabelValueRowTemplate(
                              value: startedOn, label: 'Booking date'),
                          LoadLabelValueRowTemplate(
                              value: "Rs.$rate/tonne", label: 'Price'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: space_5,
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
                        CallButton(
                          directCall: false,
                          transporterPhoneNum: transporterPhoneNumber,
                          driverPhoneNum: driverPhoneNum,
                          driverName: driverName,
                          transporterName: companyName,
                        ),
                      ],
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
                    CompletedButtonOrders(bookingId: bookingId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
