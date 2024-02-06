import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/playRouteHistoryScreen.dart';
import 'alertDialog/invalidDateConditionDialog.dart';

//displaying the route details
class PlayRouteDetailsWidget extends StatefulWidget {
  String? dateRange;
  String? truckNo;
  String? address;
  int? totalStop;
  var gpsData;
  var finalDistance;

  // String? toDate;

  PlayRouteDetailsWidget({
    required this.finalDistance,
    required this.address,
    required this.totalStop,
    required this.dateRange,
    required this.truckNo,
    required this.gpsData,
    // required this.polylineCoordinates,
  });

  @override
  _PlayRouteDetailsWidgetState createState() => _PlayRouteDetailsWidgetState();
}

class _PlayRouteDetailsWidgetState extends State<PlayRouteDetailsWidget> {
  DateTimeRange selectedDate = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now());
  var selectedDateString = [];
  var gpsStoppageHistory = [];
  var gpsTruckHistory = [];
  var routeHistory = [];
  var totalDistance;
  var start;
  var end;
  var totalRunningTime;
  var totalStoppedTime;
  String? dateRange;
  List<String> _locations = [
    'Custom',
    '48 hours',
    '7 days',
    '14 days',
    '30 days'
  ];
  String _selectedLocation = 'Custom';

  @override
  void initState() {
    super.initState();
    dateRange = widget.dateRange;
    getDateRange();
  }

  getDateRange() {
    var splitted = dateRange!.split(" - ");
    var start1 = getFormattedDateForDisplay2(splitted[0]).split(", ");
    var end1 = getFormattedDateForDisplay2(splitted[1]).split(", ");
    var start2 = start1[0].split(" ");
    var end2 = end1[0].split(" ");
    start = start1[0];
    end = end1[0];
  }

  //Displays CALENDAR to PICK DATE RANGE -------------------
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
          start: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day - 1,
          ),
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0)),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 5,
      ),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: darkBlueColor,
              scaffoldBackgroundColor: white,
              unselectedWidgetColor: grey,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: darkBlueColor,
                  onSecondary: darkBlueColor,
                  onSurface: Colors.black,
                  onBackground: white),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.fromLTRB(space_6, space_15, space_6, space_20),
                child: child!,
              ),
            ));
      },
    );
    //If picked is not null, run all APIs with newly Selected Dates
    if (picked != null) {
      var istDate1;
      var istDate2;
      setState(() {
        // bookingDateList[3] = (nextDay.MMMEd);
        selectedDate = picked;
        selectedDateString = selectedDate.toString().split(" - ");
        istDate1 = new DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(selectedDateString[0])
            .subtract(const Duration(hours: 5, minutes: 30));
        istDate2 = new DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(selectedDateString[1])
            .subtract(const Duration(hours: 5, minutes: 30));
      });
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.ring
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..maskColor = darkBlueColor
        ..userInteractions = false
        ..backgroundColor = darkBlueColor
        ..dismissOnTap = false;
      EasyLoading.show(
        status: "Loading...",
      );
      var f = getDataHistory(widget.gpsData.last.deviceId,
          istDate1.toIso8601String(), istDate2.toIso8601String());
      var s = getStoppageHistory(widget.gpsData.last.deviceId,
          istDate1.toIso8601String(), istDate2.toIso8601String());
      var t = getRouteStatusList(widget.gpsData.last.deviceId,
          istDate1.toIso8601String(), istDate2.toIso8601String());

      var newGpsTruckHistory = await f;
      var newGpsStoppageHistory = await s;
      var newRouteHistory = await t;
      if (newRouteHistory != null) {
        setState(() {
          gpsTruckHistory = newGpsTruckHistory;
          gpsStoppageHistory = newGpsStoppageHistory;
          totalDistance = newRouteHistory.removeAt(0);
          routeHistory = newRouteHistory;
          dateRange = selectedDate.toString();
        });
        totalRunningTime =
            getTotalRunningTime(gpsStoppageHistory, istDate1, istDate2);
        totalStoppedTime = getTotalStoppageTime(gpsStoppageHistory);

        int i = 0;
        var start;
        var end;
        var duration;
        while (i < routeHistory.length) {
          if (i == 0) {
            DateTime yesterday = istDate1;
            start = getISOtoIST(istDate1.toIso8601String());
            end = getISOtoIST(routeHistory[i].startTime);
            duration = getStopDuration(
                yesterday.toIso8601String(), routeHistory[i].startTime);
            routeHistory.insert(i, ["stopped", start, end, duration]);
          } else {
            start = getISOtoIST(routeHistory[i - 1].endTime);
            end = getISOtoIST(routeHistory[i].startTime);
            duration = getStopDuration(
                routeHistory[i - 1].endTime, routeHistory[i].startTime);
            routeHistory.insert(i, ["stopped", start, end, duration]);
          }
          i = i + 2;
        }

        Get.back();
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        showDialog(
            context: context, builder: (context) => InvalidDateCondition());
      }
    }
  }

