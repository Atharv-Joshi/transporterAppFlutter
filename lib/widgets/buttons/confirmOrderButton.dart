import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverDetailsFromDriverApi.dart';
import 'package:liveasy/functions/getTruckDetailsFromTruckApi.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/alertDialog/bookNowButtonAlertDialog.dart';

// ignore: must_be_immutable
class ConfirmOrderButton extends StatelessWidget {
  BidsModel? bidsModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  ConfirmOrderButton({required this.bidsModel, this.loadDetailsScreenModel});

  List truckDetailsList = [];
  List driverDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: space_3),
      height: space_6 + 1,
      width: double.infinity,
      child: TextButton(
        child: Text(
          'Confirm order',
          style: TextStyle(
              letterSpacing: 1,
              fontSize: size_6 + 1,
              color: white,
              fontWeight: mediumBoldWeight),
        ),
        onPressed: () async {
          await getTruckDetailsFromTruckApi(context)
              .then((truckDetailsListFromApi) {
            truckDetailsList = truckDetailsListFromApi;
            // driverDetailsList = truckAndDriverList[1];
          });
          await getDriverDetailsFromDriverApi(context)
              .then((driverDetailsListFromApi) {
            driverDetailsList = driverDetailsListFromApi;
          });

          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => BookNowButtonAlertDialog(
                truckDetailsList: truckDetailsList,
                driverDetailsList: driverDetailsList,
                bidsModel: bidsModel,
                loadDetailsScreenModel: loadDetailsScreenModel,
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
