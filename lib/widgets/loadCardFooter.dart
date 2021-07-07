import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';

// ignore: must_be_immutable
class LoadCardFooter extends StatelessWidget {
  String? loadPosterCompanyName;
  String? loadPosterPhoneNo;

  LoadCardFooter({this.loadPosterCompanyName, this.loadPosterPhoneNo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: EdgeInsets.symmetric(horizontal: space_3),
      color: contactPlaneBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: space_1),
                child: Image(
                  image: AssetImage("assets/icons/buildingIconBlack.png"),
                  height: size_8,
                  width: size_8 - 1,
                ),
              ),
              Text(
                "$loadPosterCompanyName",
                style:
                    TextStyle(fontSize: size_7, fontWeight: mediumBoldWeight),
              )
            ],
          ),
          // CallButton(loadPosterPhoneNo: "$loadPosterPhoneNo"),
          CallButton(
            directCall: true,
            phoneNum: loadPosterPhoneNo,
          )
        ],
      ),
    );
  }
}
