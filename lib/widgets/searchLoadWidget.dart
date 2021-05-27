import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/findLoadScreen.dart';

class SearchLoadWidget extends StatelessWidget {
  final String hintText;
  SearchLoadWidget(
      this.hintText);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 0.8, color: borderBlueColor,),
      ),
      child: TextField(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
          Get.to(FindLoadScreen());
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: "$hintText",
          icon: Padding(
            padding: EdgeInsets.only(left: space_2),
            child: Icon(Icons.search, color: grey,),
          ),
          hintStyle: TextStyle(
            fontSize: size_8,
            color: grey,
          ),
        ),
      ),
    );
  }
}
