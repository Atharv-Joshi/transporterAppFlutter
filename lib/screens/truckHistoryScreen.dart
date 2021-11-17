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
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/truckHistoryStatus.dart';

class TruckHistoryScreen extends StatefulWidget {
  var gpsTruckRoute;
  String? truckNo;
  String? dateRange;
  String? imei;

  TruckHistoryScreen({
      required this.gpsTruckRoute,
      required this.truckNo,
      required this.dateRange,
      required this.imei,
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
              primaryColor: lightBlue,
              accentColor: const Color(0xFF8CE7F1),
              unselectedWidgetColor: grey,
              colorScheme: ColorScheme.light(primary: lightBlue),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!
        );
      },
    );
    // Jiffy nextDay = Jiffy(picked);

    if (picked != null) {
      setState(() {
        // bookingDateList[3] = (nextDay.MMMEd);
        selectedDate = picked;
        print("SEL Date $selectedDate");
        selectedDateString = selectedDate.toString().split(" - ");
        print("selected date 1 ${selectedDateString[0]} and ${selectedDateString[1]}");
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
      var newRouteHistory = await getRouteStatusList(widget.imei, selectedDateString[0], selectedDateString[1]);

      print("AFter $newRouteHistory");
      setState(() {
        totalDistance = newRouteHistory.removeAt(0);
        print("AFter $totalDistance");

        gpsRoute = newRouteHistory;
        dateRange = selectedDate.toString();
      });

      if (gpsRoute!= null) {
        Get.back();
        EasyLoading.dismiss();
        // getDateRange();
        Get.to(TruckHistoryScreen(
          truckNo: widget.truckNo,
          gpsTruckRoute: gpsRoute,
          dateRange: dateRange,
          imei: widget.imei,
        ));

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
