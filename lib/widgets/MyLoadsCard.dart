import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
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
  String? loadDate;
  String? noOfTrucks;

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
        this.loadDate,
        this.noOfTrucks
      }
      );

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  @override
  Widget build(BuildContext context) {

    if(truckType != 'Na'){
      truckType = truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(truckType)];
    }

    return  Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(space_2),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text(
                    'Posted Date : $loadDate',
                style: TextStyle(
                  fontSize: size_6,
                  color: veryDarkGrey
                ),),

                SizedBox(
                  height: space_1,
                ),

                LoadEndPointTemplate(text: loadingPointCity.toString(), endPointType: 'loading'),

                Container(
                  height: space_4+2,
                  padding: EdgeInsets.only(left: space_1 - 3),
                  child: CustomPaint(
                    foregroundPainter: LinePainter(height: space_4+2, width: 1),
                  ),
                ),

                LoadEndPointTemplate(text: unloadingPointCity.toString(), endPointType: 'unloading'),

                SizedBox(
                  height: space_1,
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:8),
                      child: Image(
                          image: AssetImage('assets/images/TruckListEmptyImage.png'),
                      height: 24 ,
                      width: 24,),
                    ),
                    Text(
                        '$truckType | $noOfTrucks trucks',
                      style: TextStyle(
                          fontSize: size_6,
                          fontWeight: mediumBoldWeight
                      ),),
                  ],
                ),

                SizedBox(
                  height: space_1,
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right:8),
                      child: Image(
                        image: AssetImage('assets/images/EmptyLoad.png'),
                        height: 24 ,
                        width: 24,),
                    ),
                    Text(
                        '$productType | $weight tons',
                    style: TextStyle(
                      fontSize: size_6,
                        fontWeight: mediumBoldWeight
                    ),),
                  ],
                ),

                SizedBox(
                  height: space_2,
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
