import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/accountScreens/accountVerificationPage1.dart';
import 'package:liveasy/screens/accountScreens/accountVerificationStatusScreen.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/widgets/bottomNavigationIconWidget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'TruckScreens/myTrucksScreen.dart';

class NavigationScreen extends StatefulWidget {
  final bool? isAccountVerificationInProgress;

  NavigationScreen({this.isAccountVerificationInProgress});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  bool isAccountVerificationInProgress = false;
  var screens;

  @override
  Widget build(BuildContext context) {
    isAccountVerificationInProgress =
        widget.isAccountVerificationInProgress != null
            ? widget.isAccountVerificationInProgress! : false;
    screens = [
      HomeScreen(),
      MyTrucks(),
      Text(""),
      Text(""),
      transporterIdController.transporterApproved.value
          ? AccountVerificationStatusScreen(
              mobileNum: transporterIdController.mobileNum.value,
              accountVerificationInProgress: false)
          : (isAccountVerificationInProgress
              ? AccountVerificationStatusScreen(
                  mobileNum: transporterIdController.mobileNum.value,
                  accountVerificationInProgress: true)
              : AccountVerificationPage1()),
    ];
    return Scaffold(
      backgroundColor: statusBarColor,
      // color of status bar which displays time on a phone
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int pressedIndex) {
          Provider.of<ProviderData>(context, listen: false)
              .updateIndex(pressedIndex);
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: grey,
        selectedItemColor: grey,
        selectedLabelStyle: TextStyle(color: flagGreen),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavigationIconWidget(
              iconPath: "homeIcon.png",
            ),
            activeIcon: BottomNavigationIconWidget(
              iconPath: "activeHomeIcon.png",
            ),
            label: ("Home"),
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationIconWidget(
              iconPath: "myTrucksIcon.png",
            ),
            activeIcon: BottomNavigationIconWidget(
              iconPath: "activeMyTrucksIcon.png",
            ),
            label: ("My Trucks"),
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationIconWidget(
              iconPath: "postLoadIcon.png",
            ),
            activeIcon: BottomNavigationIconWidget(
              iconPath: "activePostLoadIcon.png",
            ),
            label: ("Post Load"),
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationIconWidget(
              iconPath: "ordersIcon.png",
            ),
            activeIcon: BottomNavigationIconWidget(
              iconPath: "activeOrdersIcon.png",
            ),
            label: ("Orders"),
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationIconWidget(
              iconPath: "accountIcon.png",
            ),
            activeIcon: BottomNavigationIconWidget(
              iconPath: "activeAccountIcon.png",
            ),
            label: ("Account"),
          ),
        ],
        currentIndex: Provider.of<ProviderData>(context).index,
      ),
      body: SafeArea(
        child: Center(
            child: screens.elementAt(Provider.of<ProviderData>(context).index)),
      ),
    );
  }
}
