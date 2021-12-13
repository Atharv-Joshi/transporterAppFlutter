import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/invalidDateConditionDialog.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/truckHistoryStatus.dart';

class TruckHistoryScreen extends StatefulWidget {
  var gpsTruckRoute;
  String? truckNo;
  String? dateRange;
  int? deviceId;

  TruckHistoryScreen({
      required this.gpsTruckRoute,
      required this.truckNo,
      required this.dateRange,
      required this.deviceId,
  });

  @override
  _TruckHistoryScreenState createState() => _TruckHistoryScreenState();
}

class _TruckHistoryScreenState extends State<TruckHistoryScreen> {
  var startTime;
  var endTime;
  MapUtil mapUtil = MapUtil();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var gpsRoute = [];
  bool loading = false;
  String? dateRange;
  var selectedDateString = [];
  DateTimeRange selectedDate = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 1)),
      end: DateTime.now()
  );
  var totalDistance;

  @override
  void initState() {

    super.initState();
    setState(() {
      gpsRoute = widget.gpsTruckRoute;
      dateRange = widget.dateRange;
      loading = true;
    });
    getDateRange();
    // getStopList();
  }

  getDateRange(){
    print("Date Range $dateRange");
    var now = dateFormat.format(DateTime.now()).split(" ");
    var timestamp = now[1].replaceAll(":", "");
    var hour = int.parse(timestamp.substring(0, 2));
    var minute = int.parse(timestamp.substring(2, 4));
    var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));

    var splitted = dateRange!.split(" - ");
    var start1 = getFormattedDateForDisplay2(splitted[0]).split(", ");
    var end1 = getFormattedDateForDisplay2(splitted[1]).split(", ");
    if(start1[1]=="12:00 AM") {
      start1[1] = ampm;
      end1[1] = ampm;
    }
    setState(() {
      startTime = "${start1[0]}, ${start1[1]}";
      endTime = "${end1[0]}, ${end1[1]}";
    });
  }

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
              DateTime.now().day, 0, 0)
      ),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 5,
      ),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: darkBlueColor,
              scaffoldBackgroundColor: white,

              accentColor: darkBlueColor,
              unselectedWidgetColor: grey,

              colorScheme: ColorScheme.fromSwatch().copyWith(
                //Selected dates background color
                primary: darkBlueColor,
                onSecondary: darkBlueColor,
                //Month title and week days color
                onSurface: Colors.black,
                //Header elements and selected dates text color
                // onPrimary: Colors.black,
                onBackground: white
              ),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(space_6, space_30, space_6, space_30),
                  child: child! ,
              //     decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(12),
              //     ),
              // )
        ),
            )
        );
      },
    );

    if (picked != null) {
      var istDate1;
      var istDate2;
      setState(() {
        // bookingDateList[3] = (nextDay.MMMEd);
        selectedDate = picked;
        print("SEL Date $selectedDate");
        selectedDateString = selectedDate.toString().split(" - ");
        istDate1 =  new DateFormat("yyyy-MM-dd hh:mm:ss").parse(selectedDateString[0]).subtract(Duration(hours: 5, minutes: 30));
        istDate2 =  new DateFormat("yyyy-MM-dd hh:mm:ss").parse(selectedDateString[1]).subtract(Duration(hours: 5, minutes: 30));
        print("selected date 1 ${istDate1.toIso8601String()} and ${istDate2.toIso8601String()}");
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
      var newRouteHistory = await getRouteStatusList(widget.deviceId, istDate1.toIso8601String(), istDate2.toIso8601String());
      print("AFter ${newRouteHistory.length}");
      int i=0;
      var start;
      var end;
      var duration;
      while(i<newRouteHistory.length){
        if(i==0) {
          DateTime yesterday = istDate1;
          start = getISOtoIST(istDate1.toIso8601String());
          end = getISOtoIST(newRouteHistory[i].startTime);
          duration = getStopDuration(yesterday.toIso8601String(), newRouteHistory[i].startTime);
          newRouteHistory.insert(i, ["stopped", start, end, duration]);
        } else {
          start = getISOtoIST(newRouteHistory[i - 1].endTime);
          end = getISOtoIST(newRouteHistory[i].startTime);
          duration = getStopDuration(newRouteHistory[i - 1].endTime, newRouteHistory[i].startTime);
          newRouteHistory.insert(i, ["stopped", start, end, duration]);
        }
        i = i+2;
      }
      print("With Stops $newRouteHistory");
      if (newRouteHistory!= null) {
        setState(() {
        gpsRoute = newRouteHistory;
        dateRange = selectedDate.toString();
      });
        Get.back();
        EasyLoading.dismiss();
        // getDateRange();
        Get.to(TruckHistoryScreen(
          truckNo: widget.truckNo,
          gpsTruckRoute: gpsRoute,
          dateRange: dateRange,
          deviceId: widget.deviceId,
        ));
      }
      else{
        EasyLoading.dismiss();
        showDialog(
            context: context,
            builder: (context) => InvalidDateCondition());
        print("gps route null");
      }
    }
  }

  Widget status(int index){
    return TruckStatus(
      truckHistory: gpsRoute[index],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, space_10, 0, space_2),
                height: MediaQuery.of(context).size.height,
                child: Column(
                    children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(space_3, 0, 0, space_3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   width: space_3,
                        // ),
                        Header(
                            reset: false,
                            text: "${widget.truckNo}",
                            backButton: true),
                      ],
                    ),
                  ),
                  Divider(
                    color: black,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(space_3, space_1, 0, space_2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(children: [
                              Text(
                                "From:  ",
                                style: TextStyle(
                                    color: grey,
                                    fontSize: size_7,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: mediumBoldWeight),
                              ),
                              Text(
                                "$startTime",
                                style: TextStyle(
                                    color: darkBlueColor,
                                    fontSize: size_7,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: boldWeight),
                              ),
                            ]),
                            SizedBox(
                              height: space_2,
                            ),
                            Row(children: [
                              Text(
                                "To: ",
                                style: TextStyle(
                                    color: grey,
                                    fontSize: size_7,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: mediumBoldWeight),
                              ),
                              SizedBox(
                                width: space_6,
                              ),
                              Text(
                                "$endTime",
                                style: TextStyle(
                                    color: darkBlueColor,
                                    fontSize: size_7,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: boldWeight),
                              ),
                            ])
                          ],
                        ),
                        SizedBox(
                          width: space_5,
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectDate(context);
                          },
                          child: Icon(Icons.keyboard_arrow_down,
                              size: size_11),
                        )
                      ],
                    ),
                  ),
                  // Divider(
                  //   color: black,
                  // ),
                  Expanded(
                      child: Container(
                          color: white,
                          alignment: Alignment.bottomCenter,
                          child :
                            // loading
                            //   ? TruckLoadingWidgets()
                             ListView.builder(
                              padding: EdgeInsets.only(bottom: space_15),
                              itemCount: gpsRoute.length,
                              itemBuilder: (context, index) {
                                return status(index);
                              }
                            )
                      // ]
                      )
                  )
                ]
                )
            )
        )
    );
  }

}
