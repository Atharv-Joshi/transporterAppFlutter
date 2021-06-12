import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/biddingcard.dart';

class biddings extends StatefulWidget {
  const biddings({Key? key}) : super(key: key);

  @override
  _biddingsState createState() => _biddingsState();
}

class _biddingsState extends State<biddings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: space_10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: space_4, bottom: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: liveasyBlackColor,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Biddings",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: biddingcard(
                          loadFrom: "Jabalpur",
                          loadTo: "Jalandhar",
                          load: 8000,
                          truckno: "AP 28 08 5270",
                          bookedon: "06 MAR,2021",
                          companyname: "RST transport",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
                        child: biddingcard(
                          loadFrom: "Jabalpur",
                          loadTo: "Jalandhar",
                          load: 4000,
                          truckno: "KL 28 08 1280",
                          bookedon: "07 MAR,2021",
                          companyname: "PGM Logistics",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
                        child: biddingcard(
                          loadFrom: "Jabalpur",
                          loadTo: "Jalandhar",
                          load: 4000,
                          truckno: "KL 28 08 1280",
                          bookedon: "07 MAR,2021",
                          companyname: "PGM Logistics",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
                        child: biddingcard(
                          loadFrom: "Jabalpur",
                          loadTo: "Jalandhar",
                          load: 4000,
                          truckno: "KL 28 08 1280",
                          bookedon: "07 MAR,2021",
                          companyname: "PGM Logistics",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
