import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';

import 'linePainter.dart';

class biddingcard extends StatelessWidget {
  String? truckno;
  String? bookedon;
  String? loadFrom;
  String? companyname;
  String? loadTo;
  int? load;

  biddingcard(
      {this.truckno,
      this.bookedon,
      this.loadFrom,
      this.load,
      this.loadTo,
      this.companyname});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 243,
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 8,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(space_3, space_3, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                                  height: space_2,
                                  width: space_2,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                Text(
                                  loadFrom!,
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Container(
                                child: CustomPaint(
                                  size: Size(0, 30),
                                  foregroundPainter: LinePainter(),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                                  height: space_2,
                                  width: space_2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:
                                        Border.all(width: 3, color: liveasyred),
                                  ),
                                ),
                                Text(
                                  loadTo!,
                                  style: TextStyle(
                                      fontSize: size_9,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 7.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Truck No.   :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: liveasyBlackColor,
                                                  fontFamily: "Montserrat"),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 14),
                                          child: Column(
                                            children: [
                                              Text(
                                                truckno!,
                                                style: TextStyle(
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    fontSize: 14,
                                                    color: cardgrey,
                                                    fontFamily: "Montserrat"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 7.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Booked on :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: liveasyBlackColor,
                                                  fontFamily: "Montserrat"),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 14),
                                          child: Column(
                                            children: [
                                              Text(
                                                bookedon!,
                                                style: TextStyle(
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    fontSize: 14,
                                                    color: cardgrey,
                                                    fontFamily: "Montserrat"),
                                              ),
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
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: priceBackground),
                        child: Container(
                          child: Center(
                            child: Text(
                              "₹${load.toString()}/tonne",
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_6,
                                  color: bidBackground,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size_3,
                        ),
                        child: Row(
                          children: [
                            Image(image: AssetImage("assets/images/truck.png")),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              companyname!,
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: 14,
                                  color: cardgrey,
                                  fontFamily: "Montserrat"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 86,
                        height: 31,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(
                                  0,
                                  8.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 5.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(size_10),
                            border: Border.all(width: 1, color: bidBackground)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 18, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.call,
                                size: 16,
                                color: liveasyBlackColor,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Call",
                                style: TextStyle(
                                    fontWeight: mediumBoldWeight,
                                    fontSize: size_6,
                                    color: liveasyBlackColor,
                                    fontFamily: "Montserrat"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        color: shareButtonColor,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                size_7, size_4, size_7, size_4),
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_6,
                                  color: backgroundColor,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        color: liveasyred,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                size_7, size_4, size_7, size_4),
                            child: Text(
                              "Decline",
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_6,
                                  color: backgroundColor,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
