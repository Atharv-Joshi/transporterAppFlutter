import 'package:flutter/material.dart';

import '../screens/PostLoadScreens/postLoadScreen.dart';
import '../screens/TruckScreens/myTrucksScreen.dart';
import '../screens/accountScreens/accountVerificationStatusScreen.dart';
import '../screens/auctionScreen.dart';
import '../screens/findLoadScreen.dart';
import '../screens/ordersScreen.dart';
import '../widgets/alertDialog/LogOutDialogue.dart';

//TODO : At first add screens like this,and add that to list.
//TODO: So that we can use home screen as base screen and update the right side of screen accordingly
final auctionScreen = AuctionScreen();
final myTrucks = MyTrucks();
final postLoadScreen = PostLoadScreen();
final ordersScreen = OrdersScreen();
final logoutDialogue = LogoutDialogue();
// var postLoadNav = PostLoadNav(
//   setChild: Container(),
//   index: 0,
// );
// const addUser = AddUser();
final accountVerificationScreen = AccountVerificationStatusScreen();
final search = FindLoadScreen();
// const facilities = Facilities();
// const logoutDialogue = LogoutDialogue();
// const employeeListScreen = EmployeeListRolesScreen();
// const postLoadScreenTwo = PostLoadScreenTwo();

//TODO : This is the list of the screens, Navigated to these when user selects anything,we are maintaining home screen as base screen.
//TODO : All the variables above initialized must be added to this list.
List<Widget> screens = [
  auctionScreen,
  ordersScreen,
  logoutDialogue,

  //

  accountVerificationScreen,
  search,

  //
];
