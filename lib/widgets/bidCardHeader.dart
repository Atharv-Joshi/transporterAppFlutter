import 'package:flutter/material.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:liveasy/widgets/buttons/priceButton.dart';
import 'LoadEndPointTemplate.dart';
import 'buttons/callButton.dart';
import 'linePainter.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
// ignore: must_be_immutable
class BidCardHeader extends StatelessWidget {
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;
  LoadPosterModel? loadPosterModel;


  BidCardHeader(
      {this.bidsModel, this.loadDetailsScreenModel, this.loadPosterModel});

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
                            text: loadDetailsScreenModel!
                                .loadingPointCity !=
                                null
                                ? loadDetailsScreenModel!.loadingPointCity
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
                            text: loadDetailsScreenModel!
                                .unloadingPointCity !=
                                null
                                ? loadDetailsScreenModel!.unloadingPointCity
                                .toString()
                                : 'NA',
                            endPointType: 'unloading'),
                      ],
                    ),
                    PriceButtonWidget(
                        rate: bidsModel!.rate,
                        unitValue: bidsModel!.unitValue),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: space_4),
                  child: Column(
                    children: [
                      LoadLabelValueRowTemplate(
                          value: loadPosterModel!.loadPosterCompanyName
                              .toString(),
                          label: 'Shipper'),
                      LoadLabelValueRowTemplate(
                          value: bidsModel!.biddingDate.toString(),
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
                  phoneNum: loadPosterModel!.loadPosterPhoneNo,
                  directCall: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
