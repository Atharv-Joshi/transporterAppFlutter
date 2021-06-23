import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:liveasy/widgets/buttons/priceButton.dart';

import 'callButton.dart';
import 'linePainter.dart';

// ignore: must_be_immutable
class BidCard extends StatefulWidget {
  BidsModel? bidsModel;
  LoadApiModel? loadApiModel;
  LoadPosterModel? loadPosterModel;

  BidCard({this.bidsModel, this.loadApiModel, this.loadPosterModel});

  @override
  _BidCardState createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.bidsModel!.rate);
    print(widget.bidsModel!.unitValue);
    return Card(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(space_4),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: space_1),
                            child: Image(
                                height: 10,
                                width: 10,
                                image: AssetImage(
                                    'assets/icons/greenFilledCircleIcon.png')),
                          ),
                          Text(
                            "${widget.loadApiModel!.loadingPointCity}",
                            style: TextStyle(
                              color: liveasyBlackColor,
                              fontWeight: mediumBoldWeight,
                              fontSize: size_9,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 2),
                          height: space_6,
                          width: space_12,
                          child: CustomPaint(
                            foregroundPainter: LinePainter(),
                          )),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: space_1),
                            child: Image(
                                height: 10,
                                width: 10,
                                image: AssetImage(
                                    'assets/icons/redSemiFilledCircleIcon.png')),
                          ),
                          Text(
                            "${widget.loadApiModel!.unloadingPointCity}",
                            style: TextStyle(
                              color: liveasyBlackColor,
                              fontWeight: mediumBoldWeight,
                              fontSize: size_9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  PriceButtonWidget(
                    rate: widget.bidsModel!.rate,
                    unitValue: widget.bidsModel!.unitValue,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: space_4),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: space_1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipper',
                            style: TextStyle(fontWeight: normalWeight),
                          ),
                          Text(
                            widget.loadPosterModel!.loadPosterCompanyName !=
                                    null
                                ? "${widget.loadPosterModel!.loadPosterCompanyName}"
                                : 'NA',
                            style: TextStyle(fontWeight: mediumBoldWeight),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: space_1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bidding Date',
                            style: TextStyle(fontWeight: normalWeight),
                          ),
                          Text(
                            widget.bidsModel!.biddingDate != null
                                ? "${widget.bidsModel!.biddingDate}"
                                : 'NA',
                            style: TextStyle(fontWeight: mediumBoldWeight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            color: contactPlaneBackground,
            padding: EdgeInsets.symmetric(
              vertical: space_2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CancelButton(),
                CallButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
