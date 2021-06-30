import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/buttons/viewBidsButton.dart';
import 'package:liveasy/widgets/loadValueColumnTemplate.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'priceContainer.dart';

// ignore: must_be_immutable
class MyLoadsCard extends StatelessWidget {

  String? loadingPointCity;
  String? unloadingPointCity;
  String? truckType;
  String? weight;
  String? productType;
  String? unitValue;
  int? rate;
  String? loadId;

  MyLoadsCard(
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
    return  Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(space_2),
            child: Column(
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

                            LoadEndPointTemplate(text: loadingPointCity.toString(), endPointType: 'loading'),

                            Container(
                              height: space_4+2,
                              padding: EdgeInsets.only(left: space_1 - 3),
                              child: CustomPaint(
                                foregroundPainter: LinePainter(height: space_4+2, width: 1),
                              ),
                            ),

                            LoadEndPointTemplate(text: unloadingPointCity.toString(), endPointType: 'unloading'),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            LoadLabelValueColumnTemplate(value: truckType.toString(), label: 'Truck Type'),
                                            LoadLabelValueColumnTemplate(value: weight.toString(), label: 'Weight')
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
                                        LoadLabelValueColumnTemplate(value: 'NA', label: 'Tyres'),
                                        LoadLabelValueColumnTemplate(value: productType.toString(), label: 'Product type'),
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
                    rate != null ? PriceContainer(rate: rate.toString(), unitValue: unitValue,) : SizedBox(),
                    ViewBidsButton(loadId : loadId , loadingPointCity: loadingPointCity, unloadingPointCity: unloadingPointCity,),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
