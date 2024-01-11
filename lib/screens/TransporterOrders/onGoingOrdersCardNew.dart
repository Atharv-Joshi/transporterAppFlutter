import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
// import 'package:liveasy/models/WidgetLoadDetailsScreenModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TransporterOrders/documentUploadScreen.dart';
import 'package:liveasy/screens/documentUploadScreenWeb.dart';
import 'package:liveasy/widgets/buttons/completedButton.dart';
import 'package:liveasy/widgets/buttons/fastagButton.dart';
import 'package:liveasy/widgets/buttons/trackButton.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
// import 'linePainter.dart';

class onGoingOrdersCardNew extends StatefulWidget {
  OngoingCardModel loadAllDataModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;
  var gpsDataList;
  String? totalDistance;
  var device;

  onGoingOrdersCardNew({
    required this.loadAllDataModel,
    this.loadDetailsScreenModel,
    required this.gpsDataList,
    required this.totalDistance,
    this.device,
  });

  @override
  State<onGoingOrdersCardNew> createState() => _OngoingOrdersCardNewState();
}

class _OngoingOrdersCardNewState extends State<onGoingOrdersCardNew> {
  // GpsDataModel? gpsData;
  // var devicelist = [];
  // var gpsDataList = [];
  // var gpsList = [];

  // bool getMyTruckPostionBoolValue = false;
  // bool initfunctionBoolValue = false;

