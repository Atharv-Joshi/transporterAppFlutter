import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';

class truckAnalysisScreen extends StatefulWidget {
  var gpsStoppageHistory;

  truckAnalysisScreen({required this.gpsStoppageHistory});

  @override
  _truckAnalysisScreenState createState() => _truckAnalysisScreenState();
}

class _truckAnalysisScreenState extends State<truckAnalysisScreen> {
  var gpsStoppageHistory;

  var vaildStoppageList = [];
  void validStoppages(){
    for(var gp in gpsStoppageHistory){
      if(gp.duration >= 7200000){
        vaildStoppageList.add(gp);
      }
    }
    for(var x in vaildStoppageList){
      print("VALID STOPPAGE LIST");
      print(x);
    }

  }

  void initFunction() {
    setState(() {
      gpsStoppageHistory = widget.gpsStoppageHistory;
    });
    validStoppages();
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Analysis Screen"),
          backgroundColor: Colors.black,),
        body: NextUpdateAlertDialog());
  }
}

