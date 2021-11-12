import 'package:flutter/material.dart';
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
  var gpsData;
  var gpsTruckHistory;
  var gpsStoppageHistory;
  var gpsTruckRoute;
  String? truckNo;

  TruckHistoryScreen(
      {required this.gpsData,
      required this.gpsTruckHistory,
      required this.gpsStoppageHistory,
      required this.gpsTruckRoute,
      required this.truckNo});

  @override
  _TruckHistoryScreenState createState() => _TruckHistoryScreenState();
}

class _TruckHistoryScreenState extends State<TruckHistoryScreen> {
  var startTime;
  var endTime;
  MapUtil mapUtil = MapUtil();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  // var gpsRoute = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // getRouteHistory();
    print("THSI ${widget.gpsTruckRoute}");
    // print("THSI 2 ${widget.gpsTruckRoute.totalDistanceCovered}");
    getStartEndTime();
    setState(() {
      loading = true;
    });
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
                              itemCount: widget.gpsTruckRoute.length,
                              itemBuilder: (context, index) {
                                return TruckStatus(
                                  truckHistory: widget.gpsTruckRoute[index],
                                  // stoppageHistory: widget.gpsStoppageHistory[index],

                                );
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

  getStartEndTime() {
    var nowTime = dateFormat.format(DateTime.now()).toString();
      endTime = getFormattedDateForDisplay2(nowTime);
      print("IN Now $endTime");

    var yesterday = dateFormat.format(DateTime.now().subtract(Duration(days: 1))).toString();
      startTime = getFormattedDateForDisplay2(yesterday);
      print("IN Now $startTime");
  }
}
