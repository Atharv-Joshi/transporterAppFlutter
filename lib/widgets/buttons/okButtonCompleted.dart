import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:get/get.dart';
import 'package:liveasy/providerClass/providerData.dart';

class OkButtonCompleted extends StatefulWidget {
  const OkButtonCompleted({Key? key}) : super(key: key);

  @override
  _OkButtonCompletedState createState() => _OkButtonCompletedState();
}

class _OkButtonCompletedState extends State<OkButtonCompleted> {


  @override
  Widget build(BuildContext context) {
    ProviderData providerData = ProviderData();
    return Container(
      width: space_16,
      height: space_6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(space_10),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: activeButtonColor),
          onPressed: () {

            providerData.updateCompletedDate("");
            Get.back();
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: size_6,
            ),
          ),
        ),
      ),
    );
  }
}
