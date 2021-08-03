import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/shareRowTemplate.dart';

// ignore: must_be_immutable
class ShareRequirementsLoadDetails extends StatelessWidget {
  Map loadDetails;

  ShareRequirementsLoadDetails({required this.loadDetails});


  @override
  Widget build(BuildContext context) {
    loadDetails['unitValue'] = loadDetails['unitValue'] == 'PER_TON' ? 'tonne' : 'truck' ;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Requirements",
                style: TextStyle(
                    fontSize: size_7,
                    fontWeight: mediumBoldWeight,
                    color: white
                ),
              ),
              SizedBox(
                height: space_2,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: space_3, right: space_3, top: space_2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shareNewRowTemplate(label: 'Truck Type', value: loadDetails['truckType']),
              shareNewRowTemplate(label: 'No of trucks', value: loadDetails["noOfTrucks"]),
              shareNewRowTemplate(label: 'Weight', value: "${loadDetails['weight']} tonnes"),
              shareNewRowTemplate(label: 'Product Type', value: loadDetails['productType']),
              shareNewRowTemplate(label: 'Bid Price', value: "${loadDetails['rate']}/${loadDetails['unitValue']}"),
            ],
          ),
        ),
      ],
    );
  }
}
