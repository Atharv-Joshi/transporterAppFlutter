import 'package:flutter/material.dart';
import 'package:liveasy/screens/Eway_Bills_Screen.dart';
import 'package:liveasy/screens/PostLoadScreens/postLoadScreen.dart';
import 'package:liveasy/screens/TruckScreens/myTrucksScreen.dart';
import 'package:liveasy/screens/accountScreens/accountVerificationStatusScreen.dart';
import 'package:liveasy/screens/auctionScreen.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/screens/invoiceScreens/InvoiceScreen.dart';
import 'package:liveasy/screens/ordersScreen.dart';
import 'package:liveasy/widgets/alertDialog/LogOutDialogue.dart';

//TODO : At first add screens like this,and add that to list.
//TODO: So that we can use home screen as base screen and update the right side of screen accordingly
final auctionScreen = AuctionScreen();
final myTrucks = MyTrucks();
final postLoadScreen = PostLoadScreen();
final ordersScreen = OrdersScreen();
final logoutDialogue = LogoutDialogue();
final invoiceScreen = InvoiceScreen();
final ewayBillScreen = EwayBills();
final accountVerificationScreen = AccountVerificationStatusScreen();
final search = FindLoadScreen();

//TODO : This is the list of the screens, Navigated to these when user selects anything,we are maintaining home screen as base screen.
//TODO : All the variables above initialized must be added to this list.
List<Widget> screens = [
  auctionScreen,
  ordersScreen,
  invoiceScreen,
  ewayBillScreen,
  logoutDialogue,

  //

  accountVerificationScreen,
  search,

  //
];
