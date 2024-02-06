import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/responsive.dart';
import '../constants/color.dart';
import '../constants/spaces.dart';
import '../functions/ulipAPIs/vahanApis.dart';
import '../models/vahanApisModel.dart';
import '../widgets/buttons/helpButton.dart';
import '../widgets/vahanDetailsWidget.dart';

class VahanScreen extends StatefulWidget {
  final String? truckNo;
  VahanScreen({
    required this.truckNo,
  });

  @override
  State<VahanScreen> createState() => _VahanScreenState();
}

class _VahanScreenState extends State<VahanScreen> {
  VehicleDetails? _vehicleDetails;

  @override
  void initState() {
    super.initState();
    // Calling API function to fetch vehicle details here
    fetchVehicleDetails(widget.truckNo!).then((vehicleDetails) {
      setState(() {
        _vehicleDetails = vehicleDetails;
      });
    }).catchError((error) {
      // Handle the error, e.g., show an error message
      print("Error fetching vehicle details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);

    return isMobile
    //Ui for mobile
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: white,
              title: Text(
                '${widget.truckNo}',
                style: TextStyle(
                    color: darkBlueColor, fontWeight: FontWeight.bold),
              ),
              titleSpacing: 0,
              leading: Container(
                margin: EdgeInsets.all(space_2),
                child: CupertinoNavigationBarBackButton(
                  color: darkBlueColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(space_2),
                  child: HelpButtonWidget(),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(space_3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_vehicleDetails ==
                        null) // Show circular progress indicator while loading
                      Center(
                        child: CircularProgressIndicator(
                          color: darkBlueColor,
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner Name'),
                          Text(
                            '${_vehicleDetails?.ownerName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(2, space_1, 2, space_2),
                            child: Container(
                              color: black,
                              width: width,
                              height: 0.5,
                            ),
                          ),
                          // custom widget is used to display all the details
                          VahanDetailsWidget(
                            title1: 'Vehicle Model',
                            text1: '${_vehicleDetails?.vehicleModel}',
                            title2: 'Vehicle Maker',
                            text2: '${_vehicleDetails?.vehicleMaker}',
                            isText1Bold: true,
                          ),
                          VahanDetailsWidget(
                            title1: 'Vehicle Financer',
                            text1: '${_vehicleDetails?.vehicleFinancer}',
                            title2: 'Vehicle Class, Body Type',
                            text2: '${_vehicleDetails?.vehicleClass}',
                            text3: '${_vehicleDetails?.bodyType}',
                            isText1Bold: true,
                          ),
                          VahanDetailsWidget(
                              title1: 'RC Status',
                              text1: '${_vehicleDetails?.rcStatus}',
                              title2: 'Ownership',
                              text2: '${_vehicleDetails?.ownership}',
                              text1Color: shareButtonColor),
                          VahanDetailsWidget(
                            title1: 'RC Valid Upto',
                            text1: '${_vehicleDetails?.rcValidUpto}',
                            title2: 'RC Issue Date',
                            text2: '${_vehicleDetails?.rcIssueDate}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Pollution Cert Valid Upto',
                            text1: '${_vehicleDetails?.pollutionCertValidUpto}',
                            title2: 'Pollution Cert No',
                            text2: '${_vehicleDetails?.pollutionCertNo}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Insurance Valid Upto',
                            text1: '${_vehicleDetails?.insuranceValidUpto}',
                            title2: 'Insurance Policy No',
                            text2: '${_vehicleDetails?.insurancePolicyNo}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Permit Type',
                            text1: '${_vehicleDetails?.permitType}',
                            title2: 'Permit No',
                            text2: '${_vehicleDetails?.permitNumber}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Permit Valid Upto',
                            text1: '${_vehicleDetails?.permitValidUpto}',
                            title2: 'Permit Issue Date',
                            text2: '${_vehicleDetails?.permitIssueDate}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Seat Capacity',
                            text1: '${_vehicleDetails?.seatCapacity}',
                            isText1Bold: true,
                            title2: 'Engine Capacity',
                            text2: '${_vehicleDetails?.engineCapacity}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Fuel Type',
                            text1: '${_vehicleDetails?.fuelType}',
                            isText1Bold: true,
                            title2: 'Fuel Norms',
                            text2: '${_vehicleDetails?.fuelNorms}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Vehicle Color',
                            text1: '${_vehicleDetails?.vehicleColor}',
                            title2: 'Unloaded(खाली) Weight',
                            text2: '${_vehicleDetails?.unloadedWeight}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Engine No',
                            text1: '${_vehicleDetails?.engineNumber}',
                            title2: 'Chasis No',
                            text2: '${_vehicleDetails?.chassisNumber}',
                          ),
                          VahanDetailsWidget(
                            title1: 'Registration Authority',
                            text1: '${_vehicleDetails?.registeredAuthority}',
                            title2: 'Tax Valid Upto',
                            text2: '${_vehicleDetails?.taxValidUpto}',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )
    //Ui for web
        : Scaffold(
            backgroundColor: docScreenColor,
            body: Padding(
              padding: EdgeInsets.all(isMobile ? 10 : 20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(space_3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_vehicleDetails ==
                          null) // Show circular progress indicator while loading
                        Center(
                          child: CircularProgressIndicator(
                            color: darkBlueColor,
                          ),
                        )
                      else
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: space_6, top: space_2),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: darkBlueColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: space_1,
                                    ),
                                    Text(
                                      "Load",
                                      style: GoogleFonts.montserrat(
                                          fontSize: size_10 - 1,
                                          fontWeight: boldWeight,
                                          color: darkBlueColor,
                                          letterSpacing: -0.408),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(space_5),
                                child: Material(
                                  elevation: 5,
                                  child: SizedBox(
                                    height: height / 9,
                                    width: width * 0.9,
                                    child: Container(
                                      color: white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: space_4,
                                            horizontal: width * 0.01),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: space_4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: isMobile
                                                        ? space_2
                                                        : space_4),
                                                child: Text(
                                                  "Vehicle Details",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_10,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Image.asset(
                                                'assets/icons/updateDriver.png',
                                                width: space_4 + 2,
                                                height: space_4 + 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(space_5),
                                child: Material(
                                  elevation: 5,
                                  child: SizedBox(
                                    height: height / 3.5,
                                    width: width * 0.9,
                                    child: Container(
                                      color: white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: space_4,
                                            horizontal: width * 0.01),
                                        child: Padding(
                                            padding:
                                                EdgeInsets.only(left: space_4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/vahan.png'),
                                                  height: height / 4,
                                                  width: width / 4,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 53,
                                                      width: 248,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: black,
                                                            width: 1,
                                                          ),
                                                          color: Color(
                                                              0xffF5F5F5)),
                                                      child: Center(
                                                        child: Text(
                                                          "${widget.truckNo}",
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: isTablet
                                                                  ? size_8
                                                                  : size_10,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: space_7,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Owner Name",
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: isTablet
                                                                  ? size_8
                                                                  : size_10,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                            width: space_3),
                                                        Text(
                                                          '${_vehicleDetails?.ownerName}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: isMobile
                                                                      ? size_8
                                                                      : size_10,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: space_7,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Vehicel Model",
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: isTablet
                                                                  ? size_8
                                                                  : size_10,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                            width: space_3),
                                                        Text(
                                                          '${_vehicleDetails?.vehicleModel}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: isTablet
                                                                      ? size_8
                                                                      : size_10,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: space_7,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Vehicle Maker",
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: isTablet
                                                                  ? size_8
                                                                  : size_10,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                            width: space_3),
                                                        Text(
                                                          '${_vehicleDetails?.vehicleMaker}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: isTablet
                                                                      ? size_8
                                                                      : size_10,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: isTablet
                                    ? EdgeInsets.all(space_3)
                                    : EdgeInsets.all(space_1),
                                child: SizedBox(
                                  height: height / 1.6 - space_2,
                                  width: width * 0.9,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: space_1,
                                        horizontal: width * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      space_2),
                                              color: white,
                                            ),
                                            width: isTablet
                                                ? width / 3.8
                                                : width / 3.2,
                                            height: height,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  space_8,
                                                  space_6,
                                                  space_6,
                                                  space_6),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: space_3,
                                                    ),
                                                    Text(
                                                      "Vehicle Class and Type",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "Ownership",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "RC Status",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "RC Validity",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "RC Issue Date",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "Pollution Cert. Validity",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "Pollution Cert. Number",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "Insurance Validity",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                    SizedBox(
                                                      height: space_8,
                                                    ),
                                                    Text(
                                                      "Insurance Number",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                      width: width * 0.35,
                                                      height: 1,
                                                      color: vahangrey,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: space_2,
                                        ),
                                        Material(
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      space_2),
                                              color: white,
                                            ),
                                            width: isTablet
                                                ? width / 2.95
                                                : width / 2.05,
                                            height: height,
                                            child: Padding(
                                              padding: EdgeInsets.all(space_6),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: space_3,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.vehicleClass}, ${_vehicleDetails?.bodyType}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.ownership}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Row(
                                                      children: [
                                                        '${_vehicleDetails?.rcStatus}' ==
                                                                "ACTIVE"
                                                            ? Image(
                                                                image: AssetImage(
                                                                    "assets/icons/running.png"),
                                                                height: size_7,
                                                                width: size_7,
                                                              )
                                                            : Image(
                                                                image: AssetImage(
                                                                    "assets/icons/red_circle.png"),
                                                                height: size_7,
                                                                width: size_7,
                                                              ),
                                                        SizedBox(
                                                            width: space_1),
                                                        Text(
                                                          '${_vehicleDetails?.rcStatus}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize:
                                                                      size_8,
                                                                  color:
                                                                      darkBlueColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.rcValidUpto}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.rcIssueDate}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.pollutionCertValidUpto}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.pollutionCertNo}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.insuranceValidUpto}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_8 + 1,
                                                    ),
                                                    Text(
                                                      '${_vehicleDetails?.insurancePolicyNo}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: size_8,
                                                              color:
                                                                  darkBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
            ),
          );
  }
}
