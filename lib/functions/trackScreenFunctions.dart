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
  var now = dateFormat.format(DateTime.now()).split(" ");
  print("NOW ${now[1]}");
  var nowTime = end.split(" ");
  var timestamp = nowTime[0].replaceAll("-", "");
  var year = timestamp.substring(0, 4);
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var date = "$day-$month-$year";
  var time;
  if(nowTime[1] == "00:00:00.000")
    time = now[1];
  else
    time = nowTime[1];

  endTimeParam = "$date $time";   //today's time and date
  print("end time param $date $time");   //today's time and date

  // var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1))).split(" ");
  var yesterday = start.split(" ");
  var timestamp2 = yesterday[0].replaceAll("-", "");
  var year2 = timestamp2.substring(0, 4);
  var month2 = int.parse(timestamp2.substring(4, 6));
  var day2 = timestamp2.substring(6, 8);
  var date2 = "$day2-$month2-$year2";
  // var time2 = yesterday[1];
  var time2;
  if(nowTime[1] == "00:00:00.000")
    time2 = now[1];
  else
    time2 = yesterday[1];
  startTimeParam = "$date2 $time2";
  print("start time param $date2 $time2");   //today's time and date

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
      endtime: endTimeParam
  );
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
  logger.i("in polyline 2 function");
  polylineCoordinates2.clear();
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
  print("Stop time $stoppageTime");
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
  // canvas.drawRect(Offset(0, -100) & const Size(500, 500), paint);
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
Future<Uint8List> getBytesFromCanvas2(String time, String speed, int width, int height) async{
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.black.withAlpha(100);
  final Radius radius = Radius.circular(10);
  canvas.drawRect(Offset(100, -100) & const Size(500, 250), paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  painter.text = TextSpan(
    text: time, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(
      canvas,
      Offset(190,
          30));
  TextPainter painter2 = TextPainter(textDirection: ui.TextDirection.ltr);
  painter2.text = TextSpan(
    text: speed, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter2.layout();
  painter2.paint(
      canvas,
      Offset(190,
          65));
  final img = await pictureRecorder.endRecording().toImage(500, 250);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

getTotalRunningTime(var routeHistory){
  var totalRunning;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  print("route history length ${routeHistory.length}");
  for(var instance in routeHistory) {
    if (instance.truckStatus == "running") {
      print("Stat ${instance.truckStatus}");
      print("Duration ${instance.duration}");

      var sep = (instance.duration).toString().replaceAll("hours", "").replaceAll("hour", "").replaceAll("minutes", "").replaceAll("seconds", "");
      var time = sep.split(" ");

      if(time.length == 4)
        {
          hours+=int.parse(time[0]);
          minutes+=int.parse(time[1]);
          seconds+=int.parse(time[2]);
        }
      else if(time.length == 3)
      {
        minutes+=int.parse(time[0]);
        seconds+=int.parse(time[1]);
      }
      else if(time.length == 2)
      {
        seconds+=int.parse(time[0]);
      }
    }
  }
  minutes += seconds ~/ 60;
  seconds = seconds % 60;

  hours += minutes ~/ 60;
  minutes = minutes % 60;

  print("DURATION $hours h $minutes m $seconds s");
  totalRunning = "$hours hrs $minutes min $seconds sec";
  return totalRunning;
}
getTotalStoppageTime(var routeHistory){
  var totalStopped;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  print("route history length ${routeHistory.length}");
  for(var instance in routeHistory) {
    if (instance.truckStatus == "stopped") {
      print("Stat ${instance.truckStatus}");
      print("Duration ${instance.duration}");

      var sep = (instance.duration).toString().replaceAll("hours", "").replaceAll("hour", "").replaceAll("minutes", "").replaceAll("seconds", "");
      var time = sep.split(" ");

      if(time.length == 4)
      {
        hours+=int.parse(time[0]);
        minutes+=int.parse(time[1]);
        seconds+=int.parse(time[2]);
      }
      else if(time.length == 3)
      {
        minutes+=int.parse(time[0]);
        seconds+=int.parse(time[1]);
      }
      else if(time.length == 2)
      {
        seconds+=int.parse(time[0]);
      }
    }
  }
  minutes += seconds ~/ 60;
  seconds = seconds % 60;

  hours += minutes ~/ 60;
  minutes = minutes % 60;

  print("DURATION $hours h $minutes m $seconds s");
  totalStopped = "$hours hrs $minutes min $seconds sec";
  return totalStopped;
}


