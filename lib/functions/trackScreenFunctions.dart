import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/language/localization_service.dart';
import 'package:logger/logger.dart';
import 'dart:ui' as ui;
import 'mapUtils/getLoactionUsingImei.dart';
import 'package:http/http.dart' as http;

MapUtil mapUtil = MapUtil();
var startTimeParam;
var endTimeParam;
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
List<LatLng> polylineCoordinates = [];
List<LatLng> polylineCoordinates2 = [];

//Date format functions---------------------------

getFormattedDateForDisplay2(String date) {
  var timestamp =
      date.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");
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

getISOtoIST(String date) {
  var istDate = new DateFormat("yyyy-MM-ddThh:mm:ss")
      .parse(date)
      .add(Duration(hours: 5, minutes: 30));
  var timestamp = istDate
      .toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
  var year = timestamp.substring(0, 4);
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname = DateFormat('MMM').format(DateTime(0, month));
  var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  var truckDate = "$day $monthname $year, $ampm";
  return truckDate;
}

getStopDuration(String from, String to) {
  DateTime start = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(from);
  DateTime end = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(to);

  var diff2 = end.difference(start);
  if (diff2.compareTo(Duration()) < 0) {
    return "0 ${"sec".tr}";
  }
  var days = diff2.inDays;
  var diff = diff2.toString();
  DateTime dur = new DateFormat("HH:mm:ss").parse(diff);
  var timestamp = dur
      .toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var second = int.parse(timestamp.substring(12, 14));
  var duration;
  if (days == 0) {
    if (hour == 0 && second == 0)
      duration = "$minute ${"min".tr}";
    else if (minute == 0)
      duration = "$hour ${"hr".tr} $second ${"sec".tr}";
    else if (second == 0)
      duration = "$hour ${"hr".tr} $minute min";
    else if (hour == 0)
      duration = "$minute  ${"min".tr} $second  ${"sec".tr}";
    else
      duration = "$hour ${"hr".tr} $minute  ${"min".tr} $second  ${"sec".tr}";
  } else {
    if (hour == 0 && second == 0)
      duration = "$days ${"day".tr} $minute  ${"min".tr}";
    else if (minute == 0)
      duration = "$days ${"day".tr} $hour ${"hr".tr} $second  ${"sec".tr}";
    else if (second == 0)
      duration = "$days ${"day".tr} $hour ${"hr".tr} $minute  ${"min".tr}";
    else if (hour == 0)
      duration = "$days ${"day".tr} $minute  ${"min".tr} $second  ${"sec".tr}";
    else
      duration =
          "$days ${"day".tr} $hour ${"hr".tr} $minute  ${"min".tr} $second  ${"sec".tr}";
  }
  return duration;
}

getStopDuration2(String from, String to) {
  DateTime start = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(from);
  DateTime end = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(to);
  String lastUpdate = new DateFormat('dd MMM yy,').add_jm().format(start);
  return lastUpdate;
}

//get GPS Data Model functions -------------------
getRouteStatusList(int? deviceId, String from, String to) async {
  var gpsRoute = await mapUtil.getTraccarTrips(
    deviceId: deviceId,
    from: from,
    to: to,
  );
  return gpsRoute;
}

getDataHistory(int? deviceId, String from, String to) async {
  // getFormattedDate(start, end);
  var gpsDataHistory = await mapUtil.getTraccarHistory(
    deviceId: deviceId,
    from: from,
    to: to,
  );
  return gpsDataHistory;
}

getStoppageHistory(int? deviceId, String from, String to) async {
  // getFormattedDate(start, end);
  var gpsStoppageHistory =
      await mapUtil.getTraccarStoppages(deviceId: deviceId, from: from, to: to);
  return gpsStoppageHistory;
}

//Return list of polyline coordinates

getPoylineCoordinates(var gpsDataHistory, List<LatLng> polylineCoordinates) {
  var logger = Logger();
  // logger.i("in polyline after function");
  polylineCoordinates.clear();
  int a = 0;
  int b = a + 3;
  int c = 0;
  for (int i = 0; i < gpsDataHistory.length; i++) {
    c = b + 3;
    LatLng point1 =
        LatLng(gpsDataHistory[a].latitude, gpsDataHistory[a].longitude);
    LatLng point2 =
        LatLng(gpsDataHistory[b].latitude, gpsDataHistory[b].longitude);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
    a = b;
    b = c;
    if (b >= gpsDataHistory.length) {
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if (gpsDataHistory.length % 2 == 0) {
    LatLng point1 = LatLng(gpsDataHistory[gpsDataHistory.length - 2].latitude,
        gpsDataHistory[gpsDataHistory.length - 2].longitude);
    LatLng point2 = LatLng(gpsDataHistory[gpsDataHistory.length - 1].latitude,
        gpsDataHistory[gpsDataHistory.length - 1].longitude);
    polylineCoordinates.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates.add(LatLng(point2.latitude, point2.longitude));
  }
  return polylineCoordinates;
}

getPoylineCoordinates2(var gpsDataHistory2) {
  var logger = Logger();
  // logger.i("in polyline 2 function");
  polylineCoordinates2.clear();
  int a = 0;
  int b = a + 1;
  int c = 0;
  for (int i = 0; i < gpsDataHistory2.length; i++) {
    c = b + 1;
    LatLng point1 = LatLng(gpsDataHistory2[a].latitude,
        gpsDataHistory2[a].longitude); // in place of LatLng it was PointLatLng
    LatLng point2 =
        LatLng(gpsDataHistory2[b].latitude, gpsDataHistory2[b].longitude);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
    a = b;
    b = c;
    if (b >= gpsDataHistory2.length) {
      break;
    }
  } // get polyline between every two lat long obtained from response body

  if (gpsDataHistory2.length % 2 == 0) {
    LatLng point1 = LatLng(gpsDataHistory2[gpsDataHistory2.length - 2].latitude,
        gpsDataHistory2[gpsDataHistory2.length - 2].longitude);
    LatLng point2 = LatLng(gpsDataHistory2[gpsDataHistory2.length - 1].latitude,
        gpsDataHistory2[gpsDataHistory2.length - 1].longitude);
    polylineCoordinates2.add(LatLng(point1.latitude, point1.longitude));
    polylineCoordinates2.add(LatLng(point2.latitude, point2.longitude));
  }
  return polylineCoordinates2;
}

//STOPPAGE FUNCTIONS----------------------

getStoppageTime(var gpsStoppageHistory) {
  String truckStart;
  String truckEnd;
  var stoppageTime;
  var istDate = new DateFormat("yyyy-MM-ddTHH:mm:ss")
      .parse(gpsStoppageHistory.startTime)
      .add(Duration(hours: 5, minutes: 30));
  var timestamp = istDate
      .toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
  var month = int.parse(timestamp.substring(4, 6));
  var day = timestamp.substring(6, 8);
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var monthname = DateFormat('MMM').format(DateTime(0, month));
  var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));
  truckStart = "$day $monthname,$ampm";

  var istDate2 = new DateFormat("yyyy-MM-ddTHH:mm:ss")
      .parse(gpsStoppageHistory.endTime)
      .add(Duration(hours: 5, minutes: 30));
  var timestamp2 = istDate2
      .toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "")
      .replaceAll(".", "");
  var month2 = int.parse(timestamp2.substring(4, 6));
  var day2 = timestamp2.substring(6, 8);
  var hour2 = int.parse(timestamp2.substring(8, 10));
  var minute2 = int.parse(timestamp2.substring(10, 12));
  var monthname2 = DateFormat('MMM').format(DateTime(0, month2));
  var ampm2 = DateFormat.jm().format(DateTime(0, 0, 0, hour2, minute2));
  if ("$day2 $monthname2,$ampm2" == "$day $monthname,$ampm")
    truckEnd = "Present";
  else
    truckEnd = "$day2 $monthname2,$ampm2";

  stoppageTime = "$truckStart - $truckEnd";
  // }
  return stoppageTime;
}