  // DateTime yesterday =
  //     DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  // String? from;
  // String? to;
  // DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  // String? totalDistance;
  @override
  void initState() {
    super.initState();
    // print(widget.loadAllDataModel.transporterId.toString());
    // getMyTruckPosition();
    // initFunction();
    // print("gpsDataList");
    // print(gpsDataList);
    // print(getMyTruckPostionBoolValue.toString() +
    //     initfunctionBoolValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    bool small = true;
    double textFontSize;
    if (MediaQuery.of(context).size.width > 1099 &&
        MediaQuery.of(context).size.width < 1400) {
      small = true;
    } else {
      small = false;
    }
    if (small) {
      textFontSize = 12;
    } else {
      textFontSize = 16;
    }

    widget.loadAllDataModel.truckType;
    widget.loadAllDataModel.productType;
    widget.loadAllDataModel.unitValue;
    //widget.loadAllDataModel.noOfTrucks;
    widget.loadAllDataModel.driverName ??= "NA";
    widget.loadAllDataModel.driverName =
        widget.loadAllDataModel.driverName!.length >= 20
            ? '${widget.loadAllDataModel.driverName!.substring(0, 18)}..'
            : widget.loadAllDataModel.driverName;
    if (widget.loadAllDataModel.companyName == null) {}
    widget.loadAllDataModel.companyName =
        widget.loadAllDataModel.companyName!.length >= 35
            ? '${widget.loadAllDataModel.companyName!.substring(0, 33)}..'
            : widget.loadAllDataModel.companyName;

    widget.loadAllDataModel.unitValue =
        widget.loadAllDataModel.unitValue == "PER_TON"
            ? "tonne".tr
            : "truck".tr;
    return (kIsWeb && Responsive.isDesktop(context))
        ?
        // gpsDataList.isEmpty
        // !initfunctionBoolValue
        //     ? Container()
        //     :
        // return
        Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                      visibleWidget: documentUploadScreenWeb(
                        loadAllDataModel: widget.loadAllDataModel,
                        bookingId: widget.loadAllDataModel.bookingId.toString(),
                        loadDetailsScreenModel: widget.loadDetailsScreenModel,
                        truckNo: widget.loadAllDataModel.truckNo,
                        loadingPoint: widget.loadAllDataModel.loadingPointCity,
                        unloadingPoint:
                            widget.loadAllDataModel.unloadingPointCity,
                        transporterName:
                            widget.loadAllDataModel.transporterName,
                        transporterPhoneNum:
                            widget.loadAllDataModel.transporterPhoneNum,
                        driverPhoneNum: widget.loadAllDataModel.driverPhoneNum,
                        driverName: widget.loadAllDataModel.driverName,
                        bookingDate: widget.loadAllDataModel.bookingDate,
                        gpsDataList: widget.gpsDataList,
                        totalDistance: widget.totalDistance,
                      ),
                      index: 1000,
                      selectedIndex: screens.indexOf(ordersScreen),
                    ),
                  ),
                );
                //     ShipperDetails(
                //   bookingId: widget.loadAllDataModel.bookingId.toString(),
                //   noOfTrucks: widget.loadAllDataModel.noOfTrucks,
                //   productType: widget.loadAllDataModel.productType,
                //   loadingPoint: widget.loadAllDataModel.loadingPointCity,
                //   unloadingPoint: widget.loadAllDataModel.unloadingPointCity,
                //   rate: widget.loadAllDataModel.rate,
                //   vehicleNo: widget.loadAllDataModel.truckNo,
                //   shipperPosterCompanyApproved:
                //       widget.loadAllDataModel.companyApproved,
                //   shipperPosterCompanyName: widget.loadAllDataModel.companyName,
                //   shipperPosterLocation:
                //       widget.loadAllDataModel.transporterLocation,
                //   shipperPosterName: widget.loadAllDataModel.transporterName,
                //   transporterPhoneNum: widget.loadAllDataModel.transporterPhoneNum,
                //   driverPhoneNum: widget.loadAllDataModel.driverPhoneNum,
                //   driverName: widget.loadAllDataModel.driverName,
                //   transporterName: widget.loadAllDataModel.companyName,
                //   trackApproved: true,
                //   gpsDataList: widget.gpsDataList,
                //   totalDistance: widget.totalDistance,
                // ));
              },//OngoingCard for web
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                widget.loadAllDataModel.bookingDate ?? 'Null',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: textFontSize,
                                    fontFamily: 'Montserrat'),
                              ))),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.loadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.unloadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.truckNo}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 4,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.driverName}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.rate}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: textFontSize,
                              fontFamily: 'Montserrat'),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Flex(
                            mainAxisSize: MainAxisSize.min,
                            direction: Axis.vertical,
                            children: [
                              Flexible(
                                  child: Text(
                                '${widget.loadAllDataModel.companyName}' ??
                                    'Null',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: textFontSize,
                                    fontFamily: 'Montserrat'),
                              ))
                            ]),
                      )),
                    ),
                    const VerticalDivider(color: Colors.grey, thickness: 1),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  TrackButton(
                                    gpsData: widget.gpsDataList[0],
                                    truckApproved: true,
                                    TruckNo: widget.loadAllDataModel.truckNo,
                                    totalDistance: widget.totalDistance,
                                    device: widget.device,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FastagButton(
                                    truckNo:
                                        widget.loadAllDataModel.driverPhoneNum,
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                      visibleWidget: documentUploadScreenWeb(
                                        bookingId: widget
                                            .loadAllDataModel.bookingId
                                            .toString(),
                                        loadDetailsScreenModel:
                                            widget.loadDetailsScreenModel,
                                        truckNo:
                                            widget.loadAllDataModel.truckNo,
                                        loadingPoint: widget
                                            .loadAllDataModel.loadingPointCity,
                                        unloadingPoint: widget.loadAllDataModel
                                            .unloadingPointCity,
                                        transporterName: widget
                                            .loadAllDataModel.transporterName,
                                        transporterPhoneNum: widget
                                            .loadAllDataModel
                                            .transporterPhoneNum,
                                        driverPhoneNum: widget
                                            .loadAllDataModel.driverPhoneNum,
                                        driverName:
                                            widget.loadAllDataModel.driverName,
                                        bookingDate:
                                            widget.loadAllDataModel.bookingDate,
                                        gpsDataList: widget.gpsDataList,
                                        totalDistance: widget.totalDistance,
                                        loadAllDataModel:
                                            widget.loadAllDataModel,
                                      ),
                                      index: 1000,
                                      selectedIndex:
                                          screens.indexOf(ordersScreen),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: kLiveasyColor,
                                size: 15,
                                weight: 700,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 15,
                              style: const ButtonStyle(
                                padding: MaterialStatePropertyAll<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )//Below code is used for mobile
        : GestureDetector(
            onTap: () {
              print(widget.loadDetailsScreenModel?.noOfTyres);
              Get.to(documentUploadScreen(
                loadAllDataModel: widget.loadAllDataModel,
                bookingId: widget.loadAllDataModel.bookingId.toString(),
                loadDetailsScreenModel: widget.loadDetailsScreenModel,
                truckNo: widget.loadAllDataModel.truckNo,
                loadingPoint: widget.loadAllDataModel.loadingPointCity,
                unloadingPoint: widget.loadAllDataModel.unloadingPointCity,
                transporterName: widget.loadAllDataModel.transporterName,
                transporterPhoneNum:
                    widget.loadAllDataModel.transporterPhoneNum,
                driverPhoneNum: widget.loadAllDataModel.driverPhoneNum,
                driverName: widget.loadAllDataModel.driverName,
                bookingDate: widget.loadAllDataModel.bookingDate,
                gpsDataList: widget.gpsDataList,
                totalDistance: widget.totalDistance,
              ));
            },
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(space_2),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoadLabelValueRowTemplate(
                                value: widget.loadAllDataModel.bookingDate,
                                label: 'bookingDate'.tr
                                // AppLocalizations.of(context)!.bookingDate
                                ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        SizedBox(
                          height: space_2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoadEndPointTemplate(
                                text: widget.loadAllDataModel.loadingPointCity,
                                endPointType: 'loading'),
                            Container(
                                padding: EdgeInsets.only(left: 2),
                                height: space_6,
                                width: space_12,
                                child: CustomPaint(
                                  foregroundPainter: LinePainter(),
                                )),
                            LoadEndPointTemplate(
                                text:
                                    widget.loadAllDataModel.unloadingPointCity,
                                endPointType: 'unloading'),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: space_4),
                          child: Column(
                            children: [
                              LoadLabelValueRowTemplate(
                                  value: widget.loadAllDataModel.truckNo,
                                  label: 'truckNumber'.tr
                                  // AppLocalizations.of(context)!.truckNumber
                                  ),
                              LoadLabelValueRowTemplate(
                                  value: widget.loadAllDataModel.driverName,
                                  label: 'driverName'.tr
                                  // AppLocalizations.of(context)!.driverName
                                  ),
                              LoadLabelValueRowTemplate(
                                  value:
                                      "Rs.${widget.loadAllDataModel.rate}/${widget.loadAllDataModel.unitValue}",
                                  label: 'price'.tr
                                  // AppLocalizations.of(context)!.price
                                  ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: space_5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   margin: EdgeInsets.only(right: space_1),
                                //   child: Image(
                                //       height: 16,
                                //       width: 23,
                                //       color: black,
                                //       image: AssetImage(
                                //           'assets/icons/buildingIcon.png')),
                                // ),
                                // Text(
                                //   textOverflowEllipsis(
                                //       "widget.loadAllDataModel.companyName"
                                //           .toString(),
                                //       20),
                                //   style: TextStyle(
                                //     color: liveasyBlackColor,
                                //     fontWeight: mediumBoldWeight,
                                //   ),
                                // )
                              ],
                            ),
                            SizedBox(
                              height: space_2,
                            ),
                            CallButton(
                              directCall: false,
                              transporterPhoneNum:
                                  widget.loadAllDataModel.transporterPhoneNum,
                              driverPhoneNum:
                                  widget.loadAllDataModel.driverPhoneNum,
                              driverName: widget.loadAllDataModel.driverName,
                              transporterName:
                                  widget.loadAllDataModel.companyName,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: contactPlaneBackground,
                    padding: EdgeInsets.symmetric(
                      vertical: space_2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TrackButton(
                          gpsData: widget.gpsDataList[0],
                          truckApproved: true,
                          TruckNo: widget.loadAllDataModel.truckNo,
                          totalDistance: widget.totalDistance,
                          device: widget.device,
                        ),
                        CompletedButtonOrders(
                            bookingId:
                                widget.loadAllDataModel.bookingId.toString(),
                            fontSize: size_7),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

  //   if (widget.loadAllDataModel.driverName == null) {
  //     widget.loadAllDataModel.driverName = "NA";
  //   }
  //   widget.loadAllDataModel.driverName =
  //       widget.loadAllDataModel.driverName!.length >= 20
  //           ? widget.loadAllDataModel.driverName!.substring(0, 18) + '..'
  //           : widget.loadAllDataModel.driverName;
  //   // if (widget.loadAllDataModel.companyName == null) {}
  //   // widget.loadAllDataModel.companyName =
  //   //     widget.loadAllDataModel.companyName!.length >= 35
  //   //         ? widget.loadAllDataModel.companyName!.substring(0, 33) + '..'
  //   //         : widget.loadAllDataModel.companyName;

  //   widget.loadAllDataModel.unitValue =
  //       widget.loadAllDataModel.unitValue == "PER_TON"
  //           ? "tonne".tr
  //           : "truck".tr;

  //   return GestureDetector(
  //     onTap: () {
  //       Get.to(ShipperDetails(
  //         bookingId: widget.loadAllDataModel.bookingId.toString(),
  //         // truckType: truckType,
  //         // noOfTrucks: noOfTrucks,
  //         // productType: productType,
  //         loadingPoint: widget.loadAllDataModel.loadingPointCity,
  //         unloadingPoint: widget.loadAllDataModel.unloadingPointCity,
  //         rate: widget.loadAllDataModel.rate,
  //         vehicleNo: widget.loadAllDataModel.truckNo,
  //         // shipperPosterCompanyApproved: companyApproved,
  //         // shipperPosterCompanyName: companyName,
  //         // shipperPosterLocation: posterLocation,
  //         // shipperPosterName: posterName,
  //         // transporterPhoneNum: transporterPhoneNumber,
  //         driverPhoneNum: widget.loadAllDataModel.driverPhoneNum,
  //         driverName: widget.loadAllDataModel.driverName,
  //         // transporterName: companyName,
  //         trackApproved: true,
  //       ));
  //       // Get.to(() => OnGoingLoadDetails(
  //       //       loadALlDataModel: widget.loadAllDataModel,
  //       //       trackIndicator: false,
  //       //     ));
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(bottom: space_3),
  //       child: Card(
  //         elevation: 5,
  //         child: Column(
  //           children: [
  //             Container(
  //               margin: EdgeInsets.all(space_4),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         '${"bookingDate".tr} : ${widget.loadAllDataModel.bookingDate}',
  //                         style: TextStyle(
  //                           fontSize: size_6,
  //                           color: veryDarkGrey,
  //                         ),
  //                       ),
  //                       Icon(Icons.arrow_forward_ios_sharp),
  //                     ],
  //                   ),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       LoadEndPointTemplate(
  //                           text: widget.loadAllDataModel.loadingPointCity,
  //                           endPointType: 'loading'),
  //                       Container(
  //                           padding: EdgeInsets.only(left: 2),
  //                           height: space_3,
  //                           width: space_12,
  //                           child: CustomPaint(
  //                             foregroundPainter: LinePainter(height: space_3),
  //                           )),
  //                       LoadEndPointTemplate(
  //                           text: widget.loadAllDataModel.unloadingPointCity,
  //                           endPointType: 'unloading'),
  //                     ],
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: space_4),
  //                     child: Column(
  //                       children: [
  //                         NewRowTemplate(
  //                           label: "truckNumber".tr,
  //                           value: widget.loadAllDataModel.truckNo,
  //                           width: 78,
  //                         ),
  //                         NewRowTemplate(
  //                             label: "driverName".tr,
  //                             value: widget.loadAllDataModel.driverName),
  //                         NewRowTemplate(
  //                           label: "price".tr,
  //                           // value: widget.loadAllDataModel.rate,
  //                           value:
  //                               '${widget.loadAllDataModel.rate}/${widget.loadAllDataModel.unitValue}',
  //                           width: 78,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Container(
  //                   //   margin: EdgeInsets.only(top: space_4),
  //                   //   child: Row(
  //                   //     children: [
  //                   //       Container(
  //                   //         margin: EdgeInsets.only(right: space_1),
  //                   //         child: Image(
  //                   //             height: 16,
  //                   //             width: 23,
  //                   //             color: black,
  //                   //             image:
  //                   //                 AssetImage('assets/icons/TruckIcon.png')),
  //                   //       ),
  //                   //       Text(
  //                   //         "widget.loadAllDataModel.companyName!",
  //                   //         style: TextStyle(
  //                   //           color: liveasyBlackColor,
  //                   //           fontWeight: mediumBoldWeight,
  //                   //         ),
  //                   //       )
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               color: contactPlaneBackground,
  //               padding: EdgeInsets.symmetric(
  //                 vertical: space_2,
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   // print(gpsDataList[0]),
  //                   TrackButton(
  //                     gpsData: gpsDataList[0],
  //                     truckApproved: true,
  //                     TruckNo: "widget.loadAllDataModel.truckNo",
  //                     totalDistance: "totalDistance",
  //                   ),
  //                   CallButton(
  //                     directCall: false,
  //                     transporterPhoneNum:
  //                         "widget.loadAllDataModel.transporterPhoneNum",
  //                     driverPhoneNum: "widget.loadAllDataModel.driverPhoneNum",
  //                     driverName: "widget.loadAllDataModel.driverName",
  //                     transporterName: "widget.loadAllDataModel.companyName",
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

//   void getMyTruckPosition() async {
//     var devices =
//         await getDeviceByDeviceId(widget.loadAllDataModel.deviceId.toString());
//     var gpsDataAll = await getPositionByDeviceId(
//         widget.loadAllDataModel.deviceId.toString());

//     devicelist.clear();

//     for (var device in devices) {
//       setState(() {
//         devicelist.add(device);
//       });
//     }

//     gpsList = List.filled(devices.length, null, growable: true);

//     for (int i = 0; i < gpsDataAll.length; i++) {
//       getGPSData(gpsDataAll[i], i);
//     }

//     setState(() {
//       gpsDataList = gpsList;
//       print("GPSDATALIST....");
//       print(gpsDataList);
//       getMyTruckPostionBoolValue = true;
//     });
//     // return getMyTruckPostionBoolValue;
//   }

//   void getGPSData(var gpsData, int i) async {
//     gpsList.removeAt(i);

//     gpsList.insert(i, gpsData);
//   }

//   void initFunction() async {
//     var gpsRoute1 = await getTraccarSummaryByDeviceId(
//         deviceId: widget.loadAllDataModel.deviceId, from: from, to: to);
//     setState(() {
//       totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
//       initfunctionBoolValue = true;
//     });
//     print('in init');
//     // return initfunctionBoolValue;
//   }
// }
