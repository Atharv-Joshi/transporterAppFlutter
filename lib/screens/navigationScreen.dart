import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/theme..dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [
    HomeScreen(),
    FindLoadScreen(),
    Text("abc"),
    Text("abc")
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
              setState(() {
                Provider.of<ProviderData>(context, listen: false).updateIndex(pressedIndex);
              });
            },
            type: BottomNavigationBarType.shifting,
            showUnselectedLabels: true,
            unselectedItemColor: grey,
            selectedItemColor: grey,
            unselectedLabelStyle: TextStyle(color: black, fontSize: size_4),
            selectedLabelStyle: TextStyle(color: lightBlue, fontSize: size_7),

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset("assets/icons/homeIcon.png"),
                ),
                label: ("HOME"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset("assets/icons/TruckIcon.png"),
                ),
                label: ("MY TRUCKS"),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset("assets/icons/ordersIcon.png"),
                ),
                label: ("ORDERS"),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: unselectedGrey,
                ),
                label: ("ACCOUNT"),
              ),
            ],
            currentIndex: Provider.of<ProviderData>(context).index,
            // GetBuilder<PageIndexController>(builder: (_) {return pageIndexController.pageIndex.value; },)
          ),
          body:
              Center(child: screens.elementAt(Provider.of<ProviderData>(context, listen: false).index)),
        ),
      ),
    );
  }
}
