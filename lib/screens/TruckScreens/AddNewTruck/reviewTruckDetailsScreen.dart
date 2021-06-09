import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/applyButton.dart';
import 'package:liveasy/widgets/truckReviewDetailsRow.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class ReviewTruckDetails extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(space_5),
          child: Column(
            children: [
              AddTrucksHeader(resetFunction: (){}),
              AddTruckSubtitleText(text: 'Review Details For ${providerData.truckNumberValue}'),
              SizedBox(height: 100,),
              Column(
                children: [
                  TruckReviewDetailsRow(value: providerData.truckTypeValue, label: 'Truck Type'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Truck Type'),
                  //     Text('${providerData.truckTypeValue}'),
                  //   ],
                  // ),
                  // Divider(),
                  TruckReviewDetailsRow(value: providerData.totalTyresValue, label: 'Total Tyres'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Total Tyres'),
                  //     Text('${providerData.totalTyresValue}'),
                  //   ],
                  // ),
                  // Divider(),
                  TruckReviewDetailsRow(value: providerData.passingWeightValue, label: 'Passing Weight'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Passing Weight'),
                  //     Text('${providerData.passingWeightValue}'),
                  //   ],
                  // ),
                  // Divider(),
                  TruckReviewDetailsRow(value: providerData.truckLengthValue, label: 'Truck Length'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Truck Length'),
                  //     Text('${providerData.truckLengthValue}'),
                  //   ],
                  // ),
                  // Divider(),
                  TruckReviewDetailsRow(value: providerData.driverDetailsValue, label: 'Driver Details'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Driver Details'),
                  //     Text('${providerData.driverDetailsValue}'),
                  //   ],
                  // ),
                  // Divider(),
                  ApplyButton(onPressedFunction: (){}, text: 'Edit'),
                  ApplyButton(onPressedFunction: (){}, text: 'Submit')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
