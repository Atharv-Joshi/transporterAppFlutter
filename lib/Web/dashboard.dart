// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/screens.dart';
import '../constants/color.dart';
import '../constants/transporter_nav_icons.dart';
import '../controller/navigationIndexController.dart';
import '../controller/transporterIdController.dart';
import '../responsive.dart';
import '../screens/isolatedTransporterGetData.dart';
import '../screens/navigationScreen.dart';
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
      myOrderSelectedTabGradientColor,
      signoutSelectedTabGradientColor,
      liveasySelectedTabGradientColor;

  late bool expandMode;
  late double widthOfSideBar;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  NavigationIndexController navigationIndex =
      Get.put(NavigationIndexController(), permanent: true);
  // AddLocationDrawerToggleController addLocationDrawerToggleController =
  //     Get.put(AddLocationDrawerToggleController());
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
      signoutSelectedTabGradientColor = bidBackground;
    } else {
      signoutSelectedTabGradientColor = white;
    }
    liveasySelectedTabGradientColor = white;
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
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.33,
                                  ),
                                  SideExpandedItem(
                                      title: "Signout",
                                      iconSize: 20,
                                      icon: Icons.logout_outlined,
                                      position: 2),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 30),
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
                  child:
                      (_index == 1000) ? widget.visibleWidget : screens[_index],
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
              signoutSelectedTabGradientColor = white;
              _selectedIndex = 0;
              _index = 0;
            } else if (title == "My Orders") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = bidBackground;
              signoutSelectedTabGradientColor = white;
              _selectedIndex = 1;
              _index = 1;
            } else if (title == "Signout") {
              auctionSelectedTabGradientColor = white;
              myOrderSelectedTabGradientColor = white;
              signoutSelectedTabGradientColor = bidBackground;
              _selectedIndex = 2;
              _index = 2;
            }
          });
        },
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (title == "Liveasy")
                    ? liveasySelectedTabGradientColor
                    : (title == "Auctions")
                        ? auctionSelectedTabGradientColor
                        : (title == "My Orders")
                            ? myOrderSelectedTabGradientColor
                            // : (title == 'My loads')
                            //     ? liveasySelectedTabGradientColor
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
