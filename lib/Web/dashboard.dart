// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/transporter_nav_icons.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/isolatedTransporterGetData.dart';
import 'package:liveasy/screens/navigationScreen.dart';

import 'logo.dart';

class DashboardScreen extends StatefulWidget {
  final Widget? visibleWidget;
  final int? index;
  final int? selectedIndex;

  const DashboardScreen(
      {Key? key, this.index, this.selectedIndex, this.visibleWidget})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _index = 0;
  late Color auctionSelectedTabGradientColor,
      invoiceSelectedTabGradientColor,
      myOrderSelectedTabGradientColor,
      ewayBillSelectedTabGradientColor,
      signoutSelectedTabGradientColor,
      liveasySelectedTabGradientColor;

  late bool expandMode;
  late double widthOfSideBar;
  bool isLoadingInvoice = false; //handle the loading feature for the screen

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  NavigationIndexController navigationIndex =
      Get.put(NavigationIndexController(), permanent: true);
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  @override
  void initState() {
    super.initState();
    isolatedTransporterGetData();

    if (widget.index != null) {
      setState(() {
        _index = widget.index!;
        _selectedIndex = widget.selectedIndex!;
      });
    }
    expandMode = true;
    if (expandMode) {
      widthOfSideBar = 220;
    } else {
      widthOfSideBar = 110;
    }
    if (_selectedIndex == 0) {
      auctionSelectedTabGradientColor = bidBackground;
    } else {
      auctionSelectedTabGradientColor = white;
    }

    if (_selectedIndex == 1) {
      myOrderSelectedTabGradientColor = bidBackground;
    } else {
      myOrderSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 2) {
      invoiceSelectedTabGradientColor = bidBackground;
    } else {
      invoiceSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 3) {
      ewayBillSelectedTabGradientColor = bidBackground;
    } else {
      ewayBillSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 4) {
      signoutSelectedTabGradientColor = bidBackground;
    } else {
      signoutSelectedTabGradientColor = white;
    }
    liveasySelectedTabGradientColor = white;
    loadInvoiceScreen();
  }

