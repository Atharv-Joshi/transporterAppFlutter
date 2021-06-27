import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/loadValueColumnTemplate.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'priceContainer.dart';
import 'loadingPointImageIcon.dart';

// ignore: must_be_immutable
class LoadCardHeader extends StatelessWidget {
  LoadDetailsScreenModel loadDetails;

  LoadCardHeader({
    required this.loadDetails,
  });

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
                          height: space_2 - 1,
                          width: space_2,
                        ),
                        SizedBox(
                          width: space_2 - 1,
                        ),
                        Expanded(
                          child: Text(
                            "${loadDetails.loadingPointCity}",
                            style: TextStyle(
                                fontSize: size_9,
                                color: veryDarkGrey,
                                fontWeight: mediumBoldWeight),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: space_4 + 2,
                      padding: EdgeInsets.only(left: space_1 - 3),
                      child: CustomPaint(
                        foregroundPainter:
                            LinePainter(height: space_4 + 2, width: 1),
                      ),
                    ),
                    Row(
                      children: [
                        UnloadingPointImageIcon(
                            width: space_2, height: space_2 - 1),
                        SizedBox(
                          width: space_2 - 1,
                        ),
                        Expanded(
                          child: Text(
                            "${loadDetails.unloadingPointCity}",
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
                                    LoadLabelValueColumnTemplate(
                                      label: "Weight",
                                      value: loadDetails.weight.toString(),
                                    ),
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
                                LoadLabelValueColumnTemplate(
                                  label: "No. Of Trucks",
                                  value: loadDetails.noOfTrucks.toString(),
                                ),
                                SizedBox(
                                  height: space_2 + 3,
                                ),
                                LoadLabelValueColumnTemplate(
                                  label: "Product type",
                                  value: loadDetails.productType.toString(),
                                ),
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
                padding: EdgeInsets.only(top: space_3, right: space_1),
                child: TruckImageWidget())
          ],
        ),
        SizedBox(
          height: space_2 + 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceContainer(
              rate: loadDetails.rate.toString(),
              unitValue: loadDetails.unitValue.toString(),
            ),
            BidButton(loadDetails: loadDetails,),
          ],
        ),
      ],
    );
  }
}
