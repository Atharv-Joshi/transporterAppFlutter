import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/unverifiedWidget.dart';
import 'package:liveasy/widgets/verifiedWidget.dart';

// ignore: must_be_immutable
class LoadPosterDetailsLoadDetails extends StatelessWidget {
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  bool? loadPosterCompanyApproved;

  LoadPosterDetailsLoadDetails({
    this.loadPosterLocation,
    this.loadPosterName,
    this.loadPosterCompanyName,
    this.loadPosterCompanyApproved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_1 + 3),
        color: darkBlueColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: space_2, right: space_3),
            child: CircleAvatar(
              radius: space_10 + 4,
              backgroundImage:
                  AssetImage("assets/images/defaultDriverImage.png"),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.575,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "$loadPosterName",
                          // textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              color: white,
                              fontSize: size_9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space_1 - 2,
                    ),
                    Row(
                      children: [
                        Image(
                          image: AssetImage("assets/icons/buildingIcon.png"),
                          height: space_3 + 1,
                          width: space_3,
                        ),
                        SizedBox(
                          width: space_1 - 2,
                        ),
                        Text(
                          loadPosterCompanyName!.length > 26
                          ?
                          "${loadPosterCompanyName!.substring(0,24)}.."
                          : '$loadPosterCompanyName',
                          style: TextStyle(
                              fontWeight: normalWeight,
                              color: white,
                              fontSize: size_6),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space_1 - 1,
                    ),
                    Row(
                      children: [
                        Container(
                          height: space_3,
                          width: space_3 - 2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/icons/locationIcon.png",
                                ),
                              )),
                        ),
                        SizedBox(
                          width: space_1,
                        ),
                        Text(
                          "$loadPosterLocation",
                          style: TextStyle(
                              fontWeight: normalWeight,
                              color: white,
                              fontSize: size_6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: space_1 + 1,
              ),
              loadPosterCompanyApproved!
                  ? VerifiedWidget()
                  : UnverifiedWidget()
            ],
          ),
        ],
      ),
    );
  }
}
