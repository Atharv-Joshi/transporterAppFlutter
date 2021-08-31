import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/loadingPointImageIcon.dart';
import 'package:liveasy/widgets/unloadingPointImageIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomeScreenLoadsCard extends StatelessWidget {

  final LoadDetailsScreenModel loadDetailsScreenModel;

  HomeScreenLoadsCard({
    required this.loadDetailsScreenModel,
  });

  @override
  Widget build(BuildContext context) {
    String rateLengthData = loadDetailsScreenModel.rate!.length > 5
        ? loadDetailsScreenModel.rate!.substring(0, 4) + ".."
        : loadDetailsScreenModel.rate!;
    String tonne = AppLocalizations.of(context)!.tonne;
    String rateInTonnes =
        (rateLengthData[0] == 'N' ? "--" : "\u20B9$rateLengthData/$tonne");

    return GestureDetector(
        onTap: () => {
              Get.to(
                () => LoadDetailsScreen(
                    loadDetailsScreenModel: loadDetailsScreenModel),
              )
            },
        child: Card(
          elevation: elevation_2,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(space_2),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LoadingPointImageIcon(
                              width: space_2 - 1, height: space_2 - 1),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            loadDetailsScreenModel.loadingPointCity!.length > 20
                                ? "${loadDetailsScreenModel.loadingPointCity!.substring(0, 19)}..."
                                : loadDetailsScreenModel.loadingPointCity!,
                            style: TextStyle(
                                fontFamily: 'montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: size_7),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: space_4,
                        //padding: EdgeInsets.only(left: space_1 - 3),
                        child: CustomPaint(
                          foregroundPainter:
                              LinePainter(height: space_5, width: 1),
                        ),
                      ),
                      SizedBox(
                        height: space_1,
                      ),
                      Row(
                        children: [
                          UnloadingPointImageIcon(
                              width: space_2 - 1, height: space_2 - 1),
                          SizedBox(
                            width: space_1 + 1,
                          ),
                          Text(
                            loadDetailsScreenModel.unloadingPointCity!.length >
                                    20
                                ? "${loadDetailsScreenModel.unloadingPointCity!.substring(0, 19)}..."
                                : loadDetailsScreenModel.unloadingPointCity!,
                            style: TextStyle(
                                fontFamily: 'montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: size_7),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: solidLineColor,
                            borderRadius: BorderRadius.circular(radius_1 - 1),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: space_1, horizontal: 2),
                          height: space_5,
                          width: space_15 + 3,
                          child: Center(
                            child: Text(
                              "${loadDetailsScreenModel.weight} ${AppLocalizations.of(context)!.tonnes}",
                              style: TextStyle(
                                  fontFamily: 'montserrat',
                                  color: bidBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size_5),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: solidLineColor,
                            borderRadius: BorderRadius.circular(radius_1 - 1),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: space_1, horizontal: 2),
                          height: space_5,
                          width: space_15 + 3,
                          child: Center(
                            child: Text(
                              rateInTonnes,
                              style: TextStyle(
                                  fontFamily: 'montserrat',
                                  color: bidBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size_5),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
