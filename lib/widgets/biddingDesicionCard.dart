import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/acceptButton.dart';
import 'package:liveasy/widgets/buttons/declineButton.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';

class BiddingDecisionCard extends StatelessWidget {
  final String? rate;
  String? unitValue;
  final String? biddingDate;
  final String? bidId;

  BiddingDecisionCard(
      {required this.biddingDate,
      required this.unitValue,
      required this.rate,
      required this.bidId});

  @override
  Widget build(BuildContext context) {
    unitValue = unitValue == 'PER_TON' ? 'tonne' : 'truck';

    return Container(
      child: Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.all(space_3),
          child: Column(
            children: [
              LoadLabelValueRowTemplate(
                  value: 'Rs.$rate/$unitValue', label: 'Bidding'),
              LoadLabelValueRowTemplate(
                  value: biddingDate, label: 'Bidding Date'),
              Container(
                margin: EdgeInsets.symmetric(vertical: space_2),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AcceptButton(isBiddingDetails: true, bidId: bidId),
                  DeclineButton(
                    isBiddingDetails: true,
                    bidId: bidId,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
