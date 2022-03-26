import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/AppVersionCheck.dart';
import 'package:liveasy/functions/getDriverDetailsFromDriverId.dart';
import 'package:liveasy/functions/loadApis/findLoadByLoadID.dart';
import 'package:liveasy/functions/trackScreenFunctions.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/screens/ordersScreen.dart';
import 'package:liveasy/screens/postLoadScreens/postLoadScreen.dart';
import 'package:liveasy/screens/trackScreen.dart';
import 'package:liveasy/widgets/accountVerification/accountPageUtil.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/home.dart';
import 'package:liveasy/widgets/alertDialog/linkExpiredDialog.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/bottomNavigationIconWidget.dart';
import 'package:provider/provider.dart';
import 'TruckScreens/myTrucksScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationScreen extends StatefulWidget {
  var initScreen;

  NavigationScreen({this.initScreen});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<LoadDetailsScreenModel> data = [];
  String? loadID;
  LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
  TruckApiCalls _truckApiCalls = TruckApiCalls();
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsData;
  var gpsRoute;
  var totalDistance;
  var truckData;
  var currentDate = DateTime.now();
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  TransporterIdController tIdController = Get.find<TransporterIdController>();
  NavigationIndexController navigationIndex =
      Get.put(NavigationIndexController(), permanent: true);
  var screens = [
    HomeScreen(),
    MyTrucks(),
    PostLoadScreen(),
    OrdersScreen(),
    AccountPageUtil(),
  ];

  @override
  void initState() {
    if (widget.initScreen != null) {
      navigationIndex.updateIndex(widget.initScreen);
    }
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    super.initState();
    this.initDynamicLinks();
    this.checkUpdate();
  }

  void checkUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = (prefs.getBool('isFirstTime') ?? true);
    try {
      if (isFirstTime == true) {
        await prefs.setBool('isFirstTime', false);
        versionCheck(context);
      }
    } catch (e) {
      print(e);
    }
  }

  initfunction() async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: truckData.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
  }

  void _handleDynamicLink(PendingDynamicLinkData? dataLink) async {
    final Uri? deepLink = dataLink?.link;

    if (deepLink != null) {
      if (deepLink.queryParameters.containsKey('deviceId')) {
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.ring
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..maskColor = darkBlueColor
          ..userInteractions = false
          ..backgroundColor = darkBlueColor
          ..dismissOnTap = false;
        EasyLoading.show(
          status: "Loading...",
        );
        int deviceId = int.parse(deepLink.queryParameters['deviceId']!);
        print("DeviceID rec ${deviceId}");

        String? truckno = deepLink.queryParameters['truckno'];
        print("truckno rec ${truckno}");

        var expiryDuration =
            DateTime.parse(deepLink.queryParameters['duration']!);
        var durationDiff = expiryDuration.difference(currentDate).inMinutes;
        print("Duration Differrence is ${durationDiff}");

        var f1 = mapUtil.getTraccarPosition(deviceId: deviceId);

        initfunction();
        gpsData = await f1;

        GpsDataModel gpsDatamodel = gpsData[0];
        if (gpsDatamodel != null && durationDiff > 0) {
          EasyLoading.dismiss();
          Get.to(
            TrackScreen(
              deviceId: deviceId,
              gpsData: gpsDatamodel,
              // position: position,
              TruckNo: truckno,
              //  driverName: driverModel.driverName,
              //   driverNum: driverModel.phoneNum,
              //   gpsDataHistory: gpsDataHistory,
              //   gpsStoppageHistory: gpsStoppageHistory,
              //  routeHistory: gpsRoute,
              //  truckId: truckData['truckId'],
              totalDistance: totalDistance,
            ),
          );
        } else {
          EasyLoading.dismiss();
          print("THE CONDITIONS NOT VERIFIED");
          showDialog(
              context: context, builder: (context) => LinkExpiredDialog());
        }
      } else {
        loadID = deepLink.path;
        findLoadByLoadID(loadID!);
      }
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      _handleDynamicLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? dataLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDynamicLink(dataLink);
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
        backgroundColor: statusBarColor,
        // color of status bar which displays time on a phone
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              onTap: (int pressedIndex) {
                providerData.updateUpperNavigatorIndex(0);
                navigationIndex.updateIndex(pressedIndex);
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
                  label: ('home'.tr
                      // AppLocalizations.of(context)!.home
                      ),
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIconWidget(
                    iconPath: "myTrucksIcon.png",
                  ),
                  activeIcon: BottomNavigationIconWidget(
                    iconPath: "activeMyTrucksIcon.png",
                  ),
                  label: ('my_truck'.tr
                      // AppLocalizations.of(context)!.my_truck
                      ),
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIconWidget(
                    iconPath: "postLoadIcon.png",
                  ),
                  activeIcon: BottomNavigationIconWidget(
                    iconPath: "activePostLoadIcon.png",
                  ),
                  label: ('my_loads'.tr
                      // AppLocalizations.of(context)!.my_loads
                      ),
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIconWidget(
                    iconPath: "ordersIcon.png",
                  ),
                  activeIcon: BottomNavigationIconWidget(
                    iconPath: "activeOrdersIcon.png",
                  ),
                  label: ('order'.tr
                      // AppLocalizations.of(context)!.order
                      ),
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIconWidget(
                    iconPath: "accountIcon.png",
                  ),
                  activeIcon: BottomNavigationIconWidget(
                    iconPath: "activeAccountIcon.png",
                  ),
                  label: ('account'.tr
                      // AppLocalizations.of(context)!.account
                      ),
                ),
              ],
              currentIndex: navigationIndex.index.value,
            )),
        body: Obx(
          () => SafeArea(
            child:
                Center(child: screens.elementAt(navigationIndex.index.value)),
          ),
        ));
  }
}
//http://traccar.dev.truckseasy.com:8082/reports/route?from=2022-02-02T19:37:31Z&deviceId=1&to=2022-02-03T19:37:31Z
