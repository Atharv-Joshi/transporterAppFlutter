//TODO: pagination,decoration
import 'package:flutter/material.dart';
import 'package:liveasy/functions/getBidsFromBidApi.dart';
import 'package:liveasy/widgets/noBidsWidget.dart';
import 'package:liveasy/widgets/getBidsLoadDetails.dart';

import 'loadingWidget.dart';

class GetBids extends StatefulWidget {
  @override
  _GetBidsState createState() => _GetBidsState();
}

class _GetBidsState extends State<GetBids> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.67,
      child: FutureBuilder(
          future: getBidsFromBidApi(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: LoadingWidget());
            } else if (snapshot.data.length == 0) {
              return NoBidsWidget();
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(),
              itemCount: (snapshot.data.length),
              itemBuilder: (BuildContext context, index) =>
                  GetBidsLoadDetails(bidsModel: snapshot.data[index]),
            );
          }),
    );
  }
}
