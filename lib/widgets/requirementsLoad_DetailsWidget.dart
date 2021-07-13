import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';

// ignore: must_be_immutable
class RequirementsLoadDetails extends StatelessWidget {
  Map loadDetails;

  RequirementsLoadDetails({required this.loadDetails});


  @override
  Widget build(BuildContext context) {
    loadDetails['unitValue'] = loadDetails['unitValue'] == 'PER_TON' ? 'tonne' : 'truck' ;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Requirements",
          style: TextStyle(fontWeight: mediumBoldWeight, fontSize: size_7),
        ),
        Container(
          padding: EdgeInsets.only(left: space_3, right: space_3, top: space_2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewRowTemplate(label: 'Truck Type', value: loadDetails['truckType']),
              NewRowTemplate(label: 'No of trucks', value: loadDetails["noOfTrucks"]),
              NewRowTemplate(label: 'Weight', value: "${loadDetails['weight']} tonnes"),
              NewRowTemplate(label: 'Product Type', value: loadDetails['productType']),
              NewRowTemplate(label: 'Bid Price', value: "${loadDetails['rate']}/${loadDetails['unitValue']}"),
            ],
          ),
        ),
      ],
    );
  }
}
