import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:get/get.dart';

import '../../functions/BackgroundAndLocation.dart';
import '../../functions/getLoadDetailsFromLoadId.dart';
import '../../models/loadDetailsScreenModel.dart';
import '../../screens/myLoadPages/bookLoadScreen.dart';
import '../alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ConfirmOrderButton extends StatefulWidget {
  BiddingModel biddingModel;
  final String? postLoadId;
  bool? shipperApproval;
  bool? transporterApproval;
  LoadDetailsScreenModel loadDetailsScreenModel; //Instance of LoadDetailsScreenModel is created

  ConfirmOrderButton({
    this.transporterApproval,
    this.shipperApproval,
    required this.biddingModel,
    required this.postLoadId,
    required this.loadDetailsScreenModel,
  });

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
          "confirm".tr,
          style: TextStyle(
              letterSpacing: 1,
              fontSize: size_6 + 1,
              color: white,
              fontWeight: mediumBoldWeight),
        ),
        onPressed: (widget.shipperApproval == false &&
                widget.transporterApproval == true)
            ? null
            : () async {
                if (widget.shipperApproval == true &&
                    widget.transporterApproval == false) {
                  // putBidForAccept(bidId);
                }
                await getLoadDetailsFromLoadId( //this function is called to get the load information based on the loadId
                        widget.biddingModel.loadId.toString()) //loadId will be generated in the response of the biddingModel
                    .then((value) => Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return transporterIdController
                                    .transporterApproved.value
                                ? BookLoadScreen( //BookLoadScreen will open while confirming the orders in bidding section
                                    truckModelList: truckDetailsList,
                                    driverModelList: driverDetailsList,
                                    loadDetailsScreenModel: value,
                                    directBooking: true,
                                  )
                                : VerifyAccountNotifyAlertDialog();
                          },
                        )));
              },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius_6),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(
              (widget.shipperApproval == false &&
                      widget.transporterApproval == true)
                  ? unselectedGrey
                  : liveasyGreen),
        ),
      ),
    );
  }
}
