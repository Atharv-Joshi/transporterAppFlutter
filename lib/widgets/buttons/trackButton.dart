import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/gpsDataController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/screens/displayMapUsingImei.dart';

// ignore: must_be_immutable
class TrackButton extends StatelessWidget {
  bool truckApproved = false;
  String? imei;
  Position? userLocation;
  TrackButton({required this.truckApproved, this.imei, this.userLocation});

  @override
  Widget build(BuildContext context) {
    MapUtil mapUtil = MapUtil();
    return Container(
      height: 31,
      width: 90,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
        ),
        onPressed: () async {
          if (imei != null) {
            EasyLoading.instance
              ..indicatorType = EasyLoadingIndicatorType.ring
              ..indicatorSize = 45.0
              ..radius = 10.0
              ..maskColor = darkBlueColor
              ..userInteractions = false
              ..backgroundColor = darkBlueColor
              ..dismissOnTap = false;
            EasyLoading.show(
              status: "Loading...",
            );
            var gpsData = await mapUtil.getLocationByImei(imei: imei);
            if (gpsData != null) {
              GpsDataController gpsDataController = Get.put(GpsDataController());
              gpsDataController.updateGpsData(gpsData);
              EasyLoading.dismiss();
              Get.to(
                ShowMapWithImei(
                  gpsData: gpsData,
                  userLocation: userLocation,
                ),
              );
            }
            else{
              EasyLoading.dismiss();
              print("gpsData null");
            }
          }
          else{print("imei is null");}
        },
        child: Container(
          margin: EdgeInsets.only(left: space_2),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: space_1),
                child: truckApproved
                    ? Container()
                    : Image(
                        height: 16,
                        width: 11,
                        image: AssetImage('assets/icons/lockIcon.png')),
              ),
              Text(
                'Track',
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