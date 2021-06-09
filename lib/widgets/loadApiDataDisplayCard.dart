import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/contactWidget.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/buttons/priceButton.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoadApiDataDisplayCard extends StatelessWidget {
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

  LoadApiDataDisplayCard(
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
      this.date});

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          // ignore: unrelated_type_equality_checks
          if (tIdController.transporterApproved == true) {
            Get.to(() => LoadDetailsScreen(
                loadId: "$loadId",
                loadingPoint: "$loadingPoint",
                loadingPointCity: "$loadingPointCity",
                loadingPointState: "$loadingPointState",
                unloadingPoint: "$unloadingPoint",
                unloadingPointCity: "$unloadingPointCity",
                unloadingPointState: "$unloadingPointState",
                productType: "$productType",
                truckType: "$truckType",
                noOfTrucks: "$noOfTrucks",
                weight: "$weight",
                comment: "$comment",
                status: "$status",
                date: "$comment"));
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
                                    "$loadingPointCity",
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
                                    "$unloadingPointCity",
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
                                              Text("$truckType",
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
                                              Text("$weight",
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
                                              child: Text("$productType",
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
                  BidButton("$loadId"),
                ],
              ),
              SizedBox(
                height: space_2,
              ),
              ContactWidget()
            ],
          ),
        ),
      )
    ]);
  }
}
