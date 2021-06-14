import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'BiddingCardParameter.dart';
import 'BiddingCardParameterName.dart';
import 'FromLoadPrefix.dart';
import 'LoadPerTonne.dart';
import 'ToLoadPrefix.dart';
import 'TruckCompanyName.dart';
import 'buttons/AcceptButtton.dart';
import 'buttons/DeclineButton.dart';
import 'linePainter.dart';

// ignore: must_be_immutable
class BiddingCard extends StatelessWidget {
  String? truckNo;
  String? bookedOn;
  String? loadFrom;
  String? companyName;
  String? loadTo;
  int? load;

  BiddingCard(
      {this.truckNo,
      this.bookedOn,
      this.loadFrom,
      this.load,
      this.loadTo,
      this.companyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: size_4,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            space_3, space_3, space_0, space_0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FromLoadPrefix(),
                                Text(
                                  loadFrom!,
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: size_1),
                              child: Container(
                                child: CustomPaint(
                                  size: Size(space_0, space_6),
                                  foregroundPainter: LinePainter(),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                ToLoadPrefix(),
                                Text(
                                  loadTo!,
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: size_5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: size_3),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            BiddingCardParameter(
                                                parameter: 'Truck no.    :'),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: size_7),
                                          child: Column(
                                            children: [
                                              BiddingCardParameterName(
                                                  paraName: truckNo!),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: size_3),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            BiddingCardParameter(
                                                parameter: "Booked on :"),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: size_7),
                                          child: Column(
                                            children: [
                                              BiddingCardParameterName(
                                                  paraName: bookedOn!)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //track and call button
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size_7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LoadPerTonne(
                        load: load!,
                      ),
                      TruckCompanyName(
                        companyName: companyName!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: size_7, left: size_7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AcceptButton(),
                  DeclineButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
