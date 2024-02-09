import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/alertDialog/invalidDateConditionDialog.dart';
import 'package:liveasy/widgets/historyScreenMapWidget.dart';
import 'package:liveasy/widgets/truckHistoryStatus.dart';

class TruckHistoryScreen extends StatefulWidget {
//  var gpsTruckRoute;
  String? truckNo;
  String? dateRange;
  int? deviceId;
  var istDate1;
  var istDate2;
  var gpsStoppageHistory;
  var gpsDataHistory;
  String? selectedLocation;
  var totalDistance;
  TruckHistoryScreen({
    required this.truckNo,
    required this.dateRange,
    required this.deviceId,
    required this.selectedLocation,
    required this.istDate1,
    required this.istDate2,
    required this.totalDistance,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
  });

  @override
  _TruckHistoryScreenState createState() => _TruckHistoryScreenState();
}

class _TruckHistoryScreenState extends State<TruckHistoryScreen> {
  var startTime;
  var endTime;
  var gpsStoppageHistory;
  var gpsDataHistory;
  MapUtil mapUtil = MapUtil();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var gpsRoute = [];
  bool loading = true;
  bool showBottomMenu = false;
  String? dateRange;
  var threshold = 100;
  var istDate1;
  var istDate2;
  var gpsHistory;
  ScrollController scrollController = ScrollController();
  var selectedDateString = [];
  List<String> _locations = [
    '24 hours',
    '48 hours',
    '7 days',
    '14 days',
    '30 days'
  ];
  String? _selectedLocation;
  DateTimeRange selectedDate = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now());
  var totalDistance;
  var gpsPosition;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      dateRange = widget.dateRange;
      loading = true;
      istDate1 = widget.istDate1;
      istDate2 = widget.istDate2;
      _selectedLocation = widget.selectedLocation;
      totalDistance = widget.totalDistance;
      gpsDataHistory = widget.gpsDataHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
    });

    initfunction();
    getDateRange();
    EasyLoading.dismiss();
  }

  getDateRange() {
    var now = dateFormat.format(DateTime.now()).split(" ");
    var timestamp = now[1].replaceAll(":", "");
    var hour = int.parse(timestamp.substring(0, 2));
    var minute = int.parse(timestamp.substring(2, 4));
    var ampm = DateFormat.jm().format(DateTime(0, 0, 0, hour, minute));

    var splitted = dateRange!.split(" - ");
    var start1 = getFormattedDateForDisplay2(splitted[0]).split(", ");
    var end1 = getFormattedDateForDisplay2(splitted[1]).split(", ");
    if (start1[1] == "12:00 AM") {
      start1[1] = ampm;
      end1[1] = ampm;
    }
    setState(() {
      startTime = "${start1[0]}";
      endTime = "${end1[0]}";
    });
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
            DateTime.now().hour,
            DateTime.now().minute,
          ),
          end: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
          )),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 30,
        DateTime.now().hour,
        DateTime.now().minute,
      ),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: darkBlueColor,
              scaffoldBackgroundColor: white,
              unselectedWidgetColor: grey,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  //Selected dates background color
                  primary: darkBlueColor,
                  onSecondary: darkBlueColor,
                  onSurface: Colors.black,
                  onBackground: const Color.fromRGBO(58, 57, 57, 0.16)),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.center,
                margin:
                    EdgeInsets.fromLTRB(space_6, space_15, space_6, space_20),
                child: child!,
              ),
            ));
      },
    );

    if (picked != null) {
      var istDate1;
      var istDate2;
      setState(() {
        selectedDate = picked;
        selectedDateString = selectedDate.toString().split(" - ");
        istDate1 = new DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(selectedDateString[0])
            .subtract(const Duration(hours: 5, minutes: 30))
            .add(
              Duration(
                  hours: DateTime.now().hour, minutes: DateTime.now().minute),
            );
        istDate2 = new DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(selectedDateString[1])
            .subtract(const Duration(hours: 5, minutes: 30))
            .add(
              Duration(
                  hours: DateTime.now().hour, minutes: DateTime.now().minute),
            );
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
      //get NEW ROUTE HISTORY using SELECTED DATE
      var a = getStoppageHistory(widget.deviceId, istDate1.toIso8601String(),
          istDate2.toIso8601String());
      var b = getDataHistory(widget.deviceId, istDate1.toIso8601String(),
          istDate2.toIso8601String());
      var gpsDataHistory1 = await b;
      var gpsStoppageHistory1 = await a;
      distancecalculation(
          istDate1.toIso8601String(), istDate2.toIso8601String());
      if (gpsStoppageHistory != null) {
        setState(() {
          gpsStoppageHistory = gpsStoppageHistory1;
          gpsDataHistory = gpsDataHistory1;
          dateRange = selectedDate.toString();
        });
        Get.back();
        EasyLoading.dismiss();
        Get.to(() => TruckHistoryScreen(
              truckNo: widget.truckNo,
              dateRange: dateRange,
              deviceId: widget.deviceId,
              istDate1: istDate1,
              istDate2: istDate2,
              selectedLocation: widget.selectedLocation,
              totalDistance: totalDistance,
              gpsDataHistory: gpsDataHistory,
              gpsStoppageHistory: gpsStoppageHistory,
            ));
      } else {
        EasyLoading.dismiss();
        showDialog(
            context: context, builder: (context) => InvalidDateCondition());
      }
    }
  }

  Widget status(int index) {
    return TruckStatus(
      truckHistory: gpsRoute[index],
      deviceId: widget.deviceId,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  distancecalculation(String from, String to) async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Responsive.isMobile(context)
        //Ui for Mobile
        ? SafeArea(
            child: Scaffold(
                backgroundColor: backgroundColor,
                body: GestureDetector(
                    onTap: () {
                      setState(() {
                        showBottomMenu = !showBottomMenu;
                      });
                    },
                    onPanEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > threshold) {
                        this.setState(() {
                          showBottomMenu = false;
                        });
                      } else if (details.velocity.pixelsPerSecond.dy <
                          -threshold) {
                        this.setState(() {
                          showBottomMenu = true;
                        });
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(children: <Widget>[
                        (loading)
                            ? Container()
                            : HistoryScreenMapWidget(
                                routeHistory: gpsRoute,
                                truckNo: widget.truckNo,
                                deviceId: widget.deviceId,
                                selectedlocation: widget.selectedLocation,
                                gpsDataHistory: widget.gpsDataHistory,
                                gpsStoppageHistory: widget.gpsStoppageHistory,
                              ),
                        Positioned(
                          top: 0,
                          height: space_13,
                          child: Container(
                            color: backgroundColor,
                            width: MediaQuery.of(context).size.width,
                            height: space_13,
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    space_3, space_4, 0, space_1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Header(
                                        reset: false,
                                        text: "${widget.truckNo}",
                                        backButton: true),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                        AnimatedPositioned(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 200),
                          left: 0,
                          bottom:
                              (showBottomMenu) ? 0 : -(height) * 2 / 3 + 125,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: height - 105,
                            decoration: const BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: darkShadow,
                                    offset: Offset(
                                      0,
                                      -5.0,
                                    ),
                                    blurRadius: 15.0,
                                    spreadRadius: 10.0,
                                  ),
                                  BoxShadow(
                                    color: white,
                                    offset: Offset(0, 1.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 2.0,
                                  ),
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    color: Color(0xFFCBCBCB),
                                    thickness: 3,
                                    indent: 150,
                                    endIndent: 150,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_7, space_4, 0, space_1),
                                    child: Text(
                                      'selectDates'.tr,
                                      style: TextStyle(
                                        fontSize: size_7,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        space_7, space_1, 0, space_2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 +
                                                40,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffDFE3EF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            child: Row(children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(9, 5, 0, 0),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      child: Text(
                                                        "from".tr + ":  ",
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xff545454),
                                                            fontSize: size_5,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                mediumBoldWeight),
                                                      ),
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  9, 2, 0, 5),
                                                          child: Text(
                                                            "$startTime",
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xff152968),
                                                                fontSize:
                                                                    size_7,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ]),
                                              const Spacer(),
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 16,
                                              ),
                                              const Spacer(),
                                            ]),
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 +
                                                40,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffDFE3EF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            child: Row(children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          9.0, 5, 0, 0),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      child: Text(
                                                        "to".tr + ": ",
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xff545454),
                                                            fontSize: size_5,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                mediumBoldWeight),
                                                      ),
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  9, 2, 0, 5),
                                                          child: Text(
                                                            "$endTime",
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xff152968),
                                                                fontSize:
                                                                    size_7,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ]),
                                              const Spacer(),
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 16,
                                              ),
                                              const Spacer(),
                                            ]),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_7, space_1, 0, space_1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'distanceCovered'.tr,
                                          style: TextStyle(
                                            fontSize: size_6,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff656565),
                                          ),
                                        ),
                                        SizedBox(
                                          width: space_1,
                                        ),
                                        Text(
                                          '$totalDistance' + ' km'.tr,
                                          style: TextStyle(
                                            fontSize: size_6,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff656565),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          space_7, space_2, 0, space_2),
                                      child: Text(
                                        "history".tr,
                                        style: TextStyle(
                                          fontSize: size_7,
                                          color: black,
                                        ),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: height - 300,
                                      alignment: Alignment.bottomCenter,
                                      child: ListView.builder(
                                          itemCount: gpsRoute.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return status(index);
                                          })),
                                ]),
                          ),
                        )
                      ]),
                    ))),
          )
        : SafeArea(
            child: Scaffold(
                backgroundColor: white,
                body: GestureDetector(
                    onTap: () {
                      setState(() {
                        showBottomMenu = !showBottomMenu;
                      });
                    },
                    onPanEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > threshold) {
                        this.setState(() {
                          showBottomMenu = false;
                        });
                      } else if (details.velocity.pixelsPerSecond.dy <
                          -threshold) {
                        this.setState(() {
                          showBottomMenu = true;
                        });
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(children: <Widget>[
                        Positioned(
                            right: 0,
                            top: space_13,
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  (loading)
                                      ? Container()
                                      : HistoryScreenMapWidget(
                                          routeHistory: gpsRoute,
                                          truckNo: widget.truckNo,
                                          deviceId: widget.deviceId,
                                          selectedlocation:
                                              widget.selectedLocation,
                                          gpsDataHistory: widget.gpsDataHistory,
                                          gpsStoppageHistory:
                                              widget.gpsStoppageHistory,
                                        ),
                                ],
                              ),
                            )),
                        //header
                        Positioned(
                          top: 0,
                          height: space_13,
                          child: Container(
                            color: white,
                            width: MediaQuery.of(context).size.width,
                            height: space_13,
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    space_3, space_4, 0, space_1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Header(
                                        reset: false,
                                        text: "${widget.truckNo}",
                                        backButton: true),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                        // data
                        AnimatedPositioned(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 200),
                          left: 0,
                          top: space_13,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: height,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 46,
                                      width: 181,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(9, 183, 120, 0.2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "In Transit",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  9, 183, 120, 1)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 30,
                                  ),
                                  const Divider(
                                    color: Color.fromRGBO(9, 183, 20, 1),
                                    // height: size_3,
                                    thickness: 5,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: const Text(
                                        "Route History",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromRGBO(21, 41, 104, 1),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SingleChildScrollView(
                                      child: Container(
                                          color: backgroundColor,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: height / 2 - 100,
                                          alignment: Alignment.bottomCenter,
                                          child: ListView.builder(
                                              itemCount: gpsRoute.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              controller: scrollController,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                return status(index);
                                              })
                                          // ]
                                          ),
                                    ),
                                  ),
                                ]),
                          ),
                        )
                      ]),
                    ))),
          );
  }

  void initfunction() async {
    var b = getRouteStatusList(widget.deviceId, istDate1.toIso8601String(),
        istDate2.toIso8601String());
    var gpsRoute2 = await b;

    gpsRoute2 = getStopList(gpsRoute2, gpsStoppageHistory, istDate1, istDate2);

    setState(() {
      setState(() {
        loading = false;
        gpsRoute = gpsRoute2;
      });
      EasyLoading.dismiss();
    });
  }
}
