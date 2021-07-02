import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/acceptButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
import 'package:liveasy/widgets/priceContainer.dart';

import 'LoadEndPointTemplate.dart';
import 'linePainter.dart';

class BiddingCard extends StatelessWidget {
  final String? loadId;
  final String? bidId;
  final String? loadingPointCity;
  final String? unloadingPointCity;
  final String? rate;
  final String? unitValue;
  final String? companyName;
  final String? biddingDate;
  final String? transporterPhoneNum;

  BiddingCard(
      {required this.loadId,
      required this.loadingPointCity,
      required this.unloadingPointCity,
      required this.biddingDate,
      required this.unitValue,
      required this.rate,
      required this.companyName,
      required this.transporterPhoneNum,
      required this.bidId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.all(space_4),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadEndPointTemplate(
                          text: loadingPointCity, endPointType: 'loading'),
                      Container(
                          padding: EdgeInsets.only(left: 2),
                          height: space_6,
                          width: space_12,
                          child: CustomPaint(
                            foregroundPainter: LinePainter(),
                          )),
                      LoadEndPointTemplate(
                          text: unloadingPointCity, endPointType: 'unloading'),
                    ],
                  ),
                  PriceContainer(
                    rate: rate,
                    unitValue: unitValue,
                  ),
                ],
              ),
              SizedBox(
                height: space_2,
              ),
              LoadLabelValueRowTemplate(
                  value: companyName, label: 'Transporter'),
              LoadLabelValueRowTemplate(
                  value: biddingDate, label: 'Bidding Date'),
              Container(
                margin: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AcceptButton(
                      bidId: bidId,
                      isBiddingDetails: null,
                    ),
                    CallButton(
                      directCall: true,
                      driverPhoneNum: transporterPhoneNum,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
