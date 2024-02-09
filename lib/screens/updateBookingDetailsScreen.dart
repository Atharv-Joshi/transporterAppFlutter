import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TransporterOrders/onGoingScreenOrders.dart';
import 'package:liveasy/screens/updateDriverScreen.dart';
import 'package:liveasy/screens/updateTruckScreen.dart';
import 'package:liveasy/widgets/HeadingTextWidgetBlue.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';

import '../models/onGoingCardModel.dart';
import 'HelpScreen.dart';

//This screen is displayed just after clicking the edit button in the documentUploadScreen
class UpdateBookingDetailsScreen extends StatefulWidget {
  List? truckModelList;
  List? driverModelList;
  OngoingCardModel loadAllDataModel;

  UpdateBookingDetailsScreen(
      {this.truckModelList,
      this.driverModelList,
      required this.loadAllDataModel});

  @override
  _UpdateBookingDetailsScreenState createState() =>
      _UpdateBookingDetailsScreenState();
}

class _UpdateBookingDetailsScreenState
    extends State<UpdateBookingDetailsScreen> {
  String? selectedTruck;
  String? selectedDriver;
  String? selectedDriverName;

  TransporterIdController transporterIdController = Get.find();

  late List? driverList = [];
  late List? truckList = [];

  MapUtil mapUtil = MapUtil();

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {
      var page = ModalRoute.of(context)!.settings.name;
      Get.to(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb && (Responsive.isDesktop(context)))
    //Ui for Web
        ? Scaffold(
            backgroundColor: teamBar,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: space_2),
                child: Column(
                  children: [
                    SizedBox(
                      height: space_4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                          visibleWidget: OngoingScreenOrders(),
                                          index: 1000,
                                          selectedIndex:
                                              screens.indexOf(ordersScreen),
                                        )));
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: space_5,
                        ),
                        Container(
                          child: Text(
                            'Update Booking Details',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: EdgeInsets.only(left: space_20, top: space_15),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: space_8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select A Truck",
                            style: GoogleFonts.montserrat(
                              fontWeight: mediumBoldWeight,
                              fontSize: 24,
                              color: const Color(0xFF152968),
                            ),
                          ),
                          SizedBox(
                            height: space_2,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                          selectedIndex:
                                              screens.indexOf(ordersScreen),
                                          index: 1000,
                                          visibleWidget: UpdateTruckScreen(
                                            loadAllDataModel:
                                                widget.loadAllDataModel,
                                          ))));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: space_20,
                                bottom: space_2,
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(radius_1 + 2),
                                border: Border.all(
                                  color: widgetBackGroundColor,
                                ),
                                color: widgetBackGroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: space_2),
                                    child: Text(
                                      'Enter or select a truck number',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: textLightColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                        right: space_2 - 2,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: darkBlueColor,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(bottom: space_2, top: space_14),
                            child: Text(
                              "Select A Driver",
                              style: GoogleFonts.montserrat(
                                fontWeight: mediumBoldWeight,
                                fontSize: 24,
                                color: darkBlueColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                          selectedIndex:
                                              screens.indexOf(ordersScreen),
                                          index: 1000,
                                          visibleWidget: UpdateDriverScreen(
                                            loadAllDataModel:
                                                widget.loadAllDataModel,
                                          ))));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: space_20, bottom: space_2),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(radius_1 + 2),
                                border:
                                    Border.all(color: widgetBackGroundColor),
                                color: widgetBackGroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: space_2),
                                    child: Text(
                                      'Enter or select a driver',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: textLightColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                        right: space_2 - 2,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: darkBlueColor,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: space_20, right: space_30),
                            padding: EdgeInsets.only(bottom: space_6 + 0.5),
                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radius_1)),
                                color: darkBlueColor,
                                child: Container(
                                  color: darkBlueColor,
                                  height: 50,
                                  width: 230,
                                  child: Center(
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size_12,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
    //Ui for Mobile
        : Scaffold(
            backgroundColor: statusBarColor,
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: space_2),
                child: Column(
                  children: [
                    SizedBox(
                      height: space_4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButtonWidget(),
                        SizedBox(
                          width: space_2,
                        ),
                        HeadingTextWidgetBlue('enterBookingDetails'.tr),
                        SizedBox(
                          width: space_4,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpScreen()),
                              );
                            },
                            icon: Icon(
                              Icons.headset_mic_outlined,
                              color: const Color(0xFF152968),
                            ),
                            label: Text(
                              "Help".tr,
                              style: TextStyle(
                                  color: const Color(0xFF152968),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: space_5, top: space_15),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: space_2),
                      child: Text(
                        "Select Truck",
                        style: TextStyle(
                            fontSize: size_9,
                            fontWeight: mediumBoldWeight,
                            color: const Color(0xFF152968)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return UpdateTruckScreen(
                            loadAllDataModel: widget.loadAllDataModel,
                          );
                        })));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_2),
                        height: 50,
                        width: 356,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius_1 + 2),
                            border: Border.all(color: const Color(0xFF152968))),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: space_2 - 2,
                              right: space_2 - 2,
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${widget.loadAllDataModel.truckNo}',
                                      style: TextStyle(
                                          fontSize: size_10,
                                          fontWeight: boldWeight),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: const Color(0xFF152968),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: space_5, top: space_14),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: space_2),
                      child: Text(
                        "Select Driver",
                        style: TextStyle(
                            fontSize: size_9,
                            fontWeight: mediumBoldWeight,
                            color: const Color(0xFF152968)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return UpdateDriverScreen(
                            loadAllDataModel: widget.loadAllDataModel,
                          );
                        })));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: space_5, right: space_5, bottom: space_2),
                        height: 50,
                        width: 356,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius_1 + 2),
                            border: Border.all(color: const Color(0xFF152968))),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: space_2 - 2,
                              right: space_2 - 2,
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        '${widget.loadAllDataModel.driverName} - ${widget.loadAllDataModel.driverPhoneNum}',
                                        style: TextStyle(
                                            fontSize: size_10,
                                            fontWeight: boldWeight)),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: const Color(0xFF152968),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: space_6 + 0.5),
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radius_2)),
                            color: const Color(0xFF152968),
                            child: Container(
                              color: const Color(0xFF152968),
                              height: 54,
                              width: 242,
                              child: Center(
                                child: Text(
                                  "Proceed",
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size_12,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
