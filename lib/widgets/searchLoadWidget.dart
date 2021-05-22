import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/screens/findLoadScreen.dart';

class SearchLoadWidget extends StatelessWidget {
  final String hintText;


  SearchLoadWidget(
      this.hintText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Material(
        elevation: 5,
        child: TextField(
          onTap: (){
            Get.to(FindLoadScreen());
          },
          keyboardType: null,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            hintText: "$hintText   ",
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.search),
            ),
            hintStyle: TextStyle(
              fontSize: 16,
              color: grey,
            ),
          ),
        ),
      ),
    );
  }
}
