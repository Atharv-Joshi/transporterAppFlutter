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
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';
import 'package:liveasy/screens/updateBookingDetails.dart';
import 'package:liveasy/screens/updateBookingDetailsScreen.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';

import '../models/onGoingCardModel.dart';

//This screen displayes number of trucks from which user can select only one
class UpdateTruckScreen extends StatefulWidget {
  OngoingCardModel loadAllDataModel;
  String? driverName, driverPhoneNo;
  UpdateTruckScreen({
    required this.loadAllDataModel,
    this.driverName,
    this.driverPhoneNo,
  });

  @override
  State<UpdateTruckScreen> createState() => _UpdateTruckScreenState();
}

class _UpdateTruckScreenState extends State<UpdateTruckScreen> {
  final ScrollController _firstController = ScrollController();
  bool isSelected = false;
  String searchedTruck = "";
  late String selectedTruck;
  late int selectedDeviceId;
  int selectedIndex = -1;
  List truckList = [];
  List searchedTruckList = [];
  List deviceIdList = [];
  List searchedDeviceIdList = [];
  MapUtil mapUtil = MapUtil();
  getTruckList() async {
    var a = mapUtil.getDevices();
    var devices = await a;
    truckList.clear();
    deviceIdList.clear();
    for (var device in devices) {
      setState(() {
        truckList.add(device.truckno);
        deviceIdList.add(device.deviceId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTruckList();
  }

  void searchoperation(String searchText) {
    if (searchText != null) {
      searchedTruckList.clear();
      searchedDeviceIdList.clear();
      for (int i = 0; i < truckList.length; i++) {
        String data = truckList[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchedTruckList.add(data);
            searchedDeviceIdList.add(deviceIdList[i]);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb && (Responsive.isDesktop(context)))
        //Ui for web
        ? Scaffold(
            body: Column(
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
                                  selectedIndex: screens.indexOf(ordersScreen),
                                  index: 1000,
                                  visibleWidget: UpdateBookingDetailsScreen(
                                    loadAllDataModel: widget.loadAllDataModel,
                                  ))));
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: space_5,
                  ),
                  Container(
                    child: Text(
                      'Select Truck',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: space_9,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: widgetBackGroundColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 0.8, color: widgetBackGroundColor),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchedTruck = value;
                                });
                                searchoperation(searchedTruck);
                                selectedTruck = "";
                                selectedDeviceId = -1;
                                selectedIndex = -1;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'searchByNumber'.tr,
                                icon: Icon(
                                  Icons.search,
                                  color: grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 70.0),
                          child: Container(
                            height: space_10,
                            width: space_32,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                (kIsWeb && (Responsive.isDesktop(context)))
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          //A dialog box opens to add a new truck details.
                                          return SimpleDialog(
                                            children: [
                                              Container(
                                                width: 540,
                                                height: 280,
                                                child:
                                                    AddNewTruck("selectTruck"),
                                              )
                                            ],
                                          );
                                        })
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewTruck("selectTruck"),
                                        ),
                                      );
                              },
                              icon: Icon(
                                Icons.add,
                                color: darkBlueColor,
                              ),
                              label: Text(
                                "Add Truck",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: darkBlueColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: space_2),
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Scrollbar(
                          controller: _firstController,
                          child: searchedTruck.length != 0
                              ? ListView.builder(
                                  itemCount: searchedTruckList.length,
                                  controller: _firstController,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        setState(() {
                                          isSelected = true;
                                          selectedIndex = index;
                                          selectedTruck =
                                              searchedTruckList[index];
                                          selectedDeviceId =
                                              searchedDeviceIdList[index];
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: space_2, bottom: space_2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: widgetBackGroundColor),
                                              color: (index == selectedIndex)
                                                  ? darkBlueColor
                                                  : white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                searchedTruckList[index],
                                                style: TextStyle(
                                                  fontSize: size_10,
                                                  fontWeight: mediumBoldWeight,
                                                  color:
                                                      (index == selectedIndex)
                                                          ? white
                                                          : black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size_5,
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              //Ui for mobile
                              : ListView.builder(
                                  itemCount: truckList.length,
                                  controller: _firstController,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        setState(() {
                                          isSelected = true;
                                          selectedIndex = index;
                                          selectedTruck = truckList[index];
                                          selectedDeviceId =
                                              deviceIdList[index];
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: space_2, bottom: space_2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: widgetBackGroundColor),
                                              color: (index == selectedIndex)
                                                  ? darkBlueColor
                                                  : white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                truckList[index],
                                                style: TextStyle(
                                                  fontSize: size_10,
                                                  fontWeight: mediumBoldWeight,
                                                  color:
                                                      (index == selectedIndex)
                                                          ? white
                                                          : black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size_5,
                                          )
                                        ],
                                      ),
                                    );
                                  })),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: isSelected
                            ? () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                          selectedIndex:
                                              screens.indexOf(ordersScreen),
                                          index: 1000,
                                          visibleWidget: UpdateBookingDetails(
                                            selectedTruck: selectedTruck,
                                            selectedDeviceId: selectedDeviceId,
                                            driverName: widget.driverName,
                                            mobileNo: widget.driverPhoneNo,
                                            loadAllDataModel:
                                                widget.loadAllDataModel,
                                          )))),
                                }
                            : () => {},
                        child: Padding(
                          padding: EdgeInsets.only(right: 250, top: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff152968),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: space_40,
                            height: space_10,
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    color: white,
                                    fontWeight: mediumBoldWeight,
                                    fontSize: size_8 + 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ))
        : Scaffold(
            backgroundColor: statusBarColor,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: SizedBox(
              width: 130,
              height: space_9 + 1,
              child: FloatingActionButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      color: white,
                      fontWeight: mediumBoldWeight,
                      fontSize: size_8 + 2),
                ),
                onPressed: isSelected
                    ? () => {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: ((context) {
                            return UpdateBookingDetails(
                              selectedTruck: selectedTruck,
                              selectedDeviceId: selectedDeviceId,
                              driverName: widget.driverName,
                              mobileNo: widget.driverPhoneNo,
                              loadAllDataModel: widget.loadAllDataModel,
                            );
                          }))),
                        }
                    : () => {},
                backgroundColor: darkBlueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius_4)),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: space_2),
                  child: Stack(
                    children: [
                      Column(children: [
                        SizedBox(
                          height: space_4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackButtonWidget(),
                            SizedBox(
                              width: space_3,
                            ),
                            HeadingTextWidget('selectTruck'.tr),
                            SizedBox(
                              width: space_6,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewTruck("selectTruck"),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add,
                                color: const Color(0xFF152968),
                              ),
                              label: Text(
                                "Add Truck",
                                style: TextStyle(
                                    color: const Color(0xFF152968),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: space_3,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: space_3, horizontal: space_3),
                          child: Container(
                            height: space_11,
                            decoration: BoxDecoration(
                              color: widgetBackGroundColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 0.8, color: widgetBackGroundColor),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchedTruck = value;
                                });
                                searchoperation(searchedTruck);
                                selectedTruck = "";
                                selectedDeviceId = -1;
                                selectedIndex = -1;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'searchByNumber'.tr,
                                icon: Padding(
                                  padding: EdgeInsets.only(left: space_2),
                                  child: Icon(
                                    Icons.search,
                                    color: grey,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: size_8,
                                  color: grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        searchedTruck.length != 0
                            ? SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: ListView.builder(
                                    itemCount: searchedTruckList.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            isSelected = true;
                                            selectedIndex = index;
                                            selectedTruck =
                                                searchedTruckList[index];
                                            selectedDeviceId =
                                                searchedDeviceIdList[index];
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: space_8,
                                                      right: space_5,
                                                      bottom: space_4,
                                                      top: space_3),
                                                  child:
                                                      !(index == selectedIndex)
                                                          ? Container(
                                                              height: 15,
                                                              width: 15,
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      space_2,
                                                                      space_2,
                                                                      0,
                                                                      0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/deepbluecircle_ic.png"),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 25,
                                                              width: 25,
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      space_2,
                                                                      space_2,
                                                                      0,
                                                                      0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/greencheckcircle_ic.png"),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                                Text(
                                                  searchedTruckList[index],
                                                  style: TextStyle(
                                                    fontSize: size_10,
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    color: black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: space_5,
                                                  right: space_5),
                                              child: Divider(
                                                height: size_10,
                                                color: grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: ListView.builder(
                                    itemCount: truckList.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            isSelected = true;
                                            selectedIndex = index;
                                            selectedTruck = truckList[index];
                                            selectedDeviceId =
                                                deviceIdList[index];
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: space_8,
                                                      right: space_5,
                                                      bottom: space_4,
                                                      top: space_3),
                                                  child:
                                                      (index != selectedIndex)
                                                          ? Container(
                                                              height: 15,
                                                              width: 15,
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      space_2,
                                                                      space_2,
                                                                      0,
                                                                      0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/deepbluecircle_ic.png"),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 25,
                                                              width: 25,
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      space_2,
                                                                      space_2,
                                                                      0,
                                                                      0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/greencheckcircle_ic.png"),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                                Text(
                                                  truckList[index],
                                                  style: TextStyle(
                                                    fontSize: size_10,
                                                    fontWeight:
                                                        mediumBoldWeight,
                                                    color: black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: space_5,
                                                  right: space_5),
                                              child: Divider(
                                                height: size_10,
                                                color: grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
