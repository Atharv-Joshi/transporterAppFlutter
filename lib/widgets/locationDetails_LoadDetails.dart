import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'LoadEndPointTemplate.dart';
import 'linePainter.dart';

// ignore: must_be_immutable
class LocationDetailsLoadDetails extends StatelessWidget {
  Map loadDetails;

  LocationDetailsLoadDetails({
    required this.loadDetails
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: space_3),
          child: Text("Posted on : ${loadDetails['loadDate']}",
            style: TextStyle(
                fontWeight: regularWeight,
                fontSize: size_6,
                color: veryDarkGrey),
          ),
        ),

        Text(
          AppLocalizations.of(context)!.loadDetails,
          style: TextStyle(
              fontWeight: mediumBoldWeight,
              fontSize: size_7),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: space_3),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: space_1),
                      child: Image(
                        image:
                            AssetImage("assets/icons/greenFilledCircleIcon.png"),
                      ),
                      width: space_2,
                      height: space_2,
                    ),
                    Expanded(
                      child: Text(
                        "${loadDetails['loadingPoint']}",
                        style:
                            TextStyle(fontWeight: normalWeight, fontSize: size_6),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: space_5,
                padding: EdgeInsets.only(left: space_1 - 3),
                child: CustomPaint(
                  foregroundPainter: LinePainter(height: space_5, width: 1),
                ),
              ),

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: space_1),
                    child: Image(
                      image: AssetImage(
                          "assets/icons/redSemiFilledCircleIcon.png"),
                    ),
                    width: space_2,
                    height: space_2,
                  ),
                  Expanded(
                    child: Text(
                      "${loadDetails['unloadingPoint']}",
                      style:
                          TextStyle(fontWeight: normalWeight, fontSize: size_6),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
}
