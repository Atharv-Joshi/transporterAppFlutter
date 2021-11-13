import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/models/gpsDataModelForHistory.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

class MapUtil {
  String gpsApiUrl = FlutterConfig.get("gpsApiUrl");
  String routeHistoryApiUrl = FlutterConfig.get("routeHistoryApiUrl");

  getLocationByImei({String? imei}) async {
    print("getLocationByImei got called with imei : $imei");
    try {
      print("$gpsApiUrl/$imei");
      http.Response response = await http.get(Uri.parse("$gpsApiUrl/$imei"));
      print(response.statusCode);
      print(response.body);
      var jsonData = await jsonDecode(response.body);
      print(response.body);
      var LatLongList = [];
      if (response.statusCode == 200) {
        for (var json in jsonData) {
          GpsDataModel gpsDataModel = new GpsDataModel();
          gpsDataModel.id = json["id"] != null ? json["id"] : 'NA';
          gpsDataModel.imei = json["imei"] != null ? json["imei"] : 'NA';
          gpsDataModel.lat = double.parse(json["lat"] != null ? json["lat"] : 0);
          gpsDataModel.lng = double.parse(json["lng"] != null ? json["lng"] : 0);
          gpsDataModel.speed = json["speed"] != null ? json["speed"] : 'NA';
          gpsDataModel.deviceName = json["deviceName"] != null ? json["deviceName"] : 'NA';
          print("Device Name is ${gpsDataModel.deviceName}");
          gpsDataModel.powerValue = json["powerValue"] != null ? json["powerValue"] : 'NA';
          gpsDataModel.direction = json["direction"] != null ? json["direction"] : 'NA';
          gpsDataModel.timestamp = json["timeStamp"] != null ? json["timeStamp"] : 'NA';
          gpsDataModel.gpsTime = json["gpsTime"] != null ? json["gpsTime"] : 'NA';

          var latn = gpsDataModel.lat = double.parse(json["lat"] != null ? json["lat"] : 0);
          var lngn = gpsDataModel.lng = double.parse(json["lng"] != null ? json["lng"] : 0);
          List<Placemark> newPlace = await placemarkFromCoordinates(latn, lngn);
          var first = newPlace.first;
          String? addressstring;
          if(first.subLocality == "")
            addressstring = "${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
          else
            addressstring = "${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}";
          print(addressstring);
          gpsDataModel.address = addressstring;
          LatLongList.add(gpsDataModel);
        }
        return LatLongList;
      }
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  getLocationHistoryByImei({String? imei, String? starttime, String? endtime, String? choice}) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "$gpsApiUrl?imei=$imei&startTime=$starttime&endTime=$endtime"
      ));
      print("Response Body is ${response.body}");
      print("Response status code is ${response.statusCode}");
      Map<String, dynamic> jsonData = await jsonDecode(response.body);
      var LatLongList = [];
      var deviceTrackList = jsonData["deviceTrackList"];
      var stoppageList = jsonData["stoppagesList"];

      if (response.statusCode == 200) {
        if(choice=="deviceTrackList"){
          for (var json in deviceTrackList) {
            GpsDataModelForHistory gpsDataModel = new GpsDataModelForHistory();
            gpsDataModel.gpsSpeed =
                json["gpsSpeed"] != null ? json["gpsSpeed"] : 'NA';
            // print("ID is ${gpsDataModel.id}");
            gpsDataModel.satellite =
                json["satellite"] != null ? json["satellite"] : 'NA';
            gpsDataModel.lat = json["lat"];
            gpsDataModel.lng = json["lng"];
            gpsDataModel.gpsTime =
                json["gpsTime"] != null ? json["gpsTime"] : 'NA';
            gpsDataModel.direction =
                json["direction"] != null ? json["direction"] : 'NA';
            gpsDataModel.posType =
                json["posType"] != null ? json["posType"] : 'NA';

            LatLongList.add(gpsDataModel);
          }
        }
        else if(choice=="stoppagesList"){
          for (var json in stoppageList) {
            GpsDataModelForHistory gpsDataModel = new GpsDataModelForHistory();
            gpsDataModel.duration = json["duration"] != null ? json["duration"] : 'NA';
            gpsDataModel.lat = json["lat"];
            gpsDataModel.lng = json["lng"];
            gpsDataModel.startTime = json["startTime"] != null ? json["startTime"] : 'NA';
            gpsDataModel.endTime = json["endTime"] != null ? json["endTime"] : 'NA';

            LatLongList.add(gpsDataModel);
          }
        }
        return LatLongList;
      }
      else {
        return null;
      }
    } catch (e) {
      print("ERROR IS : $e");
      return null;
    }
  }
  getRouteHistory({String? imei, String? starttime, String? endtime, String? choice}) async {
    try{
      http.Response response = await http.get(Uri.parse(
          "$routeHistoryApiUrl?imei=$imei&startTime=$starttime&endTime=$endtime"
      ));

      print("Response Body for history is ${response.body}");
      print("Response status code is ${response.statusCode}");
      Map<String, dynamic> jsonData = await jsonDecode(response.body);
      var routeHistoryList = jsonData["routeHistoryList"];
      var routeHistory = [];
      double totalDistanceCovered = jsonData["totalDistanceCovered"];
      print("TOTAL $totalDistanceCovered");
      // routeHistory.add(totalDistanceCovered);
      if (response.statusCode == 200) {
        if(choice=="totalDistanceCovered")
          routeHistory.add(totalDistanceCovered);
        else {
          for (var json in routeHistoryList) {
            GpsDataModelForHistory gpsDataModel = new GpsDataModelForHistory();
            gpsDataModel.truckStatus =
                json["truckStatus"] != null ? json["truckStatus"] : 'NA';
            gpsDataModel.startTime =
                json["startTime"] != null ? json["startTime"] : 'NA';
            gpsDataModel.endTime =
                json["endTime"] != null ? json["endTime"] : 'NA';
            gpsDataModel.lat = json["lat"];
            gpsDataModel.lng = json["lng"];
            gpsDataModel.duration =
                json["duration"] != null ? json["duration"] : 'NA';
            gpsDataModel.distanceCovered = json["distanceCovered"];

            routeHistory.add(gpsDataModel);
          }
        }
        print("ROUTE $routeHistory");
        return routeHistory;
      }
      else {
        return null;
      }
      }catch(e){
      print("ERROR IS : $e");
      return null;
    }
  }
}