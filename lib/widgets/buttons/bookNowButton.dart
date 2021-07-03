import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverDetailsFromDriverApi.dart';
import 'package:liveasy/functions/getTruckDetailsFromTruckApi.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/alertDialog/bookNowButtonAlertDialog.dart';

// ignore: must_be_immutable
class BookNowButton extends StatefulWidget {
  LoadDetailsScreenModel loadDetails;

  BookNowButton({required this.loadDetails});

  @override
  _BookNowButtonState createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<BookNowButton> {
  List truckDetailsList = [];
  List driverDetailsList = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
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
              loadDetailsScreenModel: widget.loadDetails,
              directBooking: true,
            ),
          );
        },
        child: Container(
          height: space_8,
          width: (space_16 * 2) + 3,
          decoration: BoxDecoration(
              color: darkBlueColor,
              borderRadius: BorderRadius.circular(radius_6)),
          child: Center(
            child: Text(
              "Book Now",
              style: TextStyle(
                  fontSize: size_8, fontWeight: mediumBoldWeight, color: white),
            ),
          ),
        ));
  }
}
