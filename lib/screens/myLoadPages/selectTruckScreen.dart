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
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';
import 'package:liveasy/screens/myLoadPages/confirmBookingDetails.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';

import 'bookLoadScreen.dart';

class SelectTruckScreen extends StatefulWidget {
  // List? truckModelList;
  // List? driverModelList;
  LoadDetailsScreenModel loadDetailsScreenModel;
  BiddingModel? biddingModel;
  bool? directBooking;
  String? postLoadId;
  String? driverName, driverPhoneNo;

  SelectTruckScreen(
      {this.postLoadId,
      required this.loadDetailsScreenModel,
      this.biddingModel,
      this.driverName,
      this.driverPhoneNo,
      required this.directBooking});

  @override
  State<SelectTruckScreen> createState() => _SelectTruckScreenState();
}

class _SelectTruckScreenState extends State<SelectTruckScreen> {
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
  List<TruckModel> truckDetailsList = [];
  List<DriverModel> driverDetailsList = [];
  MapUtil mapUtil = MapUtil();

  getTruckList() async {
    // FutureGroup futureGroup = FutureGroup();

    var a = mapUtil.getDevices(); ///////////////////////////
    // var b = mapUtil.getTraccarPositionforAll(); /////////////////////
    var devices = await a; /////////////////////
    // setState(() {
    //   truckList = devices;
    // });
    // truckList = devices;
    // var gpsDataAll = await b; ////////////////////
    truckList.clear();
    deviceIdList.clear();
    for (var device in devices) {
      setState(() {
        truckList.add(device.truckno);
        // truckList.add("123456");
        // truckList.add("1234567");
        // truckList.add("1234568");
        // truckList.add("123456*");
        print(truckList);
        deviceIdList.add(device.deviceId);
        print(deviceIdList);
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
            print(searchText);
            searchedTruckList.add(data);
            searchedDeviceIdList.add(deviceIdList[i]);
            print(searchedTruckList);
            print(searchedDeviceIdList);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb && (Responsive.isDesktop(context)))
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
                                  selectedIndex: screens.indexOf(auctionScreen),
                                  index: 1000,
                                  visibleWidget: BookLoadScreen(
                                    truckModelList: truckDetailsList,
                                    driverModelList: driverDetailsList,
                                    loadDetailsScreenModel:
                                        widget.loadDetailsScreenModel,
                                    directBooking: true,
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
                                print(value);
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
                                    //If it is web shows a dialog box to add new truck, else pushes to new screen.
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
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
                                color: const Color(0xFF152968),
                              ),
                              label: Text(
                                "Add Truck",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: const Color(0xFF152968),
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
                          //searched.Truck is used to search by truck number on search bar.
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
                                          print(selectedDeviceId);
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
                                                  ? Color(0xff152968)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                searchedTruckList[index],
                                                style: TextStyle(
                                                  fontSize: size_10,
                                                  fontWeight: mediumBoldWeight,
                                                  color:
                                                      (index == selectedIndex)
                                                          ? Colors.white
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
                                          print(selectedDeviceId);
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
                                                  ? Color(0xff152968)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                truckList[index],
                                                style: TextStyle(
                                                  fontSize: size_10,
                                                  fontWeight: mediumBoldWeight,
                                                  color:
                                                      (index == selectedIndex)
                                                          ? Colors.white
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
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => DashboardScreen(
                                              selectedIndex: screens
                                                  .indexOf(auctionScreen),
                                              index: 1000,
                                              visibleWidget:
                                                  ConfirmBookingDetails(
                                                selectedTruck: selectedTruck,
                                                selectedDeviceId:
                                                    selectedDeviceId,
                                                driverName: widget.driverName,
                                                mobileNo: widget.driverPhoneNo,
                                                loadDetailsScreenModel: widget
                                                    .loadDetailsScreenModel,
                                                directBooking: true,
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
        //TODO:App side code.
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
                            return ConfirmBookingDetails(
                              selectedTruck: selectedTruck,
                              selectedDeviceId: selectedDeviceId,
                              driverName: widget.driverName,
                              mobileNo: widget.driverPhoneNo,
                              loadDetailsScreenModel:
                                  widget.loadDetailsScreenModel,
                              directBooking: true,
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
                                print(value);
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
                                            print(selectedDeviceId);
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
                                                              // color: grey,
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
                                                                // color: grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/deepbluecircle_ic.png"),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              // color: grey,
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
                                                                // color: grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/greencheckcircle_ic.png"),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                                // setState
                                                // changes(),
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
                                            print(selectedDeviceId);
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
                                                              // color: grey,
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
                                                                // color: grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/deepbluecircle_ic.png"),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              // color: grey,
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
                                                                // color: grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/greencheckcircle_ic.png"),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                                // setState
                                                // changes(),
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
// changes() {
//   setState(() {
//     selectedIndex = false;
//   });
// }
}
