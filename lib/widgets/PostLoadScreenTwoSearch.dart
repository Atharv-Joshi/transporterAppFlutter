import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

import 'buttons/addRectangularButtonProductType.dart';

class PostLoadScreenTwoSearch extends StatelessWidget {
  String hintText;
  PostLoadScreenTwoSearch({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    List<String> productTypeList = [
      "Agriculture And Food",
      "Electronic Goods/Battery",
      "Alcoholic Beverages",
      "Packaged/Consumer Boxs",
      "Auto Parts/machine",
      "Paints/Petroleum",
      "Chemical/Powder",
      "Scrap",
      "Construction Material",
      "Tyre",
      "Cylinders",
      "Others"
    ];
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.52,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: size_1,
                  crossAxisSpacing: space_6,
                  mainAxisSpacing: space_2,
                  crossAxisCount: 2,
                  children: productTypeList
                      .map((e) =>
                          addRectangularButtonProductType(value: e, text: e))
                      .toList(),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(space_4, space_0, space_4, space_0),
        child: Container(
          height: space_8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(space_6),
            border: Border.all(color: darkBlueColor, width: borderWidth_8),
            color: widgetBackGroundColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: space_2),
          child: Row(children: [
            Text(providerData.productType),
          ]),
        ),
      ),
    );
  }
}
