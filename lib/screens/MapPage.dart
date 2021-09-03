import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/functions/BackgroundAndLocation.dart';
import 'package:flutter_background/flutter_background.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MapPage> {
  final switchData = GetStorage();
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    getDeviceDetails();
    bool enabled = FlutterBackground.isBackgroundExecutionEnabled;
    if(switchData.read('isSwitched') != null)
    {
      setState(() {
        isSwitched = switchData.read('isSwitched');
        if(isSwitched == true) {
          if (enabled == true) {
            print("It is Okay Working");
          } else if (enabled == false) {
            print("Enabled is false");
            backgroundTry();
          }

        } else {
          print("Button is off $isSwitched");
          if(enabled == true) {
            print("Executing Background false");
            backgroundCancel();
          } else {
            print("You are Okay to go");
          }
        }
      });
    }
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
                onPressed: () async => {
                  // _getUserAddress(),
                  // timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getUserAddress()),
                // success1 = await FlutterBackground.enableBackgroundExecution(),
                  backgroundTry(),
                  print("Success in button is pressed")
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
              SizedBox(
                height: 20,
              ),
                  Switch(
                  value: isSwitched,
                  onChanged: (value){
                    setState(() {
                      isSwitched = value;
                      switchData.write('isSwitched', isSwitched);
                      if(isSwitched == true) {
                        backgroundTry();
                      } else {
                        backgroundCancel();
                      }
                    });
                  }
                  )
            ],
          ),
        ),
      ),
    );
  }
}


void printHello() {
final DateTime now = DateTime.now();
print("[$now] Hello, world!");
}

