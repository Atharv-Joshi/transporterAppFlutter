import 'package:flutter/material.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'package:liveasy/widgets/bidCardHeader.dart';

import 'bidCardFooter.dart';

// ignore: must_be_immutable
class BidCard extends StatefulWidget {
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;
  LoadPosterModel? loadPosterModel;

  BidCard({this.bidsModel, this.loadDetailsScreenModel, this.loadPosterModel});

  @override
  _BidCardState createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BidCardHeader(
          bidsModel: widget.bidsModel,
          loadDetailsScreenModel: widget.loadDetailsScreenModel,
          loadPosterModel: widget.loadPosterModel,
        ),
        BidCardFooter(
          bidsModel: widget.bidsModel,
          loadDetailsScreenModel: widget.loadDetailsScreenModel,
        )
      ],
    );
  }
}