getStoppageDuration(var gpsStoppageHistory) {
  var duration;
  // for(int i=0; i<gpsStoppageHistory.length; i++) {

  if (gpsStoppageHistory.duration == 0) {
    duration = "Ongoing";
  } else {
    var time = Duration(
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: gpsStoppageHistory.duration)
        .toString();
    var time2 = new DateFormat("hh:mm:ss").parse(time).toString();
    var dur = time2.substring(0, time2.indexOf('.'));

    var timestamp = dur
        .toString()
        .replaceAll("-", "")
        .replaceAll(":", "")
        .replaceAll(" ", "");
    var hour = int.parse(timestamp.substring(8, 10));
    var minute = int.parse(timestamp.substring(10, 12));
    var second = int.parse(timestamp.substring(12, 14));

    if (hour == 0 && second == 0)
      duration = "$minute min";
    else if (minute == 0)
      duration = "$second sec";
    else if (second == 0)
      duration = "$hour hr $minute min";
    else if (hour == 0)
      duration = "$minute min $second sec";
    else
      duration = "$hour hrs $minute min $second sec";
    // }
  }
  return duration;
}

//for getting the address of stoppages on the basis of gpsStoppgaeHistory
getStoppageAddress(var gpsStoppageHistory) async {
  var stopAddress = "";
  if (kIsWeb) {
    final apiKey = dotenv.get('mapKey');

    var latn = gpsStoppageHistory.latitude;
    var lngn = gpsStoppageHistory.longitude;

    http.Response addressResponse = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latn,$lngn&key=$apiKey"));
    var addressJSONData = await jsonDecode(addressResponse.body);
    if (addressResponse.statusCode == 200) {
      if (addressJSONData['results'].isNotEmpty) {
        String address = addressJSONData['results'][0]['formatted_address'];
        stopAddress = address;
      }
    }
  } else {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        gpsStoppageHistory.latitude, gpsStoppageHistory.longitude);
    var first = placemarks.first;
    if (first.subLocality == "")
      stopAddress =
          "${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
    else
      stopAddress =
          "${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
  }
  // }
  return stopAddress;
}

