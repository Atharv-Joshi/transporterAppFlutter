import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/functions/eway_bill_api.dart';
import 'package:liveasy/screens/isolatedTransporterGetData.dart';
import 'package:liveasy/screens/track_all_fastag_screen.dart';
import 'package:liveasy/widgets/EwayBill_Table_Header.dart';
import 'package:shimmer/shimmer.dart';

import 'Eway_Bill_Details_Screen.dart';
import 'FastTagScreen.dart';

class EwayBills extends StatefulWidget {
  const EwayBills({super.key});

  @override
  State<EwayBills> createState() => _EwayBillsState();
}

class _EwayBillsState extends State<EwayBills> {
  String search = '';
  String? selectedMonth;
  DateTime fromTimestamp = DateTime(2000);
  DateTime toTimestamp = DateTime.now();
  DateTime now = DateTime.now().subtract(const Duration(hours: 5, minutes: 30));

  List<Map<String, dynamic>> EwayBills = [];
  late String from;
  late String gstNo;
  late String to;

  @override
  void initState() {
    super.initState();
    getEwayBillsData();
  }

  Future<List<Map<String, dynamic>>?> getEwayBillsData() async {
    try {
      //Get gstNo from isolatedTransporterGetData using transporterIdController
      gstNo = transporterIdController.gstNumber.value;
      //To convert the date format as required.
      from = DateFormat('yyyy-MM-dd').format(fromTimestamp);
      to = DateFormat('yyyy-MM-dd').format(toTimestamp);
      EwayBills = await EwayBill().getAllEwayBills(gstNo, from, to);
      if (EwayBills.isNotEmpty) {
        //If EwayBills data is not empty then all the data are shown, else returns null.
        return EwayBills;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.05,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'E-way Bill',
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.19),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text('Date',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: size_10,
                      color: Colors.black)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.022, bottom: screenHeight * 0.035),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 40,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Search by name, bill no',
                            hintStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: grey,
                                fontSize: screenWidth * 0.012),
                            border: InputBorder.none,
                            prefixIconColor:
                                const Color.fromARGB(255, 109, 109, 109),
                            prefixIcon: const Icon(Icons.search)),
                        onChanged: (value) {
                          setState(() {
                            search = value.toLowerCase();
                          });
                        },
                      )),
                ),
                const Expanded(flex: 10, child: SizedBox()),
                Expanded(
                  flex: 10,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedMonth,
                      items: [
                        'Today',
                        'This Week',
                        'This Month',
                        'Last Month',
                        'This Year',
                        'Custom'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle dropdown menu selection
                        setState(() {
                          selectedMonth = value;
                          // Call the respective function based on the selected value
                          handleDateRangeSelection(value!);
                          getEwayBillsData();
                          // You can perform actions based on the selected value
                          // print("Selected Month: $selectedMonth");
                        });
                      },
                      hint: Text(
                        'All Month',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      underline: Container(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen(
                                  visibleWidget:
                                      TrackAllFastagScreen(EwayData: EwayBills),
                                  index: 1000,
                                  selectedIndex:
                                      screens.indexOf(ewayBillScreen),
                                )),
                      );
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(
                          right: screenWidth * 0.03, left: screenWidth * 0.03),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: darkBlueTextColor),
                          color: white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/icons/Track.png'),
                          Text('Track All Loads',
                              style: GoogleFonts.montserrat(
                                  fontSize: size_9,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlueTextColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          EwayBillsTableHeader(context),
          Expanded(
            child: FutureBuilder(
                future: getEwayBillsData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: shimmerGrey,
                      child: SizedBox(
                        height: screenHeight,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      // An error occurred while fetching data
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      // Data is not available
                      return const Text(' ');
                    } else {
                      List<Map<String, dynamic>> filteredEwayBills =
                          EwayBills.where((bill) => bill['transporterName']
                              .toLowerCase()
                              .contains(search)).toList();
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredEwayBills.length,
                            itemBuilder: (BuildContext context, int index) {
                              final ewayBill = filteredEwayBills[index];
                              final String transporterName =
                                  ewayBill['transporterName'];
                              final String date = ewayBill['ewayBillDate'];
                              DateTime parsedDate =
                                  DateFormat("dd/MM/yyyy hh:mm:ss a")
                                      .parse(date);
                              String ewayBillDate =
                                  DateFormat("dd/MM/yyyy").format(parsedDate);
                              final String fromPlace = ewayBill['fromPlace'];
                              final String toPlace = ewayBill['toPlace'];
                              final String vehicleNumber =
                                  ewayBill['vehicleListDetails'][0]
                                      ['vehicleNo'];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardScreen(
                                              visibleWidget:
                                                  EwayBillDetailScreen(
                                                      ewayBillData: ewayBill),
                                              index: 1000,
                                              selectedIndex: screens
                                                  .indexOf(ewayBillScreen),
                                            )),
                                  );
                                },
                                child: ewayBillData(
                                    transporterName: transporterName,
                                    vehicleNo: vehicleNumber,
                                    from: fromPlace,
                                    to: toPlace,
                                    date: ewayBillDate,
                                    screenWidth: screenWidth),
                              );
                            },
                          ));
                    }
                  } else {
                    return const Text("Something went wrong");
                  }
                }),
          )
        ]);
  }

  Container ewayBillData(
      {required final String transporterName,
      required final String vehicleNo,
      required final String from,
      required final String to,
      required final String date,
      required final screenWidth}) {
    return Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: greyDivider, width: 1)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            flex: 20,
            child: Center(
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: size_9,
                  fontWeight: normalWeight,
                ),
              ),
            ),
          ),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 25,
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    Image.asset('assets/images/Route.png'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          from,
                          textAlign: TextAlign.center,
                          selectionColor: sideBarTextColor,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: size_9,
                            fontWeight: normalWeight,
                          ),
                        ),
                        Text(
                          to,
                          textAlign: TextAlign.center,
                          selectionColor: sideBarTextColor,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: size_9,
                            fontWeight: normalWeight,
                          ),
                        )
                      ],
                    )
                  ]))),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 50,
              child: Center(
                  child: Text(
                transporterName,
                textAlign: TextAlign.center,
                selectionColor: sideBarTextColor,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: size_9,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: Text(
                vehicleNo,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: size_9,
                  color: Colors.black,
                  fontWeight: normalWeight,
                ),
              ))),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: GestureDetector(
                onTap: () {},
                child: Text(
                  'View POD',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: size_9,
                    color: bidBackground,
                    fontWeight: normalWeight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ))),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: GestureDetector(
                onTap: () {},
                child: Text(
                  "View Remark",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: size_9,
                    color: bidBackground,
                    fontWeight: normalWeight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ))),
          const VerticalDivider(color: greyDivider, thickness: 1),
          Expanded(
              flex: 20,
              child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                    visibleWidget: MapScreen(
                                      loadingPoint: from,
                                      unloadingPoint: to,
                                      truckNumber: vehicleNo,
                                    ),
                                    index: 1000,
                                    selectedIndex:
                                        screens.indexOf(ewayBillScreen),
                                  )),
                        );
                      },
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(110)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(liveasyGreen)),
                      child: Text(
                        "Track",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.0125,
                          color: Colors.white,
                          fontWeight: mediumBoldWeight,
                        ),
                      )))),
        ]));
  }

  void handleDateRangeSelection(String value) {
    switch (value) {
      case 'Today':
        fromTimestamp = DateTime(now.year, now.month, now.day);
        toTimestamp = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'This Week':
        int dayOfWeek = now.weekday;
        fromTimestamp = now.subtract(Duration(days: dayOfWeek - 1));
        toTimestamp = now.add(
            Duration(days: 7 - dayOfWeek, hours: 23, minutes: 59, seconds: 59));
        break;
      case 'This Month':
        fromTimestamp = DateTime(now.year, now.month, 1);
        toTimestamp = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'Last Month':
        fromTimestamp = DateTime(now.year, now.month - 1, 1);
        toTimestamp = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case 'This Year':
        fromTimestamp = DateTime(now.year, 1, 1);
        toTimestamp = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case 'Custom':
        // Handle custom date range if needed
        break;
      default:
        // Default case
        break;
    }
  }
}
