import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/loadValueColumnTemplate.dart';
import 'package:liveasy/widgets/truckImageWidget.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'LoadEndPointTemplate.dart';
import 'priceContainer.dart';
import 'loadingPointImageIcon.dart';

// ignore: must_be_immutable
class LoadCardHeader extends StatelessWidget {
  LoadDetailsScreenModel loadDetails;

  LoadCardHeader({
    required this.loadDetails,
  });

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();


  @override
  Widget build(BuildContext context) {

    if(loadDetails.truckType != 'Na'){
      loadDetails.truckType = truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(loadDetails.truckType)];
    }
    print('load details rate : ${loadDetails.rate}');

    return Container(
      padding: EdgeInsets.all(space_2),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                //TODO : changes load date
                'Posted Date : loadDate',
                style: TextStyle(
                    fontSize: size_6,
                    color: veryDarkGrey
                ),
              ),
              Icon(
                  Icons.arrow_forward_ios_sharp
              )

            ],
          ),
          SizedBox(
            height: space_1,
          ),

          LoadEndPointTemplate(text: loadDetails.loadingPointCity.toString(), endPointType: 'loading'),

          Container(
            height: space_4+2,
            padding: EdgeInsets.only(left: space_1 - 3),
            child: CustomPaint(
              foregroundPainter: LinePainter(height: space_4+2, width: 1),
            ),
          ),

          LoadEndPointTemplate(text: loadDetails.unloadingPointCity.toString(), endPointType: 'unloading'),

          SizedBox(
            height: space_1,
          ),

          Row(
            children: [
              Image(
                image: AssetImage('assets/images/TruckListEmptyImage.png'),
                height: 24 ,
                width: 24,),
              Text(
                '${loadDetails.truckType} | ${loadDetails.noOfTrucks} trucks',
                style: TextStyle(
                    fontSize: size_6
                ),),
            ],
          ),

          SizedBox(
            height: space_1,
          ),

          Row(
            children: [
              Image(
                image: AssetImage('assets/images/loadBox.png'),
                height: 24 ,
                width: 24,),
              Text(
                '${loadDetails.productType} | ${loadDetails.weight} tons',
                style: TextStyle(
                    fontSize: size_6
                ),),
            ],
          ),

          SizedBox(
            height: space_2,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loadDetails.rate != 'null'  ? PriceContainer(rate: loadDetails.rate.toString(), unitValue: loadDetails.unitValue,) : SizedBox(),
              BidButton(loadDetails: loadDetails,),
            ],
          ),
        ],

      ),
    );
  }
}