//for getting address of stoppages from lat long
getStoppageAddressLatLong(var lat, var long) async {
  var stopAddress = "NA";
  // for(int i=0; i<gpsStoppageHistory.length; i++) {
  if (kIsWeb) {
    final apiKey = dotenv.get('mapKey');

    var latn = lat;
    var lngn = long;
    http.Response addressResponse = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latn,$lngn&key=$apiKey"));
    var addressJSONData = await jsonDecode(addressResponse.body);
    if (addressResponse.statusCode == 200) {
      if (addressJSONData['results'].isNotEmpty) {
        String address = addressJSONData['results'][0]['formatted_address'];
        stopAddress = address;
      }
    }
  } else {
    current_lang = LocalizationService().getCurrentLang();
    List<Placemark> placemarks;
    if (current_lang == 'Hindi') {
      placemarks =
          await placemarkFromCoordinates(lat, long, localeIdentifier: "hi_IN");
    } else {
      placemarks =
          await placemarkFromCoordinates(lat, long, localeIdentifier: "en_US");
    }
    var first = placemarks.first;
    if (first.subLocality == "")
      stopAddress =
          "${first.street}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
    else
      stopAddress =
          "${first.street}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";

    // }
  }
  return stopAddress;
}

getStopList(
    var newGPSRoute, var gpsStoppageHistory, var istDate1, var istDate2) {
  int i = 0;
  var start;
  var end;
  var duration;
  int length = newGPSRoute.length;
  if (length > 0) {
    bool last = false;
    var lastStop = newGPSRoute[newGPSRoute.length - 1].endTime;
    // DateTime now = DateTime.now().subtract(Duration(days: 0, hours: 5, minutes: 30));
    //  DateTime yesterday = DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
    DateTime nowDateFormat =
        new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(istDate2.toIso8601String());
    DateTime lastStopDateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(newGPSRoute[newGPSRoute.length - 1].endTime);
    if (lastStopDateFormat.compareTo(nowDateFormat) <=
        0) //Check if end time of last trip is less than current time, if yes, then add stop at end
    {
      last = true;
    }

    int length = newGPSRoute.length;
    int j = 0;
    while (i < newGPSRoute.length) {
      if (i == 0) {
        DateTime st = new DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(istDate1.toIso8601String());
        DateTime en = new DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(newGPSRoute[i].startTime);

        var diff = en.difference(st).inMinutes;
        if (diff <= 0) {
          i++;
          start = getISOtoIST(newGPSRoute[i - 1].endTime);
          end = getISOtoIST(newGPSRoute[i].startTime);
          duration = getStopDuration(
              newGPSRoute[i - 1].endTime, newGPSRoute[i].startTime);
        } else {
          start = getISOtoIST(istDate1.toIso8601String());

          end = getISOtoIST(newGPSRoute[i].startTime);

          duration = getStopDuration(
              istDate1.toIso8601String(), newGPSRoute[i].startTime);
        }
        newGPSRoute.insert(i, [
          "stopped",
          start,
          end,
          duration,
          newGPSRoute[i].latitude,
          newGPSRoute[i].longitude
        ]);
      } else {
        start = getISOtoIST(newGPSRoute[i - 1].endTime);
        end = getISOtoIST(newGPSRoute[i].startTime);
        duration = getStopDuration(
            newGPSRoute[i - 1].endTime, newGPSRoute[i].startTime);
        newGPSRoute.insert(i, [
          "stopped",
          start,
          end,
          duration,
          gpsStoppageHistory[j].latitude,
          gpsStoppageHistory[j].longitude
        ]);
      }
      i = i + 2;
      j = j + 1;
    }

    if (last) //to add stop at end
    {
      start = getISOtoIST(lastStop);
      end = getISOtoIST(istDate2.toIso8601String());
      duration = getStopDuration(lastStop, istDate2.toIso8601String());
      newGPSRoute.add([
        "stopped",
        start,
        end,
        duration,
        newGPSRoute.last.endLat,
        newGPSRoute.last.endLon
      ]);
    }
  }
  return newGPSRoute;
}

