import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/buttons/viewBidsButton.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';

import 'priceContainer.dart';
import 'loadingPointImageIcon.dart';

// ignore: must_be_immutable
class LoadCardHeader extends StatelessWidget {
  String? loadingPointCity;
  String? unloadingPointCity;
  String? truckType;
  String? weight;
  String? productType;
  String? unitValue;
  int? rate;
  String? loadId;

  LoadCardHeader(
      {
        this.loadingPointCity,
        this.unloadingPointCity,
        this.truckType,
        this.weight,
        this.productType,
        this.unitValue,
        this.loadId,
        this.rate,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: space_3, top: space_3 - 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LoadingPointImageIcon(
                            height: space_2-1,
                            width: space_2,
                          ),
                          SizedBox(
                            width: space_2 - 1,
                          ),
                          Expanded(
                            child: Text(
                              "$loadingPointCity",
                              style: TextStyle(
                                  fontSize: size_9,
                                  color: veryDarkGrey,
                                  fontWeight: mediumBoldWeight),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: space_4+2,
                        padding: EdgeInsets.only(left: space_1 - 3),
                        child: CustomPaint(
                          foregroundPainter: LinePainter(height: space_4+2, width: 1),
                        ),
                      ),
                      Row(
                        children: [
                          UnloadingPointImageIcon(width: space_2, height: space_2-1),
                          SizedBox(
                            width: space_2 - 1,
                          ),
                          Expanded(
                            child: Text(
                              "$unloadingPointCity",
                              style: TextStyle(
                                  fontSize: size_9,
                                  color: veryDarkGrey,
                                  fontWeight: mediumBoldWeight),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: space_2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      //TODO: scope of refactoring here
                                      Column(
                                        children: [
                                          Text(
                                            "Truck Type",
                                            style: TextStyle(
                                                fontSize: size_6 - 1,
                                                fontWeight: regularWeight,
                                                color: liveasyBlackColor),
                                          ),
                                          Text(
                                            "$truckType",
                                            style: TextStyle(
                                                fontWeight: mediumBoldWeight,
                                                fontSize: size_7,
                                                color: veryDarkGrey),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: space_2 + 3,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Weight",
                                            style: TextStyle(
                                                fontSize: size_6 - 1,
                                                fontWeight: regularWeight,
                                                color: liveasyBlackColor),
                                          ),
                                          Text(
                                            "$weight",
                                            style: TextStyle(
                                                fontWeight: mediumBoldWeight,
                                                fontSize: size_7,
                                                color: veryDarkGrey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Tyre",
                                        style: TextStyle(
                                            fontSize: size_6 - 1,
                                            fontWeight: regularWeight,
                                            color: liveasyBlackColor),
                                      ),
                                      Text(
                                        "NA",
                                        style: TextStyle(
                                            fontWeight: mediumBoldWeight,
                                            fontSize: size_7,
                                            color: veryDarkGrey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: space_2+3,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Product type",
                                        style: TextStyle(
                                            fontSize: size_6 - 1,
                                            fontWeight: regularWeight,
                                            color: liveasyBlackColor),
                                      ),
                                      Container(
                                        child: Text(
                                          "$productType",
                                          style: TextStyle(
                                              fontWeight: mediumBoldWeight,
                                              fontSize: size_7,
                                              color: veryDarkGrey),
                                        ),
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
                ),
            ),
            Container(
                padding: EdgeInsets.only(top: space_3 , right: space_1),
                child: TruckImageWidget())
          ],
        ),
        SizedBox(
          height: space_2 + 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceContainer(rate: rate.toString(), unitValue: unitValue,),
            BidButton(loadId.toString()),
          ],
        ),
      ],
    );
  }
}
