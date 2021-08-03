import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/getLoadPosterDetailsFromApi.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/loadPosterModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:liveasy/screens/loadDetailsScreen.dart';
import 'package:liveasy/screens/ordersScreen.dart';
import 'package:liveasy/screens/postLoadScreens/postLoadScreen.dart';
import 'package:liveasy/widgets/accountVerification/accountPageUtil.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/bottomNavigationIconWidget.dart';
import 'package:provider/provider.dart';
import 'TruckScreens/myTrucksScreen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  List<LoadDetailsScreenModel> data = [];
  String? loadID;
  LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();

  TransporterIdController tIdController = Get.find<TransporterIdController>();

  var screens = [
    HomeScreen(),
    MyTrucks(),
    PostLoadScreen(),
    OrdersScreen(),
    AccountPageUtil(),
  ];

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            if (tIdController.transporterApproved.value) {
              loadID = deepLink.path;
              String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
              var jsonData;
              Uri url = Uri.parse("$loadApiUrl$loadID");
              http.Response response = await http.get(url);
              jsonData = await jsonDecode(response.body);
              LoadPosterModel loadPosterModel = LoadPosterModel();

              // LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
              loadDetailsScreenModel.loadId =
              jsonData["loadId"] != null ? jsonData['loadId'] : 'NA';
              loadDetailsScreenModel.loadingPoint =
              jsonData["loadingPoint"] != null ? jsonData['loadingPoint'] : 'NA';
              loadDetailsScreenModel.loadingPointCity =
              jsonData["loadingPointCity"] != null ? jsonData['loadingPointCity'] : 'NA';
              loadDetailsScreenModel.loadingPointState =
              jsonData["loadingPointState"] != null ? jsonData['loadingPointState'] : 'NA';
              loadDetailsScreenModel.postLoadId =
              jsonData["postLoadId"] != null ? jsonData['postLoadId'] : 'NA';
              loadDetailsScreenModel.unloadingPoint =
              jsonData["unloadingPoint"] != null ? jsonData['unloadingPoint'] : 'NA';
              loadDetailsScreenModel.unloadingPointCity =
              jsonData["unloadingPointCity"] != null
                  ? jsonData['unloadingPointCity']
                  : 'NA';
              loadDetailsScreenModel.unloadingPointState =
              jsonData["unloadingPointState"] != null
                  ? jsonData['unloadingPointState']
                  : 'NA';
              loadDetailsScreenModel.productType =
              jsonData["productType"] != null ? jsonData['productType'] : 'NA';
              loadDetailsScreenModel.truckType =
              jsonData["truckType"] != null ? jsonData['truckType'] : 'NA';
              loadDetailsScreenModel.noOfTrucks =
              jsonData["noOfTrucks"] != null ? jsonData['noOfTrucks'] : 'NA';
              loadDetailsScreenModel.weight =
              jsonData["weight"] != null ? jsonData['weight'] : 'NA';
              loadDetailsScreenModel.comment =
              jsonData["comment"] != null ? jsonData['comment'] : 'NA';
              loadDetailsScreenModel.status =
              jsonData["status"] != null ? jsonData['status'] : 'NA';
              loadDetailsScreenModel.loadDate =
              jsonData["loadDate"] != null ? jsonData['loadDate'] : 'NA';
              loadDetailsScreenModel.rate =
              jsonData["rate"] != null ? jsonData['rate'].toString() : 'NA';
              loadDetailsScreenModel.unitValue =
              jsonData["unitValue"] != null ? jsonData['unitValue'] : 'NA';

              print("Load Details Screen Model Inserted Data is ${loadDetailsScreenModel.weight}");

              if (jsonData["postLoadId"].contains('transporter') ||
                  jsonData["postLoadId"].contains('shipper')) {
                loadPosterModel = await getLoadPosterDetailsFromApi(
                    loadPosterId: jsonData["postLoadId"].toString());

              } else {
                print("Mereko nhi pata kya horela hai check karna padega");
              }

              if (loadPosterModel != null) {
                loadDetailsScreenModel.loadPosterId = loadPosterModel.loadPosterId;
                loadDetailsScreenModel.phoneNo = loadPosterModel.loadPosterPhoneNo;
                loadDetailsScreenModel.loadPosterLocation =
                    loadPosterModel.loadPosterLocation;
                loadDetailsScreenModel.loadPosterName = loadPosterModel.loadPosterName;
                loadDetailsScreenModel.loadPosterCompanyName =
                    loadPosterModel.loadPosterCompanyName;
                loadDetailsScreenModel.loadPosterKyc = loadPosterModel.loadPosterKyc;
                loadDetailsScreenModel.loadPosterCompanyApproved =
                    loadPosterModel.loadPosterCompanyApproved;
                loadDetailsScreenModel.loadPosterApproved =
                    loadPosterModel.loadPosterApproved;
              } else {
                //this will run when postloadId value is something different than uuid , like random text entered from postman
                loadDetailsScreenModel.loadPosterId = 'NA';
                loadDetailsScreenModel.phoneNo = '';
                loadDetailsScreenModel.loadPosterLocation = 'NA';
                loadDetailsScreenModel.loadPosterName = 'NA';
                loadDetailsScreenModel.loadPosterCompanyName = 'NA';
                loadDetailsScreenModel.loadPosterKyc = 'NA';
                loadDetailsScreenModel.loadPosterCompanyApproved = true;
                loadDetailsScreenModel.loadPosterApproved = true;
              }

              setState(() {
                data.add(loadDetailsScreenModel);
              });
              Get.to(() => LoadDetailsScreen(loadDetailsScreenModel: loadDetailsScreenModel));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => VerifyAccountNotifyAlertDialog());
            }
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData? dataLink = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = dataLink?.link;

    if (deepLink != null) {
      loadID = deepLink.path;
      String loadApiUrl = FlutterConfig.get("loadApiUrl").toString();
      var jsonData;
      Uri url = Uri.parse("$loadApiUrl$loadID");
      http.Response response = await http.get(url);
      jsonData = await jsonDecode(response.body);
      LoadPosterModel loadPosterModel = LoadPosterModel();

      // LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
      loadDetailsScreenModel.loadId =
      jsonData["loadId"] != null ? jsonData['loadId'] : 'NA';
      loadDetailsScreenModel.loadingPoint =
      jsonData["loadingPoint"] != null ? jsonData['loadingPoint'] : 'NA';
      loadDetailsScreenModel.loadingPointCity =
      jsonData["loadingPointCity"] != null ? jsonData['loadingPointCity'] : 'NA';
      loadDetailsScreenModel.loadingPointState =
      jsonData["loadingPointState"] != null ? jsonData['loadingPointState'] : 'NA';
      loadDetailsScreenModel.postLoadId =
      jsonData["postLoadId"] != null ? jsonData['postLoadId'] : 'NA';
      loadDetailsScreenModel.unloadingPoint =
      jsonData["unloadingPoint"] != null ? jsonData['unloadingPoint'] : 'NA';
      loadDetailsScreenModel.unloadingPointCity =
      jsonData["unloadingPointCity"] != null
          ? jsonData['unloadingPointCity']
          : 'NA';
      loadDetailsScreenModel.unloadingPointState =
      jsonData["unloadingPointState"] != null
          ? jsonData['unloadingPointState']
          : 'NA';
      loadDetailsScreenModel.productType =
      jsonData["productType"] != null ? jsonData['productType'] : 'NA';
      loadDetailsScreenModel.truckType =
      jsonData["truckType"] != null ? jsonData['truckType'] : 'NA';
      loadDetailsScreenModel.noOfTrucks =
      jsonData["noOfTrucks"] != null ? jsonData['noOfTrucks'] : 'NA';
      loadDetailsScreenModel.weight =
      jsonData["weight"] != null ? jsonData['weight'] : 'NA';
      loadDetailsScreenModel.comment =
      jsonData["comment"] != null ? jsonData['comment'] : 'NA';
      loadDetailsScreenModel.status =
      jsonData["status"] != null ? jsonData['status'] : 'NA';
      loadDetailsScreenModel.loadDate =
      jsonData["loadDate"] != null ? jsonData['loadDate'] : 'NA';
      loadDetailsScreenModel.rate =
      jsonData["rate"] != null ? jsonData['rate'].toString() : 'NA';
      loadDetailsScreenModel.unitValue =
      jsonData["unitValue"] != null ? jsonData['unitValue'] : 'NA';

      if (jsonData["postLoadId"].contains('transporter') ||
          jsonData["postLoadId"].contains('shipper')) {
        loadPosterModel = await getLoadPosterDetailsFromApi(
            loadPosterId: jsonData["postLoadId"].toString());

      } else {
        print("Mereko nhi pata kya horela hai check karna padega");
      }

      if (loadPosterModel != null) {
        loadDetailsScreenModel.loadPosterId = loadPosterModel.loadPosterId;
        loadDetailsScreenModel.phoneNo = loadPosterModel.loadPosterPhoneNo;
        loadDetailsScreenModel.loadPosterLocation =
            loadPosterModel.loadPosterLocation;
        loadDetailsScreenModel.loadPosterName = loadPosterModel.loadPosterName;
        loadDetailsScreenModel.loadPosterCompanyName =
            loadPosterModel.loadPosterCompanyName;
        loadDetailsScreenModel.loadPosterKyc = loadPosterModel.loadPosterKyc;
        loadDetailsScreenModel.loadPosterCompanyApproved =
            loadPosterModel.loadPosterCompanyApproved;
        loadDetailsScreenModel.loadPosterApproved =
            loadPosterModel.loadPosterApproved;
      } else {
        //this will run when postloadId value is something different than uuid , like random text entered from postman
        loadDetailsScreenModel.loadPosterId = 'NA';
        loadDetailsScreenModel.phoneNo = '';
        loadDetailsScreenModel.loadPosterLocation = 'NA';
        loadDetailsScreenModel.loadPosterName = 'NA';
        loadDetailsScreenModel.loadPosterCompanyName = 'NA';
        loadDetailsScreenModel.loadPosterKyc = 'NA';
        loadDetailsScreenModel.loadPosterCompanyApproved = true;
        loadDetailsScreenModel.loadPosterApproved = true;
      }

      setState(() {
        data.add(loadDetailsScreenModel);
      });
      Get.to(() => LoadDetailsScreen(loadDetailsScreenModel: loadDetailsScreenModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData =
        Provider.of<ProviderData>(context, listen: false);
    return Scaffold(
      backgroundColor: statusBarColor,
      // color of status bar which displays time on a phone
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int pressedIndex) {
          // Provider.of<ProviderData>(context, listen: false)
          //     .updateIndex(pressedIndex);
          providerData.updateUpperNavigatorIndex(0);
          providerData.updateIndex(pressedIndex);
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
            label: ("My Loads"),
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
