import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/buttons/viewBidsButton.dart';
import 'priceContainer.dart';

// ignore: must_be_immutable
class MyLoadsCard extends StatelessWidget {

  LoadDetailsScreenModel loadDetailsScreenModel;

  MyLoadsCard(
      {
        required this.loadDetailsScreenModel
      }
      );

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  @override
  Widget build(BuildContext context) {


    if(truckFilterVariables.truckTypeValueList.contains(loadDetailsScreenModel.truckType)){
      loadDetailsScreenModel.truckType = truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf( loadDetailsScreenModel.truckType)];
    }

    if(loadDetailsScreenModel.unitValue == 'PER_TON'){
      loadDetailsScreenModel.unitValue = 'tonne';
    }
    else if(loadDetailsScreenModel.unitValue == 'PER_TRUCK'){
      loadDetailsScreenModel.unitValue = 'truck';
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
                    'Posted Date : ${loadDetailsScreenModel.loadDate}',
                style: TextStyle(
                  fontSize: size_6,
                  color: veryDarkGrey
                ),
                ),


                SizedBox(
                  height: space_1,
                ),

                LoadEndPointTemplate(text: loadDetailsScreenModel.loadingPointCity, endPointType: 'loading'),

                Container(
                  height: space_4+2,
                  padding: EdgeInsets.only(left: space_1 - 3),
                  child: CustomPaint(
                    foregroundPainter: LinePainter(height: space_4+2, width: 1),
                  ),
                ),

                LoadEndPointTemplate(text: loadDetailsScreenModel.unloadingPointCity, endPointType: 'unloading'),

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
                        '${loadDetailsScreenModel.truckType} | ${loadDetailsScreenModel.noOfTrucks} trucks',
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
                        '${loadDetailsScreenModel.productType} | ${loadDetailsScreenModel.weight} tons',
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
                      loadDetailsScreenModel.rate != 'NA' ? PriceContainer(rate: loadDetailsScreenModel.rate, unitValue: loadDetailsScreenModel.unitValue,) : SizedBox(),
                      ViewBidsButton(loadId : loadDetailsScreenModel.loadId , loadingPointCity: loadDetailsScreenModel.loadingPointCity, unloadingPointCity: loadDetailsScreenModel.unloadingPointCity,),
                    ],
                  ),
              ],

            ),
          ),
        ),
    );
  }
}
