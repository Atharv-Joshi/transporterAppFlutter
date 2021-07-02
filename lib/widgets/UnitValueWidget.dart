import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class UnitValueWidget extends StatelessWidget {
  const UnitValueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Padding(
      padding: EdgeInsets.only(left: space_4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (!providerData.perTruck) {
                providerData.PerTruckTrue();
              }
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: space_3,
                    height: space_3,
                    decoration: BoxDecoration(
                        color: providerData.perTruck ? blueTitleColor : white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 1, color: black)),
                  ),
                  SizedBox(width: space_1),
                  Text(
                    "Per Truck",
                    style: TextStyle(
                        fontSize: size_7,
                        fontWeight: regularWeight,
                        color: textLightColor),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: space_8),
          GestureDetector(
            onTap: () {
              if (!providerData.perTon) {
                providerData.PerTonTrue();
              }
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: space_3,
                    height: space_3,
                    decoration: BoxDecoration(
                        color: providerData.perTon ? blueTitleColor : white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 1, color: black)),
                  ),
                  SizedBox(width: space_1),
                  Text(
                    "Per Ton",
                    style: TextStyle(
                        fontSize: size_7,
                        fontWeight: regularWeight,
                        color: textLightColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
