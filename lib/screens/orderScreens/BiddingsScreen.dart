import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/BiddingsTitleTextWidget.dart';
import 'package:liveasy/widgets/biddingcard.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';

// ignore: camel_case_types
class BiddingsScreen extends StatefulWidget {
  String? loadFrom;
  String? loadTo;
  int? load;
  BiddingsScreen({Key? key, this.loadFrom, this.loadTo, this.load})
      : super(key: key);

  @override
  _BiddingsScreenState createState() => _BiddingsScreenState();
}

class _BiddingsScreenState extends State<BiddingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: space_10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: space_3),
                child: Row(
                  children: [
                    BackButtonWidget(),
                    SizedBox(width: size_7),
                    BiddingsTitleTextWidget()
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(size_7, size_0, size_7, size_7),
                        child: BiddingCard(
                          loadFrom: widget.loadFrom,
                          loadTo: widget.loadTo,
                          load: 8000,
                          truckNo: "AP 28 08 5270",
                          bookedOn: "06 MAR,2021",
                          companyName: "RST transport",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(size_7, size_0, size_7, size_7),
                        child: BiddingCard(
                          loadFrom: widget.loadFrom,
                          loadTo: widget.loadTo,
                          load: 4000,
                          truckNo: "KL 28 08 1280",
                          bookedOn: "07 MAR,2021",
                          companyName: "PGM Logistics",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(size_7, size_0, size_7, size_7),
                        child: BiddingCard(
                          loadFrom: widget.loadFrom,
                          loadTo: widget.loadTo,
                          load: 4000,
                          truckNo: "KL 28 08 1280",
                          bookedOn: "07 MAR,2021",
                          companyName: "PGM Logistics",
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(size_7, size_0, size_7, size_7),
                        child: BiddingCard(
                          loadFrom: widget.loadFrom,
                          loadTo: widget.loadTo,
                          load: 4000,
                          truckNo: "KL 28 08 1280",
                          bookedOn: "07 MAR,2021",
                          companyName: "PGM Logistics",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
