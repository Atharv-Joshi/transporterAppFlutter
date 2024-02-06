import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/loadOperatorInfo.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/updateBookingDetailsScreen.dart';
import 'package:liveasy/screens/updateDriverScreen.dart';
import 'package:liveasy/screens/updateTruckScreen.dart';
import 'package:liveasy/widgets/HeadingTextWidgetBlue.dart';
import 'package:liveasy/widgets/buttons/sendConsentButton.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/widgets/buttons/updateButtonSendRequest.dart';

//Whatever the user chooses from the previous screen is displayed in this screens
class UpdateBookingDetails extends StatefulWidget {
  String? selectedTruck;
  int? selectedDeviceId;
  String? driverName, mobileNo;
  OngoingCardModel loadAllDataModel;

  UpdateBookingDetails({
    this.selectedTruck,
    this.selectedDeviceId,
    this.driverName,
    this.mobileNo,
    required this.loadAllDataModel,
  });

  @override
  _UpdateBookingDetailsState createState() => _UpdateBookingDetailsState();
}

class _UpdateBookingDetailsState extends State<UpdateBookingDetails> {
  String? transporterId;
  String? mobileno;
  TransporterIdController transporterIdController = TransporterIdController();
  GetStorage tidstorage = GetStorage('TransporterIDStorage');
  String? selectedOperator;
  List<String> operatorOptions = [
    'Airtel',
    'Vodafone',
    'Jio',
  ];
  @override
  void initState() {
    super.initState();
    // Load operator options from the API response or set default options.
    loadOperatorInfo(widget.mobileNo, updateSelectedOperator);
  }

