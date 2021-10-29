import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

class ProductTypeTextField extends StatelessWidget {
  String hint;
  String category;

  ProductTypeTextField({Key? key,required this.hint,required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(space_3, space_0, space_3, space_0),
      height: space_8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: borderWidth_8),
        color: widgetBackGroundColor,
      ),
      child: TextField(
        decoration: InputDecoration(hintText: hint,border : InputBorder.none),
        controller: controllerOthers,
        keyboardType: category != "Type" ? TextInputType.number : TextInputType.name,
      ),
    );
  }
}
