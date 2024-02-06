import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/alertDialog/trackingNotAvailableAlert.dart';

// ignore: must_be_immutable
class TrackButton extends StatefulWidget {
  bool truckApproved = false;
  String? phoneNo;
  String? TruckNo;
  String? imei;
  String? DriverName;
  var gpsData;
  var totalDistance;
  var device;

  TrackButton({
    required this.truckApproved,
    this.gpsData,
    this.phoneNo,
    this.TruckNo,
    this.DriverName,
    this.totalDistance,
    this.imei,
    this.device,
  });

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  String? transporterIDImei;
  final TransporterApiCalls transporterApiCalls = TransporterApiCalls();
  final TruckApiCalls truckApiCalls = TruckApiCalls();

  var truckData;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var endTimeParam;
  var startTimeParam;
  MapUtil mapUtil = MapUtil();
  bool loading = false;
  late String from;
  late String to;

  @override
  void initState() {
    super.initState();
    DateTime yesterday = DateTime.now()
        .subtract(Duration(days: 1, hours: 5, minutes: 30)); //from param
    from = yesterday.toIso8601String();
    DateTime now =
        DateTime.now().subtract(Duration(hours: 5, minutes: 30)); //to param
    to = now.toIso8601String();

    setState(() {
      loading = true;
    });
  }

//This button is used to navigate to track screens
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.isMobile(context) ? 31 : space_6,
      width: Responsive.isMobile(context) ? 90 : space_18 - 5,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                Responsive.isMobile(context) ? space_10 : space_1),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: () async {
          //when tracking is not available this dialog will be shown
          if (widget.gpsData == null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialogBox(
                  dialog: 'Tracking is not available on this device',
                );
              },
            );
          } else {
            Get.to(
              TrackScreen(
                deviceId: widget.gpsData.deviceId,
                gpsData: widget.gpsData,
                truckNo: widget.TruckNo,
                totalDistance: widget.totalDistance,
                imei: widget.imei,
                // online: widget.device.status == "online" ? true : false,
                online: true,
                active: true,
              ),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: space_2),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: space_1),
                child: widget.truckApproved
                    ? Container()
                    : Image(
                        height: 16,
                        width: 11,
                        image: AssetImage('assets/icons/lockIcon.png')),
              ),
              Text(
                'Track'.tr,
                style: TextStyle(
                  letterSpacing: 0.7,
                  fontWeight: normalWeight,
                  color: white,
                  fontSize: size_7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
