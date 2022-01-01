import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/BackgroundAndLocation.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/gpsDataModel.dart';
class TruckStatus extends StatefulWidget {
  var truckHistory;
  var deviceId;
  
  TruckStatus(
      {
        required this.truckHistory,
        required this.deviceId,
       });

  @override
  _TruckStatusState createState() => _TruckStatusState();
}

class _TruckStatusState extends State<TruckStatus> {
  var startTime;
  var endTime;
  var placemarks;
  var duration;
  String? address;
  var gpsPosition;
  var newGpsPosition;
  @override
  void initState() {
    super.initState();
   // getPosition();
    print("Here ${widget.truckHistory.runtimeType}");
    if(widget.truckHistory.runtimeType==GpsDataModel) {
      getFormattedDate();
      duration = convertMillisecondsToDuration(widget.truckHistory.duration);
      
    }
    else{
      getAddress();
    }
      
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          color: backgroundColor,
          height: 132,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: backgroundColor,
            margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
        //    margin: EdgeInsets.fromLTRB(space_5, space_5, space_1, space_4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (widget.truckHistory.runtimeType!=GpsDataModel)?
                          Column(
                    children:[
                      
                      Stack(
                        children:[
                          Icon(Icons.circle,
                        color: const Color(0xFFFF6868),
                        size: 24,),
                        Positioned(
                          top: 7.8,
                          left: 7.8,
                          child: Image.asset('assets/icons/Rectangle 268.png',
                          width: 8.5,
                          height: 8.5,
                          color: const Color(0xFFB60000)),
                        ),
                        
                        ] 
                      ),
                      DottedLine(
                        direction: Axis.vertical,
                        lineLength: 108,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.black,
                        
                      )
                    ] 
                  
          )
                : Column(
                  children:[
                    Stack(
                      children:[
                        Icon(Icons.circle,
                      color: const Color(0xFFBAE5D5),
                      size: 24,),
                      Positioned(
                        left: 7.3,
                        top: 7.3,
                        child: Icon(Icons.circle,
                        color: const Color(0xFF09B778),
                        size: 9.5,),
                      ),
                      
                      
                      ] 
                    ),
                    DottedLine(
                      direction: Axis.vertical,
                      lineLength: 108,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.black,
                      
                    )
                  ]
                ),

                  Padding(
          padding: const EdgeInsets.fromLTRB(5,0,0,20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,7),
                child: Container(

                  margin: EdgeInsets.fromLTRB(space_3, 0, space_1, space_1),
                  alignment: Alignment.centerLeft,
             //   height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                      
                      (widget.truckHistory.runtimeType== GpsDataModel)?
                      Text("Travelled for   ",
                        maxLines: 2,
                        style: TextStyle(
                            color: flagGreen,
                            fontSize: size_7,
                            fontStyle: FontStyle.normal,
                            fontWeight: boldWeight
                        ),
                      )
                      : Text("Stopped for  ",
                      maxLines: 2,
                        style: TextStyle(
                            color: red,
                            fontSize: size_7,
                            fontStyle: FontStyle.normal,
                            fontWeight: boldWeight
                        ),
                      ),
                     
                (widget.truckHistory.runtimeType==GpsDataModel)?
                Container(
                  
                  child: Text("${duration}",
                  maxLines: 3,
                    style: TextStyle(
                        color: grey,
                        fontSize: size_7,
                        fontStyle: FontStyle.normal,
                        fontWeight: boldWeight
                    ),
                  ),
                )
                :Text("${widget.truckHistory[3]}",
                maxLines: 3,
                  style: TextStyle(
                      color: grey,
                      fontSize: size_7,
                      fontStyle: FontStyle.normal,
                      fontWeight: boldWeight
                  ),
                ),
                    ],
                  ),
                ),
              ),
          
          Container(
              width: MediaQuery.of(context).size.width - 74,
              margin: EdgeInsets.fromLTRB(space_3, 0, space_1, space_2),
              alignment: Alignment.centerLeft,
            child:  (widget.truckHistory.runtimeType!=GpsDataModel)?
            Text( "${widget.truckHistory[1]} - ${widget.truckHistory[2]}",
            maxLines: 3,
              style: TextStyle(
                  color: grey,
                  fontSize: size_7,
                  fontStyle: FontStyle.normal,
                  fontWeight: mediumBoldWeight
              ),
            )
                :  Text( "$startTime - $endTime",
                maxLines: 3,
              style: TextStyle(
                  color: grey,
                  fontSize: size_7,
                  fontStyle: FontStyle.normal,
                  fontWeight: mediumBoldWeight
              ),
            )
          ),
          
          Container(
            width: MediaQuery.of(context).size.width - 74,
              margin: EdgeInsets.fromLTRB(space_3, 0, space_1, space_1),
              alignment: Alignment.centerLeft,
              child:
              (widget.truckHistory.runtimeType==GpsDataModel)?
                  Text("Distance covered: ${(widget.truckHistory.distance/1000).toStringAsFixed(2)} kms",
                  maxLines: 3,
                    style: TextStyle(
                        color: black,
                        fontSize: size_7,
                        fontStyle: FontStyle.normal,
                        fontWeight: boldWeight
                    ),
                  )
                  : Text("$address",
                  maxLines: 3,
                      style: TextStyle(
                          color: black,
                          fontSize: size_7,
                          fontStyle: FontStyle.normal,
                          fontWeight: boldWeight
                      ),
                  )

          )  ],
          ),
        ),
     
                 ],
      ),
    ),
        ],
      ),
    );
  }
  void getPosition() async {
    gpsPosition = await mapUtil.getTraccarPosition(deviceId: widget.deviceId);
    setState(() {
      newGpsPosition = gpsPosition;
    });
   // print("LAt and Long ${widget.truckHistory[4]} ${widget.truckHistory[5]}");
  }
  getAddress() async{
    print("bhai");
    print(widget.truckHistory);
    print("hehe");
    print("hehe and Long ${widget.truckHistory[4]} ${widget.truckHistory[5]}");
    placemarks = await placemarkFromCoordinates(widget.truckHistory[4], widget.truckHistory[5]);
    print("kaise stop loc is $placemarks");
    print("pppp");
    var first = placemarks.first;
    print("${first.subLocality},${first.locality},${first.administrativeArea}\n${first.postalCode},${first.country}");
    setState(() {
      if(first.subLocality=="")
        address = "${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";

      else
        address = "${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
    });

  }
  getFormattedDate(){
    setState(() {
      startTime = getISOtoIST(widget.truckHistory.startTime.toString());
      print("start time in route is ${startTime}");

    });
    setState(() {
      endTime = getISOtoIST(widget.truckHistory.endTime.toString());
      print("end date is ${endTime}");

    });
  }
}
