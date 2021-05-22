import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/variables/getxVariables.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [HomeScreen(), FindLoadScreen(), Text("abc")];
  GetxVariables getxVariables = GetxVariables();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int pressedIndex) {
              setState(() {
                getxVariables.pageIndex.value = pressedIndex;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: ("Home"),
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/TruckIcon.png"),
                label: ("My Trucks"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: ("Account"),
              ),
            ],
            currentIndex: getxVariables.pageIndex.value,
          ),
          body: Center(child: screens.elementAt(getxVariables.pageIndex.value)),
        ),
      ),
    );
  }
}
