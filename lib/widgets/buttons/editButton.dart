import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditButton extends StatelessWidget {
  var onTap;

  EditButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            'edit'.tr,
            style: TextStyle(
                color: white, fontWeight: normalWeight, fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}
