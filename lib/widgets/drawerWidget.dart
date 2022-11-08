import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/providerClass/drawerProviderClassData.dart';
import 'package:liveasy/screens/buyGpsScreen.dart';
import 'package:liveasy/screens/languageSelectionScreen.dart';
import 'package:liveasy/widgets/alertDialog/LogOutDialogue.dart';
import 'package:liveasy/screens/myDriversScreen.dart';
import 'package:liveasy/widgets/alertDialog/addDriverAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../screens/fullScreenImage.dart';

class DrawerWidget extends StatelessWidget {
  final String mobileNum;
  final String userName;
  final String imageUrl;
  GetStorage tidstorage = GetStorage('TransporterIDStorage');

  DrawerWidget(
      {required this.mobileNum, required this.userName, required this.imageUrl});

  final padding = EdgeInsets.only(left: space_1, right: space_7);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String name;
    String image;
    image =
    (imageUrl == "no profile" ? "assets/icons/defaultAccountIcon.png" : imageUrl);
    name = userName.length > 17 ? userName.substring(0, 15) + "..." : userName;
    NavigationIndexController navigationIndexController =
        Get.find<NavigationIndexController>();
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_6),
          bottomRight: Radius.circular(radius_6)),
      child: Container(
        width: width / 1.4,
        child: Drawer(
          child: Material(
              color: fadeGrey,
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(
                      height: space_9,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: space_4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: radius_7,
                            backgroundColor: white,
                            child:
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                        return FullScreenImage(
                                          imageUrl: imageUrl,
                                        );
                                      }));
                                },
                                child:
                                imageUrl == "no profile" ?
                                Container(
                                  height: space_7,
                                  width: space_7,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(image),
                                    ),
                                  ),
                                ):Image.network(image)),
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          name != ""
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      alignment: Alignment.topLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: mediumBoldWeight,
                                          fontSize: size_7,
                                          fontFamily: 'montserrat',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: space_2),
                                    Text(mobileNum),
                                  ],
                                )
                              : Text(mobileNum),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: space_8,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectItem(context, NavigationItem.MyAccount);
                        navigationIndexController.updateIndex(4);
                      },
                      child: drawerMenuItem(
                          context: context,
                          item: NavigationItem.MyAccount,
                          text: 'my_account'.tr,
                          // AppLocalizations.of(context)!.my_account,
                          image: 'assets/icons/person.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectItem(context, NavigationItem.Language);
                        Navigator.of(context).pop();
                        Get.to(LanguageSelectionScreen());
                      },
                      child: drawerMenuItem(
                          context: context,
                          item: NavigationItem.Language,
                          text: 'language'.tr,
                          // AppLocalizations.of(context)!.language,
                          image: 'assets/icons/languageIcon.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectItem(context, NavigationItem.AddDriver);
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => MyDrivers());
                      },
                      child: drawerMenuItem(
                          context: context,
                          item: NavigationItem.AddDriver,
                          text: 'mydriver'.tr,
                          // 'My Drivers',
                          image: 'assets/icons/driverHandle.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectItem(context, NavigationItem.BuyGps);
                        Navigator.of(context).pop();
                        Get.to(BuyGpsScreen());
                      },
                      child: drawerMenuItem(
                          context: context,
                          item: NavigationItem.BuyGps,
                          text: 'buy_gps'.tr,
                          // AppLocalizations.of(context)!.buy_gps,
                          image: 'assets/icons/gps.png'),
                    ),
                    SizedBox(
                      height: space_2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: space_4),
                      child: Divider(
                        color: black,
                      ),
                    ),
                    SizedBox(
                      height: space_3,
                    ),
                    // ListTile(
                    //   title: Container(
                    //     margin: EdgeInsets.only(left: space_4),
                    //     child: Text(AppLocalizations.of(context)!.about_us,
                    //         style: TextStyle(
                    //             color: darkBlueColor,
                    //             fontSize: size_8,
                    //             fontFamily: 'montserrat',
                    //             fontWeight: regularWeight)),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        String url = 'tel:+918905246537';
                        UrlLauncher.launch(url);
                      },
                      child: drawerMenuItem(
                          context: context,
                          item: NavigationItem.ContactUs,
                          text: 'contact_us'.tr,
                          // AppLocalizations.of(context)!.buy_gps,
                          image: 'assets/icons/callButtonIcon.png'),
                    ),
                    // ListTile(
                    //   title: Container(
                    //     alignment: Alignment.topLeft,
                    //     padding: EdgeInsets.only(right: 0),
                    //     margin: EdgeInsets.only(left: space_3),
                    //     child: TextButton(
                    //         // AppLocalizations.of(context)!.contact_us,
                    //         onPressed: () {
                    //           String url = 'tel:8290748131';
                    //           UrlLauncher.launch(url);
                    //         },
                    //       style: ButtonStyle(
                    //         fixedSize: MaterialStateProperty.resolveWith((states) { Size.fromWidth(300);Size.fromHeight(600);}),
                    //         maximumSize: MaterialStateProperty.resolveWith((states) { Size.fromWidth(300);Size.fromHeight(600);}),
                    //         overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                    //         ),
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(right: 120.0),
                    //           child: Text('contact_us'.tr, style: TextStyle(
                    //               color: darkBlueColor,
                    //               fontSize: size_8,
                    //               fontFamily: 'montserrat',
                    //               fontWeight: regularWeight),textAlign: TextAlign.left,),
                    //         ),),
                    //   ),
                    // ),
                    SizedBox(
                      height: space_3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: space_4),
                      child: Divider(
                        color: black,
                      ),
                    ),
                    SizedBox(
                      height: space_5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => LogoutDialogue()

                            // builder: (_) => WillPopScope(
                            //       onWillPop: () async => false,
                            //       // <-- Prevents dialog dismiss on press of back button.
                            //       child: LogoutDialogue(),
                            //     )
                            );
                      },
                      child: ListTile(
                        title: Text('logout'.tr,
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: black,
                                fontSize: size_8,
                                fontFamily: 'montserrat',
                                fontWeight: regularWeight)),
                        leading: Container(
                            margin: EdgeInsets.only(left: space_4),
                            child: Icon(
                              Icons.logout,
                              color: darkBlueColor,
                            )),
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

  Widget drawerMenuItem({
    required BuildContext context,
    required NavigationItem item,
    required String text,
    required String image,
  }) {
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_2),
          bottomRight: Radius.circular(radius_2)),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: lightGrey,
        leading: Container(
          margin: EdgeInsets.only(left: space_4),
          child: Image(
            image: AssetImage(image),
            width: space_3,
            height: space_4,
          ),
        ),
        title: Text(text,
            style: TextStyle(
                color: isSelected ? darkBlueColor : black,
                fontSize: size_8,
                fontFamily: 'montserrat',
                fontWeight: isSelected ? boldWeight : regularWeight)),
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(item);
  }
}
