import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';

import 'linePainter.dart';

class Loadwidget extends StatelessWidget {
  String? trucktype;
  String? producttype;
  int? Weight;
  int? tyres;
  String? loadFrom;
  String? loadTo;
  int? load;

  Loadwidget(
      {this.trucktype,
      this.producttype,
      this.Weight,
      this.tyres,
      this.loadFrom,
      this.load,
      this.loadTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 243,
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(space_3),
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
                            fontSize: size_9, fontWeight: mediumBoldWeight),
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
                          border: Border.all(width: 3, color: liveasyred),
                        ),
                      ),
                      Text(
                        loadTo!,
                        style: TextStyle(
                            fontSize: size_9, fontWeight: mediumBoldWeight),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 7.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "TruckType",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: liveasyBlackColor,
                                      fontFamily: "Montserrat"),
                                ),
                                Text(
                                  trucktype!,
                                  style: TextStyle(
                                    fontSize: size_7,
                                    fontWeight: mediumBoldWeight,
                                    color: cardgrey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 48),
                              child: Column(
                                children: [
                                  Text(
                                    "Tyre",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: liveasyBlackColor,
                                        fontFamily: "Montserrat"),
                                  ),
                                  Text(
                                    tyres!.toString(),
                                    style: TextStyle(
                                      fontSize: size_7,
                                      fontWeight: mediumBoldWeight,
                                      color: cardgrey,
                                    ),
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
                                  "Weight",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: liveasyBlackColor,
                                      fontFamily: "Montserrat"),
                                ),
                                Text(
                                  "${Weight!.toString()} tons",
                                  style: TextStyle(
                                    fontSize: size_7,
                                    fontWeight: mediumBoldWeight,
                                    color: cardgrey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Column(
                                children: [
                                  Text(
                                    "Product type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: liveasyBlackColor,
                                        fontFamily: "Montserrat"),
                                  ),
                                  Text(
                                    producttype!,
                                    style: TextStyle(
                                      fontSize: size_7,
                                      fontWeight: mediumBoldWeight,
                                      color: cardgrey,
                                    ),
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
                    padding: EdgeInsets.only(top: size_7),
                    child: Container(
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
                  )
                  //track and call button
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: space_7,
                    right: space_4,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 140,
                      ),
                      Positioned(
                        left: 20,
                        child: Container(
                          width: 85,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size_4),
                            color: truckGreen,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Image(
                            image: AssetImage(
                                "assets/images/overviewtataultra.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 11.0, left: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 86,
                      height: 31,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size_10),
                        color: bidBackground,
                      ),
                      child: Center(
                        child: Text(
                          "View bids",
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              fontSize: size_6,
                              color: Colors.white,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
