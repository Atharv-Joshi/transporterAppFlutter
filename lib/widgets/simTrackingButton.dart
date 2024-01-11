import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/trasnporterApis/transporterApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/screens/myLoadPages/trackOngoing/trackScreenOngoing.dart';
import 'package:liveasy/screens/trackScreen.dart';
//This screen will be shown or used for sim-based tracking on web
// ignore: must_be_immutable
class simTrackingButton extends StatefulWidget {
  bool truckApproved = false;
  String? phoneNo;
  String? TruckNo;
  String? imei;
  String? DriverName;
  var gpsData;
  var totalDistance;
  var device;

  simTrackingButton({
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
  _simTrackingButtonState createState() => _simTrackingButtonState();
}

class _simTrackingButtonState extends State<simTrackingButton> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: space_8,
      width: space_20,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(space_2),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: () async {
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
        },
        child: Container(
          child: Row(
            children: [
              Container(
                child: Image(image: AssetImage('assets/icons/sim.png')),
              ),
              Text(
                'SIM',
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
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
