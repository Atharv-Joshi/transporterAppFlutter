import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:ui' as ui;
import 'mapUtils/getLoactionUsingImei.dart';

MapUtil mapUtil = MapUtil();
var startTimeParam;
var endTimeParam;
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
List<LatLng> polylineCoordinates = [];
List<LatLng> polylineCoordinates2 = [];

//Date format functions---------------------------
getFormattedDate(String start, String end){
  // var nowTime = dateFormat.format(DateTime.now()).split(" ");
  var nowTime = end.split(" ");
  var timestamp = nowTime[0].replaceAll("-", "");
  var year = timestamp.substring(0, 4);
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var date = "$day-$month-$year";
  var time = nowTime[1];
  endTimeParam = "$date $time";   //today's time and date

  // var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1))).split(" ");
  var yesterday = start.split(" ");
  var timestamp2 = yesterday[0].replaceAll("-", "");
  var year2 = timestamp2.substring(0, 4);
  var month2 = int.parse(timestamp2.substring(4, 6));
  var day2 = timestamp2.substring(6, 8);
  var date2 = "$day2-$month2-$year2";
  var time2 = yesterday[1];
  startTimeParam = "$date2 $time2";
}

getFormattedDateForDisplay(String date){
  var timestamp = date.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
  var year = timestamp.substring(4, 8);
  print("timestamp is $timestamp");
  var month = int.parse(timestamp.substring(2, 4));
  var day = timestamp.substring(0, 2);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname  = DateFormat('MMM').format(DateTime(0, month));
  var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  var truckDate = "$ampm, $day $monthname $year";
  return truckDate;
}
getFormattedDateForDisplay3(String date){
  var timestamp = date.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
  var year = timestamp.substring(0, 4);
  print("timestamp is $timestamp");
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname  = DateFormat('MMM').format(DateTime(0, month));
  var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  var truckDate = "$ampm, $day $monthname $year";
  return truckDate;
}

getFormattedDateForDisplay2(String date){
  var timestamp = date
      .replaceAll(" ", "")
      .replaceAll("-", "")
      .replaceAll(":", "");
  var year = timestamp.substring(2, 4);
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname = DateFormat('MMM').format(DateTime(0, month));
  var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  var truckDate = "$day $monthname $year, $ampm";
  return truckDate;
}

//get GPS Data Model functions -------------------
getRouteStatusList(String? imei, String start, String end) async{
  getFormattedDate(start, end);
  var gpsRoute = await mapUtil.getRouteHistory(
      imei: imei,
      starttime: startTimeParam,
      endtime: endTimeParam);
  return gpsRoute;
}

getDataHistory(String? imei, String start, String end) async{
  getFormattedDate(start, end);
  var gpsDataHistory =
  await mapUtil.getLocationHistoryByImei(
      imei: imei,
      starttime: startTimeParam,
      endtime: endTimeParam,
      choice: "deviceTrackList");
  return gpsDataHistory;

}

getStoppageHistory(String? imei, String start, String end) async{
  getFormattedDate(start, end);
  var gpsStoppageHistory =
  await mapUtil.getLocationHistoryByImei(
      imei: imei,
      starttime: startTimeParam,
      endtime: endTimeParam,
      choice: "stoppagesList");
  return gpsStoppageHistory;
}

//Return list of polyline coordinates