//STOP MARKER -------------
Future<Uint8List> getBytesFromCanvas(
    int customNum, int width, int height) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.red;
  final Radius radius = Radius.circular(width / 2);
  // canvas.drawRect(Offset(0, -100) & const Size(500, 500), paint);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
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
} //Info Window for mapscreen

Future<Uint8List> getBytesFromCanvas3(
    String truckNo, int width, int height) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Color(0xff152968);
  final Radius radius = Radius.circular(10);
  canvas.drawRect(Offset(300, 200) & const Size(175, 50), paint);

  TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);

  TextPainter painter2 = TextPainter(textDirection: ui.TextDirection.ltr);
  painter2.text = TextSpan(
    text: truckNo, // your custom number here
    style: TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
  );
  painter2.layout();
  painter2.paint(canvas, Offset(320, 215));
  final img = await pictureRecorder.endRecording().toImage(500, 250);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

//INFO WINDOW FOR PLAY ROUTE HISTORY ---------------------------
Future<Uint8List> getBytesFromCanvas2(
    String time, String speed, int width, int height) async {
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
  painter.paint(canvas, Offset(150, 30));
  TextPainter painter2 = TextPainter(textDirection: ui.TextDirection.ltr);
  painter2.text = TextSpan(
    text: speed, // your custom number here
    style: TextStyle(fontSize: 34.0, color: Colors.white),
  );
  painter2.layout();
  painter2.paint(canvas, Offset(215, 65));
  final img = await pictureRecorder.endRecording().toImage(530, 250);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

//Display data on TRACK SCREEN -----------
getTotalRunningTime(var routeHistory, DateTime start, DateTime end) {
  var totalRunning;
  var duration = 0;
  for (var instance in routeHistory) {
    duration += (instance.duration) as int;
  }
  var totaldur = end.difference(start);
  int dur = totaldur.inMilliseconds;
  int time = dur - duration;
  totalRunning = convertMillisecondsToDuration(time);
  return totalRunning;
}

getTotalStoppageTime(var routeHistory) {
  var totalStopped;
  var duration = 0;
  for (var instance in routeHistory) {
    duration += (instance.duration) as int;
  }
  totalStopped = convertMillisecondsToDuration(duration);
  return totalStopped;
}

getTotalDistance(var tripHistory) {
  var total = 0.0;
  var totalDist = 0.0;
  for (var instance in tripHistory) {
    total += (instance.distance) as double;
  }
  totalDist = total / 1000;
  return (totalDist.toStringAsFixed(2));
}

getStatus(var gpsData, var gpsStoppageHistory) {
  String status;
  if (gpsData.last.motion == false) {
    var timestamp1 = gpsStoppageHistory.last.startTime.toString();

    DateTime truckTime = new DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(timestamp1)
        .add(Duration(hours: 5, minutes: 30));

    var now = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());
    DateTime nowTime = DateTime.parse(now);
    Duration constraint = Duration(hours: 0, minutes: 0, seconds: 15);

    var diff = nowTime.difference(truckTime).toString();
    var diff2 = nowTime.difference(truckTime);
    double speed = gpsData.last.speed;
    var v = diff.toString().split(":");
    if (speed <= 2 && diff2.compareTo(constraint) > 0) {
      if (v[0] == "0")
        status = "Stopped since ${v[1]} min ";
      else if ((v[1] == "00") && (v[0] == "0"))
        status = "Stopped since ${(double.parse(v[2])).toStringAsFixed(1)} sec";
      else
        status = "Stopped since ${v[0]} hrs : ${v[1]} min";
    } else {
      status = "Running : ${(gpsData.last.speed).toStringAsFixed(2)} km/h";
    }
  } else
    status = "Running : ${(gpsData.last.speed).toStringAsFixed(2)} km/h";
  return status;
}

