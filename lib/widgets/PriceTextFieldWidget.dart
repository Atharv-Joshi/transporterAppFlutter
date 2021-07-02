import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

import 'package:provider/provider.dart';

class PriceTextFieldWidget extends StatelessWidget {
  const PriceTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(space_4, space_0, space_4, space_0),
      child: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_0, space_4, space_0),
        height: space_8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space_6),
          border: Border.all(color: darkBlueColor, width: borderWidth_8),
          color: widgetBackGroundColor,
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Enter Price",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          controller: controller,
          onChanged: (value) {
            providerData.updatePrice(int.parse(value));
          },
        ),
      ),
    );
  }
}
