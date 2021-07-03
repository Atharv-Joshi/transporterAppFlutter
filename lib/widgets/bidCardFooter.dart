import 'package:flutter/material.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/buttons/confirmOrderButton.dart';

// ignore: must_be_immutable
class BidCardFooter extends StatelessWidget {
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  BidCardFooter({this.bidsModel, this.loadDetailsScreenModel});

  @override
  Widget build(BuildContext context) {
    if (bidsModel!.shipperApproval == true) {
      return Card(
          child: ConfirmOrderButton(
        bidsModel: bidsModel,
        loadDetailsScreenModel: loadDetailsScreenModel,
      ));
    } else
      return Container();
  }
}
