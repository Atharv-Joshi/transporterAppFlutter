import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
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
    getFormattedDate();
    if(widget.truckHistory.truckStatus=="stopped")
      getAddress();
    setState(() {
      var dur = (widget.truckHistory.duration).toString();
      duration = dur.replaceAll("hours", "hrs").replaceAll("hour", "hr").replaceAll("minutes", "min").replaceAll("seconds", "sec");
    });
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
                (widget.truckHistory.truckStatus=="running")?
                Icon(Icons.circle,
                  color: flagGreen,
                  size: size_7,)
                : Icon(Icons.stop,
                  color: red,
                  size: size_10,),
                SizedBox(
                  width: space_5,
                ),
                (widget.truckHistory.truckStatus=="running")?
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
                Text("${duration}",
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
            child:  Text( "$startTime - $endTime",
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
              child: (widget.truckHistory.truckStatus=="running")?
                  Text("Distance covered: ${widget.truckHistory.distanceCovered} kms",
                    style: TextStyle(
                        color: black,
                        fontSize: size_7,
                        fontStyle: FontStyle.normal,
                        fontWeight: boldWeight
                    ),
                  )
                  : Text("$address",
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
    placemarks = await placemarkFromCoordinates(widget.truckHistory.lat, widget.truckHistory.lng);
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
    var start = widget.truckHistory.startTime;
    var timestamp = start.toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
    var month = int.parse(timestamp.substring(2, 4));
    var day = timestamp.substring(0, 2);
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var monthname  = DateFormat('MMM').format(DateTime(0, month));
    var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
    setState(() {
      startTime = "$day $monthname, $ampm";
      print("start time in route is ${startTime}");

    });
    var end = widget.truckHistory.endTime;
    var timestamp2 = end.toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
    var month2 = int.parse(timestamp2.substring(2, 4));
    var day2 = timestamp2.substring(0, 2);
    var hour2 = int.parse(timestamp2.substring(8, 10));
    var minute2 = int.parse(timestamp2.substring(10, 12));
    var monthname2  = DateFormat('MMM').format(DateTime(0, month2));
    var ampm2 = DateFormat.jm().format(DateTime(0, 0, 0, hour2, minute2));
    setState(() {
      endTime = "$day2 $monthname2, $ampm2";
      print("end date is ${endTime}");

    });
  }
}
