import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    super.initState();
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
    //The booking date is converted into MMM dd yyyy from the below code
    String formattedDate = DateFormat('MMM dd yyyy').format(
      DateFormat('dd-MM-yyyy')
          .parse(widget.loadAllDataModel.bookingDate ?? 'Null'),
    );
    //Below code is used to manage the string length within the code
    widget.loadAllDataModel.truckType;
    widget.loadAllDataModel.productType;
    widget.loadAllDataModel.unitValue;
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
    // Is we get "PER_TON" from the apis the value for unitvalue will be "tonne"
    // else "truck" will be assigned
    widget.loadAllDataModel.unitValue =
        widget.loadAllDataModel.unitValue == "PER_TON"
            ? "tonne".tr
            : "truck".tr;
    //the below code will be executed for the web
    return (kIsWeb && Responsive.isDesktop(context))
        ? Expanded(
            child: ElevatedButton(
              onPressed: () {
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
              }, //OngoingCard for web
              style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ))),
              //the below code basically creates a table like UI for showing ongoing Details
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                formattedDate,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: textFontSize,
                                ),
                              ))),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.loadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
                    Expanded(
                      flex: 5,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          widget.loadAllDataModel.unloadingPointCity ?? 'Null',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.truckNo}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: kLiveasyColor,
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
                    Expanded(
                      flex: 4,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.driverName}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '${widget.loadAllDataModel.rate}' ?? 'Null',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: kLiveasyColor,
                            fontWeight: FontWeight.w600,
                            fontSize: textFontSize,
                          ),
                        ),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
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
                                style: GoogleFonts.montserrat(
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: textFontSize,
                                ),
                              ))
                            ]),
                      )),
                    ),
                    const VerticalDivider(color: greyColor, thickness: 1),
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
                                  //Track button for tracking the vehicle
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
                                  //Fastag button for tracking the vehicle from fastag
                                  FastagButton(
                                    truckNo: widget.loadAllDataModel.truckNo,
                                    loadingPoint: widget
                                        .loadAllDataModel.loadingPointCity,
                                    unloadingPoint: widget
                                        .loadAllDataModel.unloadingPointCity,
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                          //While clicking on the card documentUploadScreenWeb screen opens
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
          ) //Below code is used for mobile
        : GestureDetector(
            onTap: () {
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
