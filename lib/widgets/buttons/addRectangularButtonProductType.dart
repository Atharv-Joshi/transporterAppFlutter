import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:liveasy/widgets/alertDialog/ProductTypeEnterAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class addRectangularButtonProductType extends StatelessWidget {
  final String text;
  final String value;
  bool selected = false;
  addRectangularButtonProductType({required this.value, required this.text});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Padding(
      padding: EdgeInsets.only(left: space_1, right: space_1),
      child: Container(
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
            if (value == "Others") {
              Get.back();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProductTypeEnterAlertDialog(
                      heading: 'Enter The Product Type');
                },
              );
            } else {
              Get.back();
              providerData.updateProductType(value);
              providerData.updateResetActive(true);
            }
          },
        ),
      ),
    );
  }
}
