//TODO:to be refactored
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/functions/authFunctions.dart';
import 'package:get/get.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
class DrawerWidget extends StatelessWidget {

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.home),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      // widget.user == null ?
                      '+911234567891'
                      // : widget.user.phoneNumber
                      ,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                authService.signOut();
                // if(FirebaseAuth.instance.currentUser == null){
                //   Get.to(() => LoginScreen());
                },


              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
