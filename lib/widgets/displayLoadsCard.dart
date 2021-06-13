import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/contactWidget.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/buttons/priceButton.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';

import 'alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'loadingPointImageIcon.dart';

// ignore: must_be_immutable
class DisplayLoadsCard extends StatefulWidget {
  String? loadId;
  String? loadingPoint;
  String? loadingPointCity;
  String? loadingPointState;
  String? id;
  String? unloadingPoint;
  String? unloadingPointCity;
  String? unloadingPointState;
  String? productType;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  String? comment;
  String? status;
  String? date;

  String? loadPosterId;
  String? loadPosterPhoneNo;
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  String? loadPosterKyc;
  String? loadPosterCompanyApproved;
  String? loadPosterApproved;

  DisplayLoadsCard(
      {this.loadId,
      this.loadingPoint,
      this.loadingPointCity,
      this.loadingPointState,
      this.id,
      this.unloadingPoint,
      this.unloadingPointCity,
      this.unloadingPointState,
      this.productType,
      this.truckType,
      this.noOfTrucks,
      this.weight,
      this.comment,
      this.status,
      this.date,
      this.loadPosterId,
      this.loadPosterPhoneNo,
      this.loadPosterLocation,
      this.loadPosterName,
      this.loadPosterCompanyName,
      this.loadPosterKyc,
      this.loadPosterCompanyApproved,
      this.loadPosterApproved});

  @override
  _DisplayLoadsCardState createState() => _DisplayLoadsCardState();
}

class _DisplayLoadsCardState extends State<DisplayLoadsCard> {
  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          // ignore: unrelated_type_equality_checks
          if (tIdController.transporterApproved ==
              false) //TODO: to be changed to true
          {
            Get.to(() => LoadDetailsScreen(
                loadId: widget.loadId,
                loadingPoint: widget.loadingPoint,
                loadingPointCity: widget.loadingPointCity,
                loadingPointState: widget.loadingPointState,
                id: widget.id,
                unloadingPoint: widget.unloadingPoint,
                unloadingPointCity: widget.unloadingPointCity,
                unloadingPointState: widget.unloadingPointCity,
                productType: widget.productType,
                truckType: widget.truckType,
                noOfTrucks: widget.noOfTrucks,
                weight: widget.weight,
                comment: widget.comment,
                status: widget.status,
                date: widget.date,
                loadPosterId: widget.loadPosterId,
                loadPosterPhoneNo: widget.loadPosterPhoneNo,
                loadPosterLocation: widget.loadPosterLocation,
                loadPosterName: widget.loadPosterName,
                loadPosterCompanyName: widget.loadPosterCompanyName,
                loadPosterKyc: widget.loadPosterKyc,
                loadPosterCompanyApproved: widget.loadPosterCompanyApproved,
                loadPosterApproved: widget.loadPosterApproved));
          } else {
            VerifyAccountNotifyAlertDialog(context);
          }
        },
        child: Card(
          elevation: elevation_2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 15, top: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                LoadingPointImageIcon(
                                  height: space_2 + 2,
                                  width: space_2 + 2,
                                ),
                                SizedBox(
                                  width: space_2 - 2,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.loadingPointCity.toString(),
                                    style: TextStyle(
                                        fontSize: size_9,
                                        color: loadingPointTextColor,
                                        fontWeight: mediumBoldWeight),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: space_2 - 2,
                            ),
                            Row(
                              children: [
                                UnloadingPointImageIcon(
                                    width: space_2 + 2, height: space_2 + 2),
                                SizedBox(
                                  width: space_2 - 2,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.unloadingPointCity.toString(),
                                    style: TextStyle(
                                        fontSize: size_9,
                                        color: unloadingPointTextColor,
                                        fontWeight: mediumBoldWeight),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: space_1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Column(
                                            children: [
                                              Text("Truck Type",
                                                  style: TextStyle(
                                                      fontSize: size_6 - 1,
                                                      fontWeight:
                                                          regularWeight)),
                                              Text(widget.truckType.toString(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    fontSize: size_7,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: space_2 + 3,
                                          ),
                                          Column(
                                            children: [
                                              Text("Weight",
                                                  style: TextStyle(
                                                      fontSize: size_6 - 1,
                                                      fontWeight:
                                                          regularWeight)),
                                              Text(widget.weight.toString(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    fontSize: size_7,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Text("Tyre",
                                                style: TextStyle(
                                                    fontSize: size_6 - 1,
                                                    fontWeight: regularWeight)),
                                            Text("NA",
                                                style: TextStyle(
                                                  fontWeight: mediumBoldWeight,
                                                  fontSize: size_7,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: space_2 + 3,
                                        ),
                                        Column(
                                          children: [
                                            Text("Product Type",
                                                style: TextStyle(
                                                    fontSize: size_6 - 1,
                                                    fontWeight: regularWeight)),
                                            Container(
                                              child: Text(
                                                  widget.productType.toString(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    fontSize: size_7,
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(flex: 1, child: TruckImageWidget())
                ],
              ),
              SizedBox(
                height: space_2 + 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceButtonWidget(),
                  BidButton(widget.loadId.toString()),
                ],
              ),
              SizedBox(
                height: space_2,
              ),
              ContactWidget(
                  loadPosterCompanyname: widget.loadPosterCompanyName,
                  loadPosterPhoneNo: widget.loadPosterPhoneNo)
            ],
          ),
        ),
      )
    ]);
  }
}
