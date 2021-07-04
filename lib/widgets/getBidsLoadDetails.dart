import 'package:flutter/material.dart';
import 'package:liveasy/functions/getLoadDetailsFromLoadId.dart';
import 'package:liveasy/models/bidsModel.dart';

import 'GetBidRequestorDetails.dart';
import 'loadingWidget.dart';

// ignore: must_be_immutable
class GetBidsLoadDetails extends StatefulWidget {
  BidsModel? bidsModel;

  GetBidsLoadDetails({this.bidsModel});

  @override
  _GetBidsLoadDetailsState createState() => _GetBidsLoadDetailsState();
}

class _GetBidsLoadDetailsState extends State<GetBidsLoadDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoadDetailsFromLoadId(widget.bidsModel!.loadId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: LoadingWidget());
          }
          return GetBidRequestorDetails(
              bidsModel: widget.bidsModel, loadDetailsScreenModel: snapshot.data);
        });
  }
}
