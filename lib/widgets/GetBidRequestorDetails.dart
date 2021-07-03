import 'package:flutter/material.dart';
import 'package:liveasy/functions/getRequestorDetailsFromPostLoadId.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/bidCard.dart';

import 'loadingWidget.dart';

// ignore: must_be_immutable
class GetBidRequestorDetails extends StatefulWidget {
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  GetBidRequestorDetails({this.bidsModel, this.loadDetailsScreenModel});

  @override
  _GetBidRequestorDetailsState createState() => _GetBidRequestorDetailsState();
}

class _GetBidRequestorDetailsState extends State<GetBidRequestorDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRequestorDetailsFromPostLoadId(
            widget.loadDetailsScreenModel!.postLoadId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          return BidCard(
            bidsModel: widget.bidsModel,
            loadDetailsScreenModel: widget.loadDetailsScreenModel,
            loadPosterModel: snapshot.data,
          );
        });
  }
}
