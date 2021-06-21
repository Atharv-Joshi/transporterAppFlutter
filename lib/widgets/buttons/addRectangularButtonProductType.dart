import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class addRectangularButtonProductType extends StatelessWidget {
  final String text;
  final String value;
  bool selected = false;
  addRectangularButtonProductType({required this.value, required this.text});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      child: OutlinedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(2),
            backgroundColor: providerData.productType == value
                ? MaterialStateProperty.all(darkBlueColor)
                : MaterialStateProperty.all(whiteBackgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ))),
        child: Text(
          '$text',
          style: TextStyle(
              fontWeight: normalWeight,
              fontSize: text == 'High-Cube Container' ||
                      text == 'Standard Container' ||
                      text == "Agriculture And Food" ||
                      text == "Electronic Goods/Battery" ||
                      text == "Alcoholic Beverages" ||
                      text == "Packaged/Consumer Boxs" ||
                      text == "Auto Parts/machine" ||
                      text == "Paints/Petroleum" ||
                      text == "Chemical/Powder" ||
                      text == "Scrap" ||
                      text == "Construction Material" ||
                      text == "Tyre" ||
                      text == "Cylinders" ||
                      text == "Others"
                  ? size_6
                  : size_7,
              color: providerData.productType == value ? white : black),
        ),
        onPressed: () {
          providerData.updateProductType(value);
          providerData.updateResetActive(true);
        },
      ),
    );
  }
}
