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
      height: xlSpace,
      child: Material(
        elevation: 5,
        child: TextField(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            Get.to(FindLoadScreen());
          },
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: "$hintText",
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.search),
            ),
            hintStyle: TextStyle(
              fontSize: xlSize,
              color: grey,
            ),
          ),
        ),
      ),
    );
  }
}
