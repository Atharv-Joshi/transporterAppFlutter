import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/buttons/applyButton.dart';
import 'package:liveasy/widgets/truckReviewDetailsRow.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class ReviewTruckDetails extends StatelessWidget {

  TruckApiCalls truckApiCalls = TruckApiCalls();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(space_5),
          child: Column(
            children: [
              AddTrucksHeader(resetFunction: (){
                providerData.resetTruckFilters();
                Get.back();
              }),
              AddTruckSubtitleText(text: 'Review Details For ${providerData.truckNumberValue}'),
              SizedBox(height: 100,),
              Column(
                children: [
                  TruckReviewDetailsRow(value: providerData.truckTypeValue, label: 'Truck Type'),
                  TruckReviewDetailsRow(value: providerData.totalTyresValue, label: 'Total Tyres'),
                  TruckReviewDetailsRow(value: providerData.passingWeightValue, label: 'Passing Weight'),
                  TruckReviewDetailsRow(value: providerData.truckLengthValue, label: 'Truck Length'),
                  TruckReviewDetailsRow(value: providerData.driverDetailsValue, label: 'Driver Details'),

                  Container(
                    margin: EdgeInsets.fromLTRB(
                        space_2,
                        MediaQuery.of(context).size.height * 0.35,
                        space_2,
                        0
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ApplyButton(
                            onPressedFunction: (){
                              Get.back();
                            },
                            text: 'Edit'),
                        ApplyButton(
                            onPressedFunction: (){
                              truckApiCalls.putTruckData();
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