//MILLISECONDS TO HRS MIN SEC---------------
convertMillisecondsToDuration(int time) {
  var formatted;
  var time2Dateformat = new Duration(
      days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: time);
  var days = time2Dateformat.inDays;
  String time2 = time2Dateformat.toString();
  var time3 = new DateFormat("HH:mm:ss").parse(time2).toString();
  var dur = time3.substring(0, time3.indexOf('.'));
  var timestamp = dur
      .toString()
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll(" ", "");
  var hour = int.parse(timestamp.substring(8, 10));
  var minute = int.parse(timestamp.substring(10, 12));
  var second = int.parse(timestamp.substring(12, 14));
  if (days == 0) {
    if (hour == 0 && second == 0)
      formatted = "$minute min";
    else if (minute == 0)
      formatted = "$second sec";
    else if (second == 0)
      formatted = "$hour hr $minute min";
    else if (hour == 0)
      formatted = "$minute min $second sec";
    else
      formatted = "$hour hrs $minute min $second sec";
  } else {
    if (hour == 0 && second == 0)
      formatted = "$days day $minute min";
    else if (minute == 0)
      formatted = "$days day $second sec";
    else if (second == 0)
      formatted = "$days day $hour hr $minute min";
    else if (hour == 0)
      formatted = "$days day $minute min $second sec";
    else
      formatted = "$days day $hour hrs $minute min $second sec";
  }
  return formatted;
}

//this method for calculate the total active or stop time of a device
getLastUpdate(var lastUpdate, var now, bool active) {
  if (lastUpdate.length != 0) {
    var s = lastUpdate[lastUpdate.length - 1]!.startTime.toString();
    var e = lastUpdate[lastUpdate.length - 1]!.endTime.toString();

    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm');
    DateTime Start = dateFormat.parse(s);
    DateTime End = dateFormat.parse(e);
    now = dateFormat.parse(now);
    var minutesForStartTime = Start.minute;
    var hourForStartTime = Start.hour;
    // var totalMinutesForStartTime = minutesForStartTime + (hourForStartTime * 60);
    var minutesForEndTime = End.minute;
    var hourForEndTime = End.hour;
    var totalMinutesForEndTime = minutesForEndTime + (hourForEndTime * 60);
    var minutesForNowTime = now.minute;
    var hourForNowTime = now.hour;
    var totalMinutesForNowTime = minutesForNowTime + (hourForNowTime * 60);

    int diffMinutes = totalMinutesForNowTime - totalMinutesForEndTime;
    var totalTimeForStop = totalMinutesForNowTime - totalMinutesForEndTime;
    int totalTime;
    if (active != true) {
      return "Offline";
    } else {
      if (diffMinutes < 2) {
        int totalTime = totalTimeForStop;
        int hour = totalTime ~/ 60;
        int minute = (totalTime % 60);
        return "Stop Since $hour hrs $minute min".toString();
      } else {
        totalTime = diffMinutes;
        int hour = totalTime ~/ 60;
        int minute = (totalTime % 60);
        return "Running since $hour hrs $minute min".toString();
      }
    }
  } else {
    return "Offline";
  }
}
