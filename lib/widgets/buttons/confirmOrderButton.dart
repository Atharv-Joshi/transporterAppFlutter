import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/alertDialog/bookNowButtonAlertDialog.dart';

// ignore: must_be_immutable
class ConfirmOrderButton extends StatefulWidget {
  BiddingModel biddingModel;

  ConfirmOrderButton({required this.biddingModel});

  @override
  _ConfirmOrderButtonState createState() => _ConfirmOrderButtonState();
}

class _ConfirmOrderButtonState extends State<ConfirmOrderButton> {
  List<TruckModel> truckDetailsList = [];

  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();

  @override
  void initState() {
    super.initState();
    loadData();

  }

  loadData() async {
    truckDetailsList = await truckApiCalls.getTruckData();
    driverDetailsList = await driverApiCalls.getDriversByTransporterId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space_3),
      height: 31,
      child: TextButton(
        child: Text(
          'Confirm',
          style: TextStyle(
              letterSpacing: 1,
              fontSize: size_6 + 1,
              color: white,
              fontWeight: mediumBoldWeight),
        ),
        onPressed: () async {
           showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => BookNowButtonAlertDialog(
                truckDetailsList: truckDetailsList,
                driverDetailsList: driverDetailsList,
                biddingModel: widget.biddingModel,
                directBooking: false),
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius_6),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(liveasyGreen),
        ),
      ),
    );
  }
}
