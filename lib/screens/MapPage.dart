import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostIMEILatLangData.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MapPage> {
  late Timer timer;
  Position? _currentPosition;
  double? latitude;
  double? longitude;
  String? device_Name;
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  @override
  void initState() {
    super.initState();
    _getDeviceDetails();
  }

  _getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var brand = androidInfo.brand;
    device_Name = "$brand ${androidInfo.model}";
  }

  _getUserAddress() async {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
        _currentPosition = position;
        latitude = _currentPosition!.latitude;
        longitude = _currentPosition!.longitude;
        print("Lat is $latitude");
        print("longitude is $longitude");
        print("Device Name is $device_Name");
        postIMEILatLngData(
            lat: (latitude.toString()),
            trasnporterID: transporterIdController.transporterId.value,
            deviceName: device_Name,
            powerValue: '12',
            lng: (longitude.toString()),
            direction: 'dir',
            speed: '90'
        );
    }).catchError((e) {
      print("Error is $e");
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Map it is")
        ),
        body: Container(
          child: Column(
            children: [
              TextButton(
                child: Text("Start Location"),
                onPressed: () => {
                  print("Click is working"),
                  _getUserAddress(),
                  timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getUserAddress())
                }),
              SizedBox(
                height: 50,
              ),
              TextButton(
                child: Text("Stop Location"),
                onPressed: () => {
                  timer.cancel()
                  // _locationSubscription.cancel()
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