//CUSTOM SELECTION allows user to select date range like 2 days, 4 days...
  customSelection(String? choice) async {
    String startTime =
        DateTime.now().subtract(const Duration(days: 1)).toString();
    String endTime = DateTime.now().toString();
    switch (choice) {
      case '48 hours':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 2)).toString();
        });
        break;
      case '7 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 7)).toString();
        });
        break;
      case '14 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 14)).toString();
        });
        break;
      case '30 days':
        setState(() {
          endTime = DateTime.now().toString();
          startTime =
              DateTime.now().subtract(const Duration(days: 30)).toString();
        });
        break;
    }
    var istDate1;
    var istDate2;
    setState(() {
      // bookingDateList[3] = (nextDay.MMMEd);
      istDate1 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(startTime)
          .subtract(const Duration(hours: 5, minutes: 30));
      istDate2 = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(endTime)
          .subtract(const Duration(hours: 5, minutes: 30));
    });
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..maskColor = darkBlueColor
      ..userInteractions = false
      ..backgroundColor = darkBlueColor
      ..dismissOnTap = false;
    EasyLoading.show(
      status: "Loading...",
    );

    //Run all APIs using new Date Range
    var f = getDataHistory(widget.gpsData.last.imei, startTime, endTime);
    var s = getStoppageHistory(widget.gpsData.last.imei, startTime, endTime);
    var t = getRouteStatusList(widget.gpsData.last.imei, startTime, endTime);
    var newGpsTruckHistory = await f;
    var newGpsStoppageHistory = await s;
    var newRouteHistory = await t;
    var newTotalRunningTime =
        getTotalRunningTime(newGpsStoppageHistory, istDate1, istDate2);
    var newTotalStoppedTime = getTotalStoppageTime(newGpsStoppageHistory);

    int i = 0;
    var start;
    var end;
    var duration;
    while (i < newRouteHistory.length) {
      if (i == 0) {
        DateTime yesterday = istDate1;
        start = getISOtoIST(istDate1.toIso8601String());
        end = getISOtoIST(newRouteHistory[i].startTime);
        duration = getStopDuration(
            yesterday.toIso8601String(), newRouteHistory[i].startTime);
        newRouteHistory.insert(i, ["stopped", start, end, duration]);
      } else {
        start = getISOtoIST(newRouteHistory[i - 1].endTime);
        end = getISOtoIST(newRouteHistory[i].startTime);
        duration = getStopDuration(
            newRouteHistory[i - 1].endTime, newRouteHistory[i].startTime);
        newRouteHistory.insert(i, ["stopped", start, end, duration]);
      }
      i = i + 2;
    }
    if (newRouteHistory != null) {
      setState(() {
        gpsTruckHistory = newGpsTruckHistory;
        gpsStoppageHistory = newGpsStoppageHistory;
        totalDistance = newRouteHistory.removeAt(0);
        routeHistory = newRouteHistory;
        dateRange = "$startTime - $endTime";
        totalRunningTime = newTotalRunningTime;
        totalStoppedTime = newTotalStoppedTime;
      });
      // getLatLngList();
      Get.back();
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      showDialog(
          context: context, builder: (context) => InvalidDateCondition());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //add Ui
    return Container(
        color: white,
        width: Responsive.isMobile(context) ? width : width / 3,
        height: Responsive.isMobile(context) ? height / 1.5 : height,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Center(
                  child: Container(
                    height: 51,
                    width: 186,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(9, 183, 120, 0.2),
                    ),
                    child: const Center(
                      child: Text(
                        "In Transit",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(9, 183, 120, 1)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                const Divider(
                  color: Color.fromRGBO(9, 183, 20, 1),
                  thickness: 5,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
              ],
            ),
          ),
        ]));
  }
}
