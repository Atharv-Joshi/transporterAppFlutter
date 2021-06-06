import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/widgets/bidButtonWidget.dart';
import 'package:liveasy/widgets/contactWidget.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/priceButtonWidget.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoadApiDataDisplayCard extends StatelessWidget {
  String? productType;
  String? loadingPoint;
  String? unloadingPoint;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  bool? isPending;
  String? comment;
  String? status;
  bool? isCommentsEmpty;

  LoadApiDataDisplayCard(
      {this.loadingPoint,
      this.unloadingPoint,
      this.productType,
      this.truckType,
      this.noOfTrucks,
      this.weight,
      this.isPending,
      this.comment,
      this.isCommentsEmpty,
      this.status});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          Get.to(() => LoadDetailsScreen(
                loadingPoint: "$loadingPoint",
                unloadingPoint: "$unloadingPoint",
                productType: "$productType",
                truckType: "$truckType",
                noOfTrucks: "$noOfTrucks",
                weight: "$weight",
                isPending: isPending,
                comment: "$comment",
                status: "$status",
                isCommentsEmpty: "$comment" == '' ? true : false,
              ));
        },
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: space_3, top: space_3),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                LoadingPointImageIcon(
                                  height: 12,
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "$loadingPoint",
                                    style: TextStyle(
                                        fontSize: size_9,
                                        color: loadingPointTextColor,
                                        fontWeight: mediumBoldWeight),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: space_2,
                            ),
                            Row(
                              children: [
                                UnloadingPointImageIcon(width: 12, height: 12),
                                SizedBox(
                                  width: space_2,
                                ),
                                Expanded(
                                  child: Text(
                                    "$unloadingPoint",
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
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Text("Truck Type",
                                            style: TextStyle(
                                                fontSize: size_6,
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
                                      height: 13,
                                    ),
                                    Column(
                                      children: [
                                        Text("Weight",
                                            style: TextStyle(
                                                fontSize: size_6 ,
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
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Text("Tyre",
                                            style: TextStyle(
                                                fontSize: size_6 ,
                                                fontWeight: regularWeight)),
                                        Text("NA",
                                            style: TextStyle(
                                              fontWeight: mediumBoldWeight,
                                              fontSize: size_7,
                                            ),)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    Column(
                                      children: [
                                        Text("Product Type",
                                            style: TextStyle(
                                                fontSize: size_6 ,
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
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(flex: 1, child: TruckImageWidget())
                ],
              ),
              SizedBox(
                height: space_3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceButtonWidget(),
                  BidButtonWidget(),
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
