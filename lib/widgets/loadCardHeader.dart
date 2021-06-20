import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';

import 'buttons/priceButton.dart';
import 'loadingPointImageIcon.dart';

// ignore: must_be_immutable
class CardUpperWidget extends StatelessWidget {
  String? loadingPointCity;
  String? unloadingPointCity;
  String? truckType;
  String? weight;
  String? productType;
  String? loadId;

  CardUpperWidget(
      {this.loadingPointCity,
      this.unloadingPointCity,
      this.truckType,
      this.weight,
      this.productType,
      this.loadId});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                              loadingPointCity.toString(),
                              style: TextStyle(
                                  fontSize: size_9,
                                  color: liveasyBlackColor,
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
                              unloadingPointCity.toString(),
                              style: TextStyle(
                                  fontSize: size_9,
                                  color: liveasyBlackColor,
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
                                                fontWeight: regularWeight)),
                                        Text(truckType.toString(),
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
                                        Text("Weight",
                                            style: TextStyle(
                                                fontSize: size_6 - 1,
                                                fontWeight: regularWeight)),
                                        Text(weight.toString(),
                                            style: TextStyle(
                                              fontWeight: mediumBoldWeight,
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
                                        child: Text(productType.toString(),
                                            style: TextStyle(
                                              fontWeight: mediumBoldWeight,
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
            BidButton(loadId.toString()),
          ],
        ),
      ],
    );
  }
}
