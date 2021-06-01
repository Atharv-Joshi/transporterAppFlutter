import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/theme..dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/widgets/bottomNavigationIconWidget.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [
    HomeScreen(),
    Text(""),
    Text(""),
    Text(""),
    Text("")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int pressedIndex) {
              Provider.of<ProviderData>(context, listen: false)
                  .updateIndex(pressedIndex);
            },
            type: BottomNavigationBarType.shifting,
            showUnselectedLabels: true,
            unselectedItemColor: grey,
            selectedItemColor: grey,
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
          body: Center(
              child: screens.elementAt(
                  Provider.of<ProviderData>(context, listen: false).index)),
        ),
      ),
    );
  }
}
