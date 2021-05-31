import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/cityNameInputScreen.dart';
import 'package:get/get.dart';

class AddressInputWidget extends StatelessWidget {
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  final Widget clearIcon;

  AddressInputWidget({required this.hintText,required this.icon,required this.controller,required this.clearIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: 0.8),
        color: widgetBackGroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: space_3),
      child: TextFormField(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Get.off(CityNameInputScreen(hintText));
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          icon: icon,
          suffixIcon: clearIcon,
        ),
      ),
    );
  }
}
