import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:liveasy/widgets/buttons/priceButton.dart';
import 'LoadEndPointTemplate.dart';
import 'buttons/callButton.dart';
import 'linePainter.dart';
import 'loadLabelValueTemplate.dart';

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
    return Card(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(space_4),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoadEndPointTemplate(
                            text: widget.loadApiModel!.loadingPointCity != null
                                ? widget.loadApiModel!.loadingPointCity
                                    .toString()
                                : 'NA',
                            endPointType: 'loading'),
                        Container(
                            padding: EdgeInsets.only(left: 2),
                            height: space_6,
                            width: space_12,
                            child: CustomPaint(
                              foregroundPainter: LinePainter(),
                            )),
                        LoadEndPointTemplate(
                            text:
                                widget.loadApiModel!.unloadingPointCity != null
                                    ? widget.loadApiModel!.unloadingPointCity
                                        .toString()
                                    : 'NA',
                            endPointType: 'unloading'),
                      ],
                    ),
                    PriceButtonWidget(
                        rate: widget.bidsModel!.rate,
                        unitValue: widget.bidsModel!.unitValue),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: space_4),
                  child: Column(
                    children: [
                      LoadLabelValueTemplate(
                          value: widget.loadPosterModel!.loadPosterCompanyName
                              .toString(),
                          label: 'Truck No.'),
                      LoadLabelValueTemplate(
                          value: widget.bidsModel!.biddingDate.toString(),
                          label: 'Bidding Date'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: space_3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CancelButton(),
                CallButton(
                  phoneNo: widget.loadPosterModel!.loadPosterPhoneNo,
                  color: darkBlueColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