getPoylineCoordinates(var gpsDataHistory){
  var logger = Logger();
  logger.i("in polyline after function");
  polylineCoordinates.clear();
  int a=0;
  int b=a+1;
  int c=0;
  print("length ${gpsDataHistory.length}");
  print("End lat ${gpsDataHistory[gpsDataHistory.length-1].lat}");
  for(int i=0; i<gpsDataHistory.length; i++) {
    c=b+1;
    PointLatLng point1 =  PointLatLng(gpsDataHistory[a].lat,  gpsDataHistory[a].lng);
    PointLatLng point2 =  PointLatLng(gpsDataHistory[b].lat,  gpsDataHistory[b].lng);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
    a=b;
    b=c;
    if(b>=gpsDataHistory.length){
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if(gpsDataHistory.length%2==0){
    print("In even ");
    PointLatLng point1 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-2].lat,  gpsDataHistory[gpsDataHistory.length-2].lng);
    PointLatLng point2 =  PointLatLng(gpsDataHistory[gpsDataHistory.length-1].lat,  gpsDataHistory[gpsDataHistory.length-1].lng);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
  }
  return polylineCoordinates;
}
getPoylineCoordinates2(var gpsDataHistory2){
  var logger = Logger();
  logger.i("in polyline after function");
  int a=0;
  int b=a+1;
  int c=0;
  print("length ${gpsDataHistory2.length}");
  print("End lat ${gpsDataHistory2[gpsDataHistory2.length-1].lat}");
  for(int i=0; i<gpsDataHistory2.length; i++) {
    c=b+1;
    PointLatLng point1 =  PointLatLng(gpsDataHistory2[a].lat,  gpsDataHistory2[a].lng);
    PointLatLng point2 =  PointLatLng(gpsDataHistory2[b].lat,  gpsDataHistory2[b].lng);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
    a=b;
    b=c;
    if(b>=gpsDataHistory2.length){
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if(gpsDataHistory2.length%2==0){
    print("In even ");
    PointLatLng point1 =  PointLatLng(gpsDataHistory2[gpsDataHistory2.length-2].lat,  gpsDataHistory2[gpsDataHistory2.length-2].lng);
    PointLatLng point2 =  PointLatLng(gpsDataHistory2[gpsDataHistory2.length-1].lat,  gpsDataHistory2[gpsDataHistory2.length-1].lng);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
  }
  return polylineCoordinates2;
}


//STOPPAGE FUNCTIONS----------------------

getStoppageTime(var gpsStoppageHistory) {
  String truckStart ;
  String truckEnd ;
  var stoppageTime = [];

  for(int i=0; i<gpsStoppageHistory.length; i++) {
    print("start time is  ${gpsStoppageHistory[i].startTime}");
    var somei = gpsStoppageHistory[i].startTime;
    var timestamp = somei.toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
    var month = int.parse(timestamp.substring(2, 4));
    var day = timestamp.substring(0, 2);
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var monthname  = DateFormat('MMM').format(DateTime(0, month));
    var ampm  = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
    truckStart = "$day $monthname,$ampm";

    var somei2 = gpsStoppageHistory[i].endTime;
    var timestamp2 = somei2.toString().replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
    var month2 = int.parse(timestamp2.substring(2, 4));
    var day2 = timestamp2.substring(0, 2);
    var hour2 = int.parse(timestamp2.substring(8, 10));
    var minute2 = int.parse(timestamp2.substring(10, 12));
    var monthname2  = DateFormat('MMM').format(DateTime(0, month2));
    var ampm2 = DateFormat.jm().format(DateTime(0, 0, 0, hour2, minute2));

    if("$day2 $monthname2,$ampm2" == "$day $monthname,$ampm")
      truckEnd = "Present";
    else
      truckEnd = "$day2 $monthname2,$ampm2";

    stoppageTime.add("$truckStart - $truckEnd");
  }
  return stoppageTime;
}

getStoppageDuration(var gpsStoppageHistory){
  var duration = [];
  for(int i=0; i<gpsStoppageHistory.length; i++) {
    if(gpsStoppageHistory[i].duration=="")
      duration.add("Ongoing");
    else
      duration.add(gpsStoppageHistory[i].duration);
    }
  return duration;
  }

getStoppageAddress(var gpsStoppageHistory) async{
  var stopAddress = [];
  for(int i=0; i<gpsStoppageHistory.length; i++) {
    List<Placemark> placemarks = await placemarkFromCoordinates(gpsStoppageHistory[i].lat, gpsStoppageHistory[i].lng);
    print("stop los is $placemarks");
    var first = placemarks.first;
    print("${first.subLocality},${first.locality},${first.administrativeArea}\n${first.postalCode},${first.country}");

    if(first.subLocality=="")
      stopAddress.add("${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}");
    else
      stopAddress.add("${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}");

  }
  return stopAddress;
}

//get stop markers
Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.red;
  final Radius radius = Radius.circular(width/2);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  painter.text = TextSpan(
    text: customNum.toString(), // your custom number here
    style: TextStyle(fontSize: 50.0, color: Colors.white),
  );

  painter.layout();
  painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5,
          (height * .5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}


