import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class ProfilePhotoWidget extends StatelessWidget {
  var providerData;

  ProfilePhotoWidget({this.providerData});

  @override
  Widget build(BuildContext context) {
    return providerData.profilePhotoFile != null
        ? Container(
            height: space_23,
            width: space_23,
            decoration: BoxDecoration(
              color: white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: grey,
                  blurRadius: 5.0,
                ),
              ],
              image: DecorationImage(
                  image: Image.file(providerData.profilePhotoFile).image,
                  fit: BoxFit.fitWidth),
            ),
            child: Center(
              child: Text(
                "Tap to refresh",
                style: TextStyle(fontSize: size_7, color: liveasyGreen),
              ),
            ),
          )
        : Container(
            height: space_23,
            width: space_23,
            decoration: BoxDecoration(
              color: white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: grey,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: space_6 + 1,
                    width: space_6 - 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/icons/defaultAccountIcon.png"),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(space_15, 0, 0, space_1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius_11),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        height: space_4,
                        width: space_4,
                        child: Center(
                          child: Icon(
                            Icons.add_box_rounded,
                            color: darkBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
