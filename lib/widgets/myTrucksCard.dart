import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/models/deviceModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {
  var truckno;
  var gpsData;
  String status;
  var imei;
  DeviceModel device;
  MyTruckCard(
      {required this.truckno,
      required this.status,
      this.gpsData,
      this.imei,
      required this.device});

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  bool online = true;
  Position? userLocation;
  bool driver = false;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var totalDistance;
  var lastupdated;
  var no_stoppages;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));

  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  late String from = yesterday.toIso8601String();
  late String to = now.toIso8601String();

  @override
  void initState() {
    super.initState();

    try {
      initfunction();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // driver = widget.truckData.driverName != 'NA' ? true : false;
    /*   String truckType = truckFilterVariables.truckTypeValueList
            .contains(widget.truckData.truckType)
        ? truckFilterVariables.truckTypeTextList[truckFilterVariables
            .truckTypeValueList
            .indexOf(widget.truckData.truckType)]
        : 'NA';
*/
    Map<String, Color> statusColor = {
      'Available': liveasyGreen,
      'Busy': Colors.red,
      'Offline': unselectedGrey,
    };

    if (widget.status == 'Online') {
      online = true;
    } else {
      online = false;
    }
    lastupdated =
        getStopDuration(widget.device.lastUpdate!, now.toIso8601String());
    /*   if (driver && widget.truckData.driverName!.length > 15) {
      widget.truckData.driverName =
          widget.truckData.driverName!.substring(0, 14) + '..';
    }
    */

    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () async {
          
          
            Get.to(
              TrackScreen(
                deviceId: widget.gpsData.deviceId,
                gpsData: widget.gpsData,
                // position: position,
                TruckNo: widget.truckno,
              //  no_stoppages: no_stoppages,
                //   driverName: widget.truckData.driverName,
                //  driverNum: widget.truckData.driverNum,
              //  gpsDataHistory: gpsDataHistory,
              //  gpsStoppageHistory: gpsStoppageHistory,
               // gpsRoute: gpsRoute,
             //   routeHistory: gpsRoute,
                //    truckId: widget.truckData.truckId,
                totalDistance: totalDistance,
                imei: widget.imei,
              ),
            );
          
        },
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                  ),
                  child: Column(
                    children: [
                      online
                          ? Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                    child: Icon(
                                      Icons.circle,
                                      color: const Color(0xff09B778),
                                      size: 6,
                                    ),
                                  ),
                                  Text(
                                    'online'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        space_28,
                                    child: Text(
                                      ' (${'lastupdated'.tr} $lastupdated ${'ago'.tr})',
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                    child: Icon(
                                      Icons.circle,
                                      color: const Color(0xffFF4D55),
                                      size: 6,
                                    ),
                                  ),
                                  Text(
                                    'offline'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        space_28,
                                    child: Text(
                                      ' (${'lastupdated'.tr} $lastupdated ${'ago'.tr})',
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      /*    Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                            height: space_2,
                            width: space_2,
                            decoration: BoxDecoration(
                              color: statusColor['Offline'],
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),

                          Text(
                            AppLocalizations.of(context)!.offline,
                            style: TextStyle(
                                fontWeight: mediumBoldWeight, fontSize: size_8),
                          ),
                        ],
                      ), */
                      /*   SizedBox(height: space_2,),
                      NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber , value: widget.truckData.truckNo),
                      SizedBox(height: space_2,),*/
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/box-truck.png',
                            width: 29,
                            height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckno}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                ),
                              ),
                              /*   Text(
                                'time date ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: black,
                                  ),

                              ),*/
                            ],
                          ),
                          Spacer(),
                          (widget.gpsData.speed > 5)
                              ? Container(
                                  child: Column(
                                    children: [
                                      Text(
                                          "${(widget.gpsData.speed).round()} km/h",
                                          style: TextStyle(
                                              color: liveasyGreen,
                                              fontSize: size_10,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight)),
                                      Text('running'.tr,
                                          // "Status",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: size_6,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight))
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    children: [
                                      Text(
                                          "0 km/h",
                                          style: TextStyle(
                                              color: red,
                                              fontSize: size_10,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight)),
                                      Text('stopped'.tr,
                                          // "Status",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: size_6,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight))
                                    ],
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: const Color(0xFFCDCDCD),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 200,
                                child: Text(
                                  "${widget.gpsData.address}",
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: normalWeight),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: const Color(0xFFCDCDCD),
                            ),
                            SizedBox(width: 8),
                            Text('truckTravelled'.tr,
                                // "Truck Travelled : ",
                                softWrap: true,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                            Text("$totalDistance " + 'kmToday'.tr,
                                // "km Today",
                                softWrap: true,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 0, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/circle-outline-with-a-central-dot.png',
                              color: const Color(0xFFCDCDCD),
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('ignition'.tr,
                                // 'Ignition  :',
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                            (widget.gpsData.ignition)
                                ? Text('on'.tr,
                                    // "ON",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight))
                                : Text('off'.tr,
                                    // "OFF",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                          ],
                        ),
                      ),

                      /*       SizedBox(height: space_2,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.status}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: veryDarkGrey,
                            fontWeight: mediumBoldWeight,
                            fontSize: size_6,
                          ),
                        ),
                      ),
                      SizedBox(height: space_2,),
                      // NewRowTemplate(label: AppLocalizations.of(context)!.tyre, value: widget.truckData.tyres.toString()  , width: 98,),
                      // NewRowTemplate(label: AppLocalizations.of(context)!.driver, value: widget.truckData.driverName , width: 98,),
                      Container(
                        margin: EdgeInsets.only(top: space_2),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: space_2),
                                child: TrackButton(
                                  truckApproved: widget.truckData.truckApproved!,
                                  phoneNo: widget.truckData.driverNum,
                                  TruckNo: widget.truckData.truckNo,
                                  imei: widget.truckData.imei,
                                  DriverName: widget.truckData.driverName,
                                  gpsData: widget.gpsData,
                                  truckId: widget.truckData.truckId,
                                )
                            ),
                            CallButton(directCall: true , phoneNum: widget.truckData.driverNum,)
                          ],
                        ),
                      ),
                      */
                    ],
                  ),
                )
                /*             : Container(
                        padding: EdgeInsets.all(space_3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/box-truck.png',
                                  width: 29,
                                  height: 29,
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${widget.truckno}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: black,
                                      ),
                                    ),
                                    /*  Text(
                                      'time date ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: black,
                                      ),
                                    ),*/
                                  ],
                                ),
                                SizedBox(
                                  width: 23,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  27.00, 20.00, 20.00, 0.00),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/circle-outline-with-a-central-dot.png',
                                    color: const Color(0xFFCDCDCD),
                                    width: 12,
                                    height: 12,
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    width: 200,
                                    child: Text(
                                    //  'buyGPS'.tr,
                                    'Device is Offline',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF152968),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*            Row(
                        children: [
                          Image(
                              height: 16 ,
                              width: 18,
                              image: AssetImage('assets/icons/errorIcon.png')
                          ),
                          Container(
                            margin: EdgeInsets.only(left: space_1),
                            child: Text(
                               AppLocalizations.of(context)!.verificationFailed,
                              style: TextStyle(
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: space_3),
                          child: NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber, value: widget.truckData.truckNo)
                      ),
                      Container(
                        child: Text(
                          AppLocalizations.of(context)!.truckDetailsArePending,
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              color: Colors.red
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: space_5),
                          height: 32,
                          width: 201,
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(darkBlueColor),
                            ),
                            onPressed: () {
                              providerData.updateIsAddTruckSrcDropDown(true);
                              Get.to( () => TruckDescriptionScreen(truckId : widget.truckData.truckId! , truckNumber: widget.truckData.truckNo! ,)
                              );
                              providerData.resetTruckFilters();
                            },
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context)!.uploadTruckDetails,
                                style: TextStyle(
                                  letterSpacing: 0.7,
                                  fontWeight: normalWeight,
                                  color: white,
                                  fontSize: size_7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )


                */
                          ],
                        ),
                      ),
           */ /*  driver
                    ? Container(
                        padding: EdgeInsets.fromLTRB(23, 0, 7, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/11 1.png',
                              width: 22,
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Text(
                                widget.truckData.driverName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: black,
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CallButton(
                                directCall: false,
                                driverName: widget.truckData.driverName,
                                driverPhoneNum: widget.truckData.driverNum,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(23, 0, 0, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/images 1.png',
                              width: 24,
                              height: 22,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 10, 0, 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddDriverAlertDialog(
                                              notifyParent: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyDrivers()));
                                              },
                                            ));
                                  },
                                  child: Container(
                                    child: Text(
                                      'addDriver'.tr,
                                      // 'Add Driver',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  initfunction() async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.gpsData.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
    print('in init');
  }
}
