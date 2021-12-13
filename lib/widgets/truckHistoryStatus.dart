import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/gpsDataModel.dart';
class TruckStatus extends StatefulWidget {
  var truckHistory;

  TruckStatus(
      {
        required this.truckHistory,
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

  @override
  void initState() {
    print("Here ${widget.truckHistory.runtimeType}");
    if(widget.truckHistory.runtimeType==GpsDataModel) {
      getFormattedDate();
      duration = convertMillisecondsToDuration(widget.truckHistory.duration);
      getAddress();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          color: white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(space_5, space_5, space_1, space_4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (widget.truckHistory.runtimeType==GpsDataModel)?
                Icon(Icons.circle,
                  color: flagGreen,
                  size: size_7,)
                : Icon(Icons.stop,
                  color: red,
                  size: size_10,),
                SizedBox(
                  width: space_5,
                ),
                (widget.truckHistory.runtimeType==GpsDataModel)?
                Text("Travelled for   ",
                  style: TextStyle(
                      color: flagGreen,
                      fontSize: size_7,
                      fontStyle: FontStyle.normal,
                      fontWeight: boldWeight
                  ),
                )
                : Text("Stopped for  ",
                  style: TextStyle(
                      color: red,
                      fontSize: size_7,
                      fontStyle: FontStyle.normal,
                      fontWeight: boldWeight
                  ),
                ),
                (widget.truckHistory.runtimeType==GpsDataModel)?
                Text("${duration}",
                  style: TextStyle(
                      color: grey,
                      fontSize: size_7,
                      fontStyle: FontStyle.normal,
                      fontWeight: boldWeight
                  ),
                )
                :Text("${widget.truckHistory[3]}",
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
          Container(
              margin: EdgeInsets.fromLTRB(space_13, 0, 0, space_3),
              alignment: Alignment.centerLeft,
            child:  (widget.truckHistory.runtimeType!=GpsDataModel)?
            Text( "${widget.truckHistory[1]} - ${widget.truckHistory[2]}",
              style: TextStyle(
                  color: grey,
                  fontSize: size_7,
                  fontStyle: FontStyle.normal,
                  fontWeight: mediumBoldWeight
              ),
            )
                :  Text( "$startTime - $endTime",
              style: TextStyle(
                  color: grey,
                  fontSize: size_7,
                  fontStyle: FontStyle.normal,
                  fontWeight: mediumBoldWeight
              ),
            )
          ),
          Container(
              margin: EdgeInsets.fromLTRB(space_13, 0, space_3, space_3),
              alignment: Alignment.centerLeft,
              child:
              (widget.truckHistory.runtimeType==GpsDataModel)?
                  Text("Distance covered: ${(widget.truckHistory.distance/1000).toStringAsFixed(2)} kms",
                    style: TextStyle(
                        color: black,
                        fontSize: size_7,
                        fontStyle: FontStyle.normal,
                        fontWeight: boldWeight
                    ),
                  )
                  : Text("",
                      style: TextStyle(
                          color: black,
                          fontSize: size_7,
                          fontStyle: FontStyle.normal,
                          fontWeight: boldWeight
                      ),
                  )

          )
        ],
      ),
    );
  }

  getAddress() async{
    print("LAt and Long ${widget.truckHistory.latitude} ${widget.truckHistory.longitude}");
    placemarks = await placemarkFromCoordinates(widget.truckHistory.latitude, widget.truckHistory.longitude);
    print("stop loc is $placemarks");
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
