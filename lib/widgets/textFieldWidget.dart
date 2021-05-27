import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final dynamic onChanged;
  final String hintText;
  final Widget icon;

  TextFieldWidget(
      {required this.controller,
      required this.onChanged,
      required this.hintText,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderBlueColor, width: 0.8),
        borderRadius: BorderRadius.circular(30),
        color: widgetBackGroundColor,
      ),
      child: TextFormField(
        autofocus: true,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: icon,
          hintText: hintText,
        ),
      ),
    );
  }
}
