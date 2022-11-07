import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/documentApi/getDocument.dart';
import 'package:liveasy/providerClass/drawerProviderClassData.dart';
import 'package:liveasy/screens/findLoadScreen.dart';
import 'package:liveasy/widgets/accountNotVerifiedWidget.dart';
import 'package:liveasy/widgets/bonusWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/buyGpsWidget.dart';
import 'package:liveasy/widgets/drawerWidget.dart';
import 'package:liveasy/widgets/liveasyTitleTextWidget.dart';
import 'package:liveasy/widgets/referAndEarnWidget.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:liveasy/widgets/suggestedLoadWidgetHeader.dart';
import 'package:liveasy/widgets/suggestedLoadsWidget.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/functions/documentApi/getDocument.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  var imageLinks ;
  bool isSwitched = false;

  final switchData = GetStorage();

  @override
  void initState() {
    // switchData.write("isSwitched", true);
    super.initState();
    imageUrl();
    // try {
    //   if(switchData.read('isSwitched') != null) {
    //     if(switchData.read('isSwitched') == true) {
    //       backgroundTry();
    //     }
    //   }
    // }catch (e) {
    //   print("Expetion is $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerWidget(
            mobileNum: transporterIdController.mobileNum.value,
            userName: transporterIdController.name.toString(),
            imageUrl: imageLinks.toString(),
            // imageUrl: response['documentLink'],
            // and pass image url here, if required.
          ),
          backgroundColor: backgroundColor,
          body: Container(
            height: MediaQuery.of(context).size.height -
                kBottomNavigationBarHeight -
                space_4 -
                space_2, //space_4 and space_2 comes from padding given below
            padding: EdgeInsets.fromLTRB(0, space_4, 0, space_2),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: space_4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              imageUrl();
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            icon: Icon(
                              Icons.list,
                              size: space_6,
                            ),
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          LiveasyTitleTextWidget(),
                        ],
                      ),
                      HelpButtonWidget()
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(space_4, space_4, space_4, space_5),
                  child: SearchLoadWidget(
                    hintText: 'search'.tr,
                    // AppLocalizations.of(context)!.search,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Get.to(() => FindLoadScreen());
                    },
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(initialScrollOffset: 110),
                    children: [
                      ReferAndEarnWidget(),
                      SizedBox(
                        width: space_4,
                      ),
                      BuyGpsWidget(),
                      SizedBox(
                        width: space_4,
                      ),
                      BonusWidget(),
                    ],
                  ),
                ),
                SizedBox(
                  height: space_1,
                ),
                transporterIdController.transporterApproved.value == false
                    ? AccountNotVerifiedWidget()
                    : SizedBox(
                        height: space_2,
                      ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: space_4),
                  child: SuggestedLoadWidgetHeader(),
                ),
                SizedBox(
                  height: space_2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: space_4),
                    child: SuggestedLoadsWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void>imageUrl() async {
    imageLinks = await getDocumentWithTransportId(transporterIdController.transporterId.toString());
    setState(() {});
  }

// Future<bool> onWillPop() {
//   setState(() {
//     isSwitched = switchData.read('isSwitched');
//     print("State OnWillPop is $isSwitched");
//   });
//   if (isSwitched == true) {
//     print("You can't go back");
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => WillPopScope(
//           onWillPop: () => Future.value(false),
//           child: ConflictDialog(
//               dialog: "You can't Close App\nPlease Press Home Button"
//           ),
//         ));
//     return Future.value(false);
//   }
//   print("You can exit back");
//   return Future.value(true);
// }
}