  //This function is used to fetch the operator info select it by default from the dropdown
  void updateSelectedOperator(String newOperator) {
    setState(() {
      selectedOperator = newOperator;
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text('Hello World'));
    return (kIsWeb && (Responsive.isDesktop(context)))
    //Ui for desktop
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                        selectedIndex:
                                            screens.indexOf(ordersScreen),
                                        index: 1000,
                                        visibleWidget:
                                            UpdateBookingDetailsScreen(
                                          loadAllDataModel:
                                              widget.loadAllDataModel,
                                        ))));
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: space_5,
                        ),
                        Container(
                          child: Text(
                            'Confirm Booking Details',
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
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(horizontal: space_2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Truck Number",
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
                                //Option to select truck number , on press navigates to selectedTruckScreen.
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardScreen(
                                            selectedIndex:
                                                screens.indexOf(auctionScreen),
                                            index: 1000,
                                            visibleWidget: UpdateTruckScreen(
                                              driverName: widget.driverName,
                                              driverPhoneNo: widget.mobileNo,
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
                                      child: widget.selectedTruck.toString() ==
                                              "null"
                                          ? Text(
                                              "",
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: textLightColor,
                                              ),
                                            )
                                          : Text(
                                              widget.selectedTruck.toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: black,
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
                                          color: const Color(0xFF152968),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: space_6,
                            ),
                            Text(
                              "Driver Number",
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
                                //Option to select driver name and number, navigates to selectedDriverScreen to select.
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardScreen(
                                            selectedIndex:
                                                screens.indexOf(ordersScreen),
                                            index: 1000,
                                            visibleWidget: UpdateDriverScreen(
                                              selectedDeviceId:
                                                  widget.selectedDeviceId,
                                              selectedTruck:
                                                  widget.selectedTruck,
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
                                      child:
                                          widget.driverName.toString() == "null"
                                              ? Text(
                                                  "",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: textLightColor,
                                                  ),
                                                )
                                              : Text(
                                                  "${widget.driverName}-${widget.mobileNo}",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    color: black,
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
                                          color: const Color(0xFF152968),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            //DropDown to select the operators for sim based tracking
                            SizedBox(
                              height: space_2,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: space_2, top: space_4),
                              child: Row(
                                children: [
                                  Text(
                                    'Sim-Tracking Consent',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Color(0xFF152968),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 450),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(space_1),
                                        border: Border.all(
                                            color: Color(0xFF152968)),
                                      ),
                                      child: DropdownButton<String>(
                                        key: UniqueKey(),
                                        value: selectedOperator,
                                        icon: Icon(
                                            Icons.keyboard_arrow_down_sharp),
                                        style: const TextStyle(color: black),
                                        underline: Container(
                                          height: 2,
                                          color: white,
                                        ),
                                        onChanged: (String? newValue) {
                                          //A dropDown menu to select operator name.
                                          setState(() {
                                            selectedOperator = newValue!;
                                          });
                                        },
                                        items: operatorOptions
                                            .map((String operator) {
                                          return DropdownMenuItem<String>(
                                            child: Padding(
                                              padding: EdgeInsets.all(space_2),
                                              child: Container(
                                                width: 100,
                                                height: 28,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/simIcon.png',
                                                      width: 17,
                                                      height: 17,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: space_2),
                                                      child: Text(
                                                        operator,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: size_7),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            value: operator,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: space_7),
                                    child: SendConsentButton(
                                      //consent request is sent to the particular number selected.
                                      mobileno: widget.mobileNo,
                                      selectedOperator: selectedOperator,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: space_10,
                                  right: space_30,
                                ),
                                child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  //confirms the booking when on pressed.
                                  child: UpdateButtonSendRequest(
                                    selectedDriverName: widget.driverName,
                                    selectedDriverPhoneno: widget.mobileNo,
                                    selectedDeviceId: widget.selectedDeviceId,
                                    loadAllDataModel: widget.loadAllDataModel,
                                    truckId: widget.selectedTruck,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
    //Ui for Mobile
        : Scaffold(
            appBar: AppBar(
              title: HeadingTextWidgetBlue('confirmBookingDetails'.tr),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: statusBarColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: space_2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: space_4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: ((context) {
                            return UpdateTruckScreen(
                              driverName: widget.driverName,
                              driverPhoneNo: widget.mobileNo,
                              loadAllDataModel: widget.loadAllDataModel,
                            );
                          })));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: space_3, horizontal: space_3),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 0.8,
                                color: black,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "  Truck",
                                        style: TextStyle(
                                          fontSize: size_10,
                                          color: darkBlueColor,
                                          fontWeight: mediumBoldWeight,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              left: space_2 - 2,
                                              right: space_1 - 2,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: white,
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: black,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 25, top: 15),
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: widgetBackGroundColor,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: widget.selectedTruck.toString() ==
                                              "null"
                                          ? Text(
                                              " ",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: size_10),
                                            )
                                          : Text(
                                              widget.selectedTruck.toString(),
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: size_10),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return UpdateDriverScreen(
                              selectedDeviceId: widget.selectedDeviceId,
                              selectedTruck: widget.selectedTruck,
                              loadAllDataModel: widget.loadAllDataModel,
                            );
                          })));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: space_3, horizontal: space_3),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 0.8,
                                color: black,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "  Driver",
                                        style: TextStyle(
                                          fontSize: size_10,
                                          color: darkBlueColor,
                                          fontWeight: mediumBoldWeight,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              left: space_2 - 2,
                                              right: space_1 - 2,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: white,
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: black,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 25, top: 15),
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: widgetBackGroundColor,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child:
                                          widget.driverName.toString() == "null"
                                              ? Text(
                                                  "",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: size_10),
                                                )
                                              : Text(
                                                  "${widget.driverName}-${widget.mobileNo}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: size_10),
                                                ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: space_4, top: space_4),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(space_1),
                                border: Border.all(color: Colors.black),
                              ),
                              child: DropdownButton<String>(
                                key: UniqueKey(),
                                value: selectedOperator,
                                icon: Icon(Icons.keyboard_arrow_down_sharp),
                                style: const TextStyle(color: black),
                                underline: Container(
                                  height: 2,
                                  color: white,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOperator = newValue!;
                                  });
                                },
                                items: operatorOptions.map((String operator) {
                                  return DropdownMenuItem<String>(
                                    child: Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Container(
                                        width: 100,
                                        height: 28,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/simIcon.png',
                                              width: 17,
                                              height: 17,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: space_2),
                                              child: Text(
                                                operator,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: size_7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    value: operator,
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: space_7),
                              child: SendConsentButton(
                                mobileno: widget.mobileNo,
                                selectedOperator: selectedOperator,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: UpdateButtonSendRequest(
                              selectedDriverName: widget.driverName,
                              selectedDriverPhoneno: widget.mobileNo,
                              selectedDeviceId: widget.selectedDeviceId,
                              loadAllDataModel: widget.loadAllDataModel,
                              truckId: widget.selectedTruck,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
