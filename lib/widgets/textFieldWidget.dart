import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final dynamic onChanged;
  final String hintText;
  TextFieldWidget({required this.controller, required this.onChanged, required this.hintText});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: TextFormField(
        controller: controller,
        onChanged:  onChanged,
        decoration: InputDecoration(
          icon: Padding(
            padding: EdgeInsets.only(left: verySmallSpace),
            child: Icon(Icons.search),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
