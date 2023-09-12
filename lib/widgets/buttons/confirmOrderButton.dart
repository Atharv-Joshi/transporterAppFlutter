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
import 'package:liveasy/widgets/alertDialog/bookLoadAlertDialogBox.dart';
import 'package:get/get.dart';

import '../../functions/BackgroundAndLocation.dart';
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
  LoadDetailsScreenModel loadDetailsScreenModel;

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
                await getLoadData(widget.biddingModel.loadId.toString())
                    .then((value) => Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return transporterIdController
                                    .transporterApproved.value
                                ? BookLoadScreen(
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

  Future<LoadDetailsScreenModel> getLoadData(loadId) async {
    await dotenv.load(
        fileName: ".env"); // Calling the env get method through dot_env------

    String loadApiUrl = kIsWeb
        ? dotenv.get('loadApiUrl').toString()
        : FlutterConfig.get("loadApiUrl").toString();

    debugPrint(
        "$loadApiUrl--------------LOAD API URL (runWidgetSuggestedLoadApiWithPageNo)-----------------------");
    // --------------
    var json;
    var loadData = [];
    Uri url = Uri.parse("$loadApiUrl/$loadId");
    http.Response response = await http.get(url);
    json = await jsonDecode(response.body);
    LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
    loadDetailsScreenModel.loadId =
        json["loadId"] != null ? json['loadId'] : 'NA';
    loadDetailsScreenModel.loadingPoint =
        json["loadingPoint"] != null ? json['loadingPoint'] : 'NA';
    loadDetailsScreenModel.loadingPointCity =
        json["loadingPointCity"] != null ? json['loadingPointCity'] : 'NA';
    loadDetailsScreenModel.loadingPointState =
        json["loadingPointState"] != null ? json['loadingPointState'] : 'NA';
    loadDetailsScreenModel.loadingPoint2 =
        json["loadingPoint2"] != null ? json['loadingPoint2'] : 'NA';
    loadDetailsScreenModel.loadingPointCity2 =
        json["loadingPointCity2"] != null ? json['loadingPointCity2'] : 'NA';
    loadDetailsScreenModel.loadingPointState =
        json["loadingPointState2"] != null ? json['loadingPointState2'] : 'NA';
    loadDetailsScreenModel.postLoadId =
        json["postLoadId"] != null ? json['postLoadId'] : 'NA';
    loadDetailsScreenModel.unloadingPoint =
        json["unloadingPoint"] != null ? json['unloadingPoint'] : 'NA';
    loadDetailsScreenModel.unloadingPointCity =
        json["unloadingPointCity"] != null ? json['unloadingPointCity'] : 'NA';
    loadDetailsScreenModel.unloadingPointState =
        json["unloadingPointState"] != null
            ? json['unloadingPointState']
            : 'NA';
    loadDetailsScreenModel.unloadingPoint2 =
        json["unloadingPoint2"] != null ? json['unloadingPoint2'] : 'NA';
    loadDetailsScreenModel.unloadingPointCity =
        json["unloadingPointCity2"] != null
            ? json['unloadingPointCity2']
            : 'NA';
    loadDetailsScreenModel.unloadingPointState =
        json["unloadingPointState2"] != null
            ? json['unloadingPointState2']
            : 'NA';
    loadDetailsScreenModel.productType =
        json["productType"] != null ? json['productType'] : 'NA';
    loadDetailsScreenModel.truckType =
        json["truckType"] != null ? json['truckType'] : 'NA';
    loadDetailsScreenModel.noOfTyres =
        json["noOfTyres"] != null ? json['noOfTyres'] : 'NA';
    loadDetailsScreenModel.weight =
        json["weight"] != null ? json['weight'] : 'NA';
    loadDetailsScreenModel.comment =
        json["comment"] != null ? json['comment'] : 'NA';
    loadDetailsScreenModel.status =
        json["status"] != null ? json['status'] : 'NA';
    loadDetailsScreenModel.loadDate =
        json["loadDate"] != null ? json['loadDate'] : 'NA';
    loadDetailsScreenModel.rate =
        json["rate"] != null ? json['rate'].toString() : 'NA';
    loadDetailsScreenModel.unitValue =
        json["unitValue"] != null ? json['unitValue'] : 'NA';

    return loadDetailsScreenModel;
  }
}