  // Load the InvoiceScreen and handle loading state
  Future<void> loadInvoiceScreen() async {
    setState(() {
      isLoadingInvoice = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulating loading data

    setState(() {
      isLoadingInvoice = false;
    });
  }

  void refresh1() {
    loadInvoiceScreen();
  }

  //TODO: This is the list for Navigation Rail List Destinations,This contains icons and it's labels
  //TODO : This is the list for Bottom Navigation Bar

  // List<BottomNavigationBarItem> bottom_destinations = [
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.space_dashboard), label: "Auctions"),
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.space_dashboard), label: "My Loads"),
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.receipt_long), label: "My Trucks"),
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.person_outline_outlined), label: "Orders"),
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.supervised_user_circle_outlined), label: "Signout"),
  //
  // ];

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        //TODO : Bottom Navigation Bar is only displayed when the screen size is in between sizes of mobile devices
        bottomNavigationBar: Responsive.isMobile(context)
            ? NavigationScreen()
            // BottomNavigationBar(
            //         selectedItemColor: bidBackground,
            //         unselectedItemColor: Colors.blueGrey,
            //         showUnselectedLabels: true,
            //         items: bottom_destinations,
            //         currentIndex: _selectedIndex,
            //         onTap: (updatedIndex) {
            //           setState(() {
            //             if (updatedIndex == 2 || updatedIndex == 3) {
            //               _index = updatedIndex + 1;
            //             } else {
            //               _index = updatedIndex;
            //             }
            //             _selectedIndex = updatedIndex;
            //           });
            //         },
            //       )
            : null,
        key: scaffoldKey,
        appBar: AppBar(
          leading: null,
          backgroundColor: bidBackground,
          title: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()));
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      const LiveasyLogoImage(),
                      SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Liveasy',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat Bold",
                            color: white),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: const SizedBox())
            ],
          ),
          actions: [
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    // _index = 5;
                  });
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _index = screens.indexOf(search);
                  });
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SizedBox(
                width: 48,
                height: 40,
                child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _index = screens.indexOf(accountVerificationScreen);
                      });
                    },
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      color: white,
                    ),
                    label: const Text('')),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            //TODO : Similar to bottom navigation bar, Navigation rail is only displayed when it is not mobile screen
            Responsive.isMobile(context)
                ? const SizedBox(
                    width: 0.01,
                  )
                : Container(
                    child: Stack(
                      children: [
                        Row(children: [
                          Card(
                            surfaceTintColor: transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                            elevation: 5,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 100),
                              height: MediaQuery.of(context).size.height,
                              width: widthOfSideBar,
                              color: white,
                              child: Column(
                                children: [
                                  SideExpandedItem(
                                      title: "Auctions",
                                      iconSize: 20,
                                      icon: ShipperNav.auction,
                                      position: 0),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "My Orders",
                                      iconSize: 20,
                                      icon: ShipperNav.box_load,
                                      position: 1),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "Invoice",
                                      iconSize: 20,
                                      icon: ShipperNav.invoice,
                                      position: 2),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "EwayBill",
                                      iconSize: 20,
                                      icon: ShipperNav.eway_bill,
                                      position: 3),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                  ),
                                  SideExpandedItem(
                                      title: "Signout",
                                      iconSize: 20,
                                      icon: Icons.logout_outlined,
                                      position: 4),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 37),
                                              child: SideExpandedItem(
                                                  title: "Liveasy",
                                                  iconSize: 23,
                                                  icon: ShipperNav.liveasy_logo,
                                                  position: 999)))),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: headerLightBlueColor,
                            width: 15,
                          )
                        ]),
                        Positioned(
                          left: widthOfSideBar - 10,
                          top: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height) *
                              0.45,
                          height: 30,
                          width: 30,
                          child: Container(
                            //padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(50),
                                color: white),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (expandMode) {
                                    expandMode = false;
                                    widthOfSideBar = 110;
                                  } else {
                                    expandMode = true;
                                    widthOfSideBar = 220;
                                  }
                                });
                              },
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                  (expandMode)
                                      ? Icons.arrow_back_ios_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color: darkBlueTextColor,
                                  size: 20),
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        white),
                                side: MaterialStateProperty.all(
                                  const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                              ),
                              hoverColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            Expanded(
              child: Container(
                child: Center(
                  child: isLoadingInvoice
                      ? CircularProgressIndicator()
                      : (_index == 1000)
                          ? widget.visibleWidget
                          : screens[_index],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  InkWell SideExpandedItem(
      {required String title,
      required IconData icon,
      required int position,
      required double iconSize}) {
    if (_selectedIndex == 0) {
      auctionSelectedTabGradientColor = bidBackground;
    } else {
      auctionSelectedTabGradientColor = white;
    }

    if (_selectedIndex == 1) {
      myOrderSelectedTabGradientColor = bidBackground;
    } else {
      myOrderSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 2) {
      invoiceSelectedTabGradientColor = bidBackground;
    } else {
      invoiceSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 3) {
      ewayBillSelectedTabGradientColor = bidBackground;
    } else {
      ewayBillSelectedTabGradientColor = white;
    }
    if (_selectedIndex == 4) {
      signoutSelectedTabGradientColor = bidBackground;
    } else {
      signoutSelectedTabGradientColor = white;
    }

    liveasySelectedTabGradientColor = white;

    return InkWell(
        onTap: () {
          setState(() {
            if (title == "Auctions") {
              auctionSelectedTabGradientColor = bidBackground;
              myOrderSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor = white;
              ewayBillSelectedTabGradientColor = white;
              signoutSelectedTabGradientColor = white;
              _selectedIndex = 0;
              _index = 0;
            } else if (title == "My Orders") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = bidBackground;
              invoiceSelectedTabGradientColor = white;
              ewayBillSelectedTabGradientColor = white;
              signoutSelectedTabGradientColor = white;
              _selectedIndex = 1;
              _index = 1;
            } else if (title == "Invoice") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor = bidBackground;
              ewayBillSelectedTabGradientColor = white;
              signoutSelectedTabGradientColor = white;
              refresh1(); // when click on invoice again screen will get refresh
              _selectedIndex = 2;
              _index = 2;
            } else if (title == "EwayBill") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor = white;
              ewayBillSelectedTabGradientColor = bidBackground;
              signoutSelectedTabGradientColor = white;
              _selectedIndex = 3;
              _index = 3;
            } else if (title == "Signout") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor = white;
              ewayBillSelectedTabGradientColor = white;
              signoutSelectedTabGradientColor = bidBackground;
              _selectedIndex = 4;
              _index = 4;
            }
          });
        },
        child: Container(
            height: 55,
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (title == "Liveasy")
                    ? liveasySelectedTabGradientColor
                    : (title == "Auctions")
                        ? auctionSelectedTabGradientColor
                        : (title == "My Orders")
                            ? myOrderSelectedTabGradientColor
                            : (title == "Invoice")
                                ? invoiceSelectedTabGradientColor
                                : (title == 'EwayBill')
                                    ? ewayBillSelectedTabGradientColor
                                    : (title == 'Signout')
                                        ? signoutSelectedTabGradientColor
                                        : liveasySelectedTabGradientColor),
            child: Row(
              children: [
                Icon(icon,
                    size: iconSize,
                    color: position == _selectedIndex ? white : darkBlueColor),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: expandMode,
                    child: (title == "Liveasy")
                        ? Text(
                            title,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat Bold",
                                color: position == _selectedIndex
                                    ? white
                                    : darkBlueColor),
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                color: (position == _selectedIndex)
                                    ? white
                                    : darkBlueColor),
                          ))
              ],
            )));
  }
}
