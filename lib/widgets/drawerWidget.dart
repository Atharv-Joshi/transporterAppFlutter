import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/drawerProviderClassData.dart';
import 'package:liveasy/screens/LoginScreens/loginScreen.dart';
import 'package:liveasy/screens/buyGpsScreen.dart';
import 'package:liveasy/screens/languageSelectionScreen.dart';
import 'package:liveasy/widgets/accountVerification/accountPageUtil.dart';
import 'package:liveasy/widgets/alertDialog/addDriverAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';


class NavigationDrawerWidget extends StatelessWidget {
  final String mobileNum;
  final String userName;

  NavigationDrawerWidget({required this.mobileNum, required this.userName});

  final padding = EdgeInsets.only(left: space_1, right: space_7);
  @override
  Widget build(BuildContext context) {
    String name;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if(userName.length > 17){
      name = userName.substring(0,15) + "...";
    }else{
      name = userName;
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_6),
          bottomRight: Radius.circular(radius_6)),
      child: Container(
        width: width / 1.4,
        height: height / 1.1,
        child: Drawer(
          child: Material(
              color: fadeGrey,
              child: Container(
                margin: EdgeInsets.only(left: space_4),
                child: ListView(
                  children: [
                    SizedBox(height: space_9,),
                    Row(
                      children: [
                        Image(
                          image: AssetImage('assets/images/defaultDriverImage.png'),
                          height: space_13+2,
                        ),
                        SizedBox(
                          width: space_2,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                alignment: Alignment.topLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: mediumBoldWeight, fontSize: size_7,fontFamily: 'montserrat',),
                                ),
                              ),
                              SizedBox(height: space_2),
                              Text("+91 " +mobileNum),

                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: space_9,),
                    buidMenuItem(
                        context: context,
                        item: NavigationItem.MyAccount,
                        text: "My Account",
                        page: AccountPageUtil(),
                        image: 'assets/icons/person.png'),

                    buidMenuItem(
                        context: context,
                        item: NavigationItem.Language,
                        page: LanguageSelectionScreen(),
                        text: "Language",
                        image: 'assets/icons/languageIcon.png'),
                    buidMenuItem(
                        context: context,
                        item: NavigationItem.AddDriver,
                        page: AddDriverAlertDialog(),
                        text: "Add Driver",
                        image: 'assets/icons/driverHandle.png'),
                    buidMenuItem(
                        context: context,
                        item: NavigationItem.BuyGps,
                        page: BuyGpsScreen(),
                        text: "Buy GPS",
                        image: 'assets/icons/gps.png'),
                    SizedBox(height: space_5,),
                    Divider(
                      color: black,
                    ),
                    SizedBox(height: space_3,),
                    ListTile(
                      title: Text("About Us",
                          style: TextStyle(
                              color: drawerItemColor,
                              fontSize: size_8,
                              fontFamily: 'montserrat',
                              fontWeight: regularWeight)),
                    ),
                    ListTile(
                      title: Text("Contact Us",
                          style: TextStyle(
                              color: drawerItemColor,
                              fontSize: size_8,
                              fontFamily: 'montserrat',
                              fontWeight: regularWeight)),
                    ),
                    SizedBox(height: space_3,),
                    Divider(
                      color: black,
                    ),
                    SizedBox(
                      height: space_7,
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Get.offAll(LoginScreen());
                      },
                      child: ListTile(
                        title: Text("Logout",
                            style: TextStyle(
                                color: black,
                                fontSize: size_8,
                                fontFamily: 'montserrat',
                                fontWeight: regularWeight)),
                        leading: Icon(Icons.logout, color: drawerItemColor,),
                      ),
                    ),
                    SizedBox(
                      height: space_4,
                    ),

                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buidMenuItem(
      {required BuildContext context,
        required NavigationItem item,
        required String text,

        required String image, required Widget page}) {


    final provider= Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_2),
          bottomRight: Radius.circular(radius_2)),
      child: ListTile(
          selected: isSelected,
          selectedTileColor: selectedItemColor,
          leading: Image(
            image: AssetImage(image),
            width: space_3,
            height: space_4,
          ),
          title: Text(text, style: TextStyle(
              color: isSelected ? drawerItemColor : black ,
              fontSize: size_8,
              fontFamily:'montserrat',
              fontWeight: isSelected ?boldWeight : regularWeight)),
          onTap: () {

            selectItem(context, item);
            Get.to(page);
          }
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(item);
  }
}



