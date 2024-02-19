import 'dart:ui';

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
                            'Owner Name ${_vehicleDetails?.ownerName}',
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
                            text1: '${_vehicleDetails?.rcPermitValidUpto}',
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
              padding: EdgeInsets.all(space_3),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: space_6, top: space_2),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor,
                            size: size_11,
                          ),
                        ),
                        SizedBox(
                          width: space_1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Load",
                              style: GoogleFonts.montserrat(
                                  fontSize: size_8,
                                  fontWeight: mediumBoldWeight,
                                  color: darkBlueColor,
                                  letterSpacing: -0.408),
                            ),
                            Text(
                              "On-Going Details",
                              style: GoogleFonts.montserrat(
                                  fontSize: size_6,
                                  fontWeight: regularWeight,
                                  color: greyColor,
                                  letterSpacing: -0.408),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: darkBlueColor,
                    ),
                    child: Center(
                      child: Text(
                        "Vehicle Details",
                        style: GoogleFonts.montserrat(
                          fontWeight: mediumBoldWeight,
                          color: white,
                          fontSize: size_10,
                        ),
                      ),
                    ),
                  ),
                  _vehicleDetails == null
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: darkBlueColor,
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: isTablet
                                  ? EdgeInsets.all(space_3)
                                  : EdgeInsets.all(space_1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 21,
                                ),
                                child: Material(
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          greyishWhiteColor,
                                          white,
                                        ],
                                        stops: [0.5, 0.5],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 8,
                                        bottom: 12,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Vehicle Number",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.registrationNumber}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Owner Name",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.ownerName}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Vehicle Model",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.vehicleModel}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Vehicle Maker",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.vehicleMaker}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Vehicle Class and Type",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.vehicleClass}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Ownership",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.ownership}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Registration Date",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.registrationDate}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC No. Date Upto",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.registrationValidUpto}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Status Code",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.statusMessage}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Status",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcStatus}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Permanent NO.",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcPermanentNo}',
                                                  maxLines: 3,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "...",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Mobile No.",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcMobileNo}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Fule Desc.",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.fuelType}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC NP Issued by.",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcNpIssuedBy}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Permit Valid From",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcPermitValidFrom}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "RC Permit Valid Upto",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcPermitValidUpto}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Vehicle Maker Model",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.vehicleModel}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Insuance Company",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.rcInsuranceCompany}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Insurance Policy",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.insurancePolicyNo}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Insurance Validity",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.insuranceValidUpto}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Insurance Number",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.insurancePolicyNo}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Pollution Cert. Validity",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.pollutionCertValidUpto}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Pollution Cert. Number",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${_vehicleDetails?.pollutionCertNo}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: size_8,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}
