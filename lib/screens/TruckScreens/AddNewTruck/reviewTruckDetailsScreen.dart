import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/buttons/mediumSizedButton.dart';
import 'package:liveasy/widgets/truckReviewDetailsRow.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/controller/truckIdController.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';

class ReviewTruckDetails extends StatelessWidget {

  TruckApiCalls truckApiCalls = TruckApiCalls();

  TruckIdController truckIdController = TruckIdController();

  String truckId;
  String truckTypeText = '';

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  ReviewTruckDetails(this.truckId);
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    if(providerData.truckTypeValue == ''){
      truckTypeText = '---';
    }
    else{
      truckTypeText =  truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(providerData.truckTypeValue)];
    }
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(space_5),
          child: Column(
            children: [
              AddTrucksHeader(
                reset: false,
                  resetFunction: (){
                providerData.resetTruckFilters();
                Get.back();
              }),
              Container(
                margin: EdgeInsets.only(top: space_2),
                child: Row(
                  children: [
                    Text(
                      'Review Details For ',
                      style: TextStyle(
                        fontSize: size_9,
                        fontWeight: mediumBoldWeight
                      ),
                    ),
                    Text(
                      '${providerData.truckNumberValue}',
                      style: TextStyle(
                          fontSize: size_9,
                          color: Color(0xff152968),
                          fontWeight: mediumBoldWeight
                      ),
                    ),
                  ],
                ),
              ),
              // AddTruckSubtitleText(text: 'Review Details For ${providerData.truckNumberValue}'),
              SizedBox(height: 20,),

              Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(space_2),
                        child: Column(
                          children: [
                            TruckReviewDetailsRow(value: truckTypeText , label: 'Truck Type'),
                            TruckReviewDetailsRow(value: providerData.totalTyresValue, label: 'Total Tyres'),
                            TruckReviewDetailsRow(value: providerData.passingWeightValue, label: 'Passing Weight'),
                            TruckReviewDetailsRow(value: providerData.truckLengthValue, label: 'Truck Length'),
                            TruckReviewDetailsRow(value: providerData.driverDetailsValue, label: 'Driver Details'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          space_2,
                          MediaQuery.of(context).size.height * 0.38,
                          space_2,
                          0,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MediumSizedButton(
                              onPressedFunction: (){
                                Get.back();
                              },
                              text: 'Edit'),
                          MediumSizedButton(
                              onPressedFunction: (){

                                truckApiCalls.putTruckData(
                                    truckType: providerData.truckTypeValue ,
                                    totalTyres: providerData.totalTyresValue ,
                                    truckLength: providerData.truckLengthValue,
                                    passingWeight: providerData.passingWeightValue ,
                                    driverDetails: providerData.driverDetailsValue ,
                                    truckID : truckId,
                                          );
                                providerData.resetTruckFilters();
                              },
                              text: 'Submit')
                        ],
                      ),
                    )

                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}
