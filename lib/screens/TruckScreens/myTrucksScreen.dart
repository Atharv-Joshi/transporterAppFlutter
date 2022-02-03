import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/mapUtils/getLoactionUsingImei.dart';
import 'package:liveasy/functions/truckApis/getTruckDataWithPageNo.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/mapAllTrucks.dart';
import 'package:liveasy/screens/myTrucksSearchResultsScreen.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liveasy/widgets/truckScreenBarButton.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TruckApiCalls truckApiCalls = TruckApiCalls();

  // Truck Model List used to  create cards
  var truckDataList = [];
  var truckAddressList = [];
  var status = [];
  var gpsDataList = [];
  var gpsStoppageHistory = [];
  MapUtil mapUtil = MapUtil();
  late List<Placemark> placemarks;
  late String date;

  var gpsData;
  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  var runningList = [];
  var runningAddressList = [];
  var runningStatus = [];
  var runningGpsData = [];
  int i = 0;
  var StoppedList = [];
  var StoppedAddressList = [];
  var StoppedStatus = [];
  var StoppedGpsData = [];
  var truckDataListForPage = [];

  var gpsList = [];
  var truckAddress = [];
  var stat = [];
  var running = [];
  var runningAddress = [];
  var runningStat = [];
  var runningGps = [];
  var Stopped = [];
  var StoppedAddress = [];
  var StoppedStat = [];
  var StoppedGps = [];

  var items = [];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    FutureGroup futureGroup = FutureGroup();

    super.initState();
    setState(() {
      loading = true;
    });
    var f1 = getTruckAddress();
    var f2 = getTruckData(i);

    futureGroup.add(f1);
    futureGroup.add(f2);

    futureGroup.close();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getTruckData(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ProviderData providerData = Provider.of<ProviderData>(context);
    // providerData.resetTruckFilters();
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*  SizedBox(
                      width: space_3,
                    ),*/
                    HeadingTextWidget('my_truck'.tr
                        // AppLocalizations.of(context)!.my_truck
                        ),
                    // HelpButtonWidget(),
                  ],
                ),
                HelpButtonWidget(),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: space_3),
              child: Container(
                height: space_8,
                decoration: BoxDecoration(
                  color: widgetBackGroundColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 0.8,
                    // color: borderBlueColor,
                  ),
                ),
                child: TextField(
                  onTap: () {
                    Get.to(() => MyTrucksResult(
                          gpsDataList: gpsDataList,
                          truckDataList: truckDataList,
                          truckAddressList: truckAddressList,
                          status: status,
                          items: items,
                        ));
                    print("Enterrr");
                    print("THE ITEMS $items");
                  },
                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'search'.tr,
                    icon: Padding(
                      padding: EdgeInsets.only(left: space_2),
                      child: Icon(
                        Icons.search,
                        color: grey,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: size_8,
                      color: grey,
                    ),
                  ),
                ),
              ),
            ),

            //LIST OF TRUCK CARDS---------------------------------------------
            Container(
              //    height: 26,
              //    width: 200,
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),

              //    margin: EdgeInsets.symmetric(horizontal: space_2),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEFEFEF),
                    blurRadius: 9,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TruckScreenBarButton(
                      text: 'all'.tr,
                      // 'All',
                      value: 0,
                      pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                      text: 'running'.tr,
                      // 'Running'
                      value: 1,
                      pageController: pageController),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 1,
                    height: 15,
                    color: const Color(0xFFC2C2C2),
                  ),
                  TruckScreenBarButton(
                      text: 'stopped'.tr,
                      // 'Stopped',
                      value: 2,
                      pageController: pageController),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () {
                Get.to(MapAllTrucks(
                  gpsDataList: gpsDataList,
                  truckDataList: truckDataList,
                  runningDataList: runningList,
                  runningGpsDataList: runningGpsData,
                  stoppedList: StoppedList,
                  stoppedGpsList: StoppedGpsData,
                ));
              },
              child: Container(

                  //     margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                  padding:
                      EdgeInsets.fromLTRB(space_5, space_2, space_2, space_2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEFEFEF),
                        blurRadius: 9,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/Vector (1).png',
                        width: 17,
                        height: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Text(
                        'seeAllTruckMap'.tr,
                        // 'See All Trucks on Map',
                        style: TextStyle(fontSize: 15),
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/icons/Vector (2).png',
                        width: 7,
                        height: 15,
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Stack(children: [
                Container(
                  //    margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                  height: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight -
                      230 -
                      space_4,
                  child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          providerData.updateUpperNavigatorIndex(value);
                        });
                      },
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : truckDataList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            Text(
                                              'notruckadded'.tr,
                                              // 'Looks like you have not added any Trucks!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningAddressList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            truckAddressList.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedAddressList.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            controller: scrollController,
                                            scrollDirection: Axis.vertical,
                                            padding: EdgeInsets.only(
                                                bottom: space_15),
                                            itemCount: truckDataList.length,
                                            itemBuilder: (context, index) =>
                                                index == truckDataList.length
                                                    ? bottomProgressBarIndicatorWidget()
                                                    : MyTruckCard(
                                                        truckData:
                                                            truckDataList[
                                                                index],
                                                        truckAddress:
                                                            truckAddressList[
                                                                index],
                                                        status: status[index],
                                                        gpsData:
                                                            gpsDataList[index],
                                                        // truckId: .truckId,
                                                        // truckApproved:
                                                        //     truckDataList[index].truckApproved,
                                                        // truckNo: truckDataList[index].truckNo,
                                                        // truckType: truckDataList[index].truckType,
                                                        // tyres: truckDataList[index].tyresString,
                                                        // driverName: truckDataList[index].driverName,
                                                        // phoneNum: truckDataList[index].driverNum,
                                                        // imei: truckDataList[index].imei,
                                                      )),
                                      ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : runningList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'notruckrunning'.tr,
                                              // 'Looks like none of your trucks are running!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningAddressList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            truckAddressList.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedAddressList.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(
                                                bottom: space_15),
                                            physics: BouncingScrollPhysics(),
                                            controller: scrollController,
                                            scrollDirection: Axis.vertical,
                                            itemCount: truckDataList.length,
                                            itemBuilder: (context, index) =>
                                                index == truckDataList.length
                                                    ? bottomProgressBarIndicatorWidget()
                                                    : MyTruckCard(
                                                        truckData:
                                                            truckDataList[
                                                                index],
                                                        truckAddress:
                                                            truckAddressList[
                                                                index],
                                                        status: status[index],
                                                        gpsData:
                                                            gpsDataList[index],
                                                        // truckId: .truckId,
                                                        // truckApproved:
                                                        //     truckDataList[index].truckApproved,
                                                        // truckNo: truckDataList[index].truckNo,
                                                        // truckType: truckDataList[index].truckType,
                                                        // tyres: truckDataList[index].tyresString,
                                                        // driverName: truckDataList[index].driverName,
                                                        // phoneNum: truckDataList[index].driverNum,
                                                        // imei: truckDataList[index].imei,
                                                      )),
                                      ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : runningList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'notruckrunnning'.tr,
                                              // 'Looks like none of your trucks are running!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningAddressList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            truckAddressList.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedAddressList.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                          padding:
                                              EdgeInsets.only(bottom: space_15),
                                          physics: BouncingScrollPhysics(),
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount: runningList.length,
                                          itemBuilder: (context, index) => index ==
                                                  runningList.length
                                              ? bottomProgressBarIndicatorWidget()
                                              : MyTruckCard(
                                                  truckData: runningList[index],
                                                  truckAddress:
                                                      runningAddressList[index],
                                                  status: runningStatus[index],
                                                  gpsData:
                                                      runningGpsData[index],
                                                  // truckId: .truckId,
                                                  // truckApproved:
                                                  //     truckDataList[index].truckApproved,
                                                  // truckNo: truckDataList[index].truckNo,
                                                  // truckType: truckDataList[index].truckType,
                                                  // tyres: truckDataList[index].tyresString,
                                                  // driverName: truckDataList[index].driverName,
                                                  // phoneNum: truckDataList[index].driverNum,
                                                  // imei: truckDataList[index].imei,
                                                ),
                                        ),
                                      )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            loading
                                ? TruckLoadingWidgets()
                                : StoppedList.isEmpty
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.27,
                                        margin: EdgeInsets.only(top: 153),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/TruckListEmptyImage.png'),
                                              height: 127,
                                              width: 127,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'notruckstopped'.tr,
                                              // 'Looks like none of your trucks are stopped!',
                                              style: TextStyle(
                                                  fontSize: size_8,
                                                  color: grey),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        color: lightNavyBlue,
                                        onRefresh: () {
                                          setState(() {
                                            runningList.clear();
                                            runningAddressList.clear();
                                            runningGpsData.clear();
                                            runningStatus.clear();
                                            truckAddressList.clear();
                                            gpsDataList.clear();
                                            status.clear();
                                            StoppedStatus.clear();
                                            StoppedAddressList.clear();
                                            StoppedGpsData.clear();
                                            StoppedList.clear();
                                            loading = true;
                                          });
                                          return refreshData(i);
                                        },
                                        child: ListView.builder(
                                          padding:
                                              EdgeInsets.only(bottom: space_15),
                                          physics: BouncingScrollPhysics(),
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount: StoppedList.length,
                                          itemBuilder: (context, index) => index ==
                                                  StoppedList.length
                                              ? bottomProgressBarIndicatorWidget()
                                              : MyTruckCard(
                                                  truckData: StoppedList[index],
                                                  truckAddress:
                                                      StoppedAddressList[index],
                                                  status: StoppedStatus[index],
                                                  gpsData:
                                                      StoppedGpsData[index],
                                                  // truckId: .truckId,
                                                  // truckApproved:
                                                  //     truckDataList[index].truckApproved,
                                                  // truckNo: truckDataList[index].truckNo,
                                                  // truckType: truckDataList[index].truckType,
                                                  // tyres: truckDataList[index].tyresString,
                                                  // driverName: truckDataList[index].driverName,
                                                  // phoneNum: truckDataList[index].driverNum,
                                                  // imei: truckDataList[index].imei,
                                                ),
                                        ),
                                      ),
                          ],
                        ),
                      ]),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height -
                      kBottomNavigationBarHeight -
                      230 -
                      2 * space_6 -
                      30,
                  left: (MediaQuery.of(context).size.width - 2 * space_6) / 2 -
                      60,
                  child: Container(
                      //     margin: EdgeInsets.only(bottom: space_2),
                      child: AddTruckButton()),
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  } //build

  getTruckData(int i) async {
    var truckDataListForPagei = await getTruckDataWithPageNo(i);
    for (var truckData in truckDataListForPagei) {
      setState(() {
        truckDataList.add(truckData);
      });
    }
  }

  getTruckAddress() async {
    FutureGroup futureGroup = FutureGroup();

    var truckDataListForPagevar = await truckApiCalls.getTruckData();

    print("Truck length ${truckDataListForPagevar.length}");

    setState(() {
      items = truckDataListForPagevar;
    });

    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(truckDataListForPagevar.length, null, growable: true);
    truckAddress =
        List.filled(truckDataListForPagevar.length, "", growable: true);
    stat = List.filled(truckDataListForPagevar.length, "", growable: true);
    running = List.filled(truckDataListForPagevar.length, null, growable: true);
    runningAddress =
        List.filled(truckDataListForPagevar.length, "", growable: true);
    runningStat =
        List.filled(truckDataListForPagevar.length, "", growable: true);
    runningGps =
        List.filled(truckDataListForPagevar.length, null, growable: true);
    Stopped = List.filled(truckDataListForPagevar.length, null, growable: true);
    StoppedAddress =
        List.filled(truckDataListForPagevar.length, "", growable: true);
    StoppedStat =
        List.filled(truckDataListForPagevar.length, "", growable: true);
    StoppedGps =
        List.filled(truckDataListForPagevar.length, null, growable: true);
    //------------------------------------------------

    //START ADDING DATA-------------------------------
    for (int i = 0; i < truckDataListForPagevar.length; i++) {
      print("DeviceId is ${truckDataListForPagevar[i].deviceId}");

      if (truckDataListForPagevar[i].deviceId != 0 &&
          truckDataListForPagevar[i].truckApproved == true) {
        var future = getGPSData(truckDataListForPagevar[i], i);
        futureGroup.add(future);
      }
    }
    futureGroup.close();
    await futureGroup.future; //Fire all APIs at once (not one after the other)

    setState(() {
      gpsDataList = gpsList;
      truckAddressList = truckAddress;
      status = stat;

      runningList = running;
      runningAddressList = runningAddress;
      runningGpsData = runningGps;
      runningStatus = runningStat;

      StoppedList = Stopped;
      StoppedAddressList = StoppedAddress;
      StoppedGpsData = StoppedGps;
      StoppedStatus = StoppedStat;
    });

    //NOW REMOVE EXTRA ELEMENTS FROM RUNNING AND STOPPED LISTS-------

    runningList.removeWhere((item) => item == null);
    runningGpsData.removeWhere((item) => item == null);
    runningAddressList.removeWhere((item) => item == "");
    runningStatus.removeWhere((item) => item == "");

    StoppedList.removeWhere((item) => item == null);
    StoppedGpsData.removeWhere((item) => item == null);
    StoppedAddressList.removeWhere((item) => item == "");
    StoppedAddressList.removeWhere((item) => item == "");

    print("ALL $status");
    print("ALL $truckAddressList");
    print("ALL $gpsDataList");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }

  getGPSData(var truckData, int i) async {
    gpsData = await mapUtil.getTraccarPosition(deviceId: truckData.deviceId);
    getStoppedSince(gpsData, i);
    print("GETTING DATA");
    if (truckData.truckApproved == true &&
        gpsData.last.speed >= 2) //For RUNNING Section
    {
      running.removeAt(i);
      runningAddress.removeAt(i);
      runningGps.removeAt(i);

      running.insert(i, truckData);
      runningAddress.insert(i, "${gpsData.last.address}");
      runningGps.insert(i, gpsData);
    } else if (truckData.truckApproved == true && gpsData.last.speed < 2) {
      //For STOPPED section

      Stopped.removeAt(i);
      StoppedAddress.removeAt(i);
      StoppedGps.removeAt(i);

      Stopped.insert(i, truckData);
      StoppedAddress.insert(i, "${gpsData.last.address}");
      StoppedGps.insert(i, gpsData);
    }
    gpsList.removeAt(i);
    truckAddress.removeAt(i);

    gpsList.insert(i, gpsData);
    truckAddress.insert(i, "${gpsData.last.address}");
    print("DONE ONE PART");
  }

  refreshData(int i) async {
    FutureGroup futureGroup = FutureGroup();
    print("Trcuk dat $truckDataList");
    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(truckDataList.length, null, growable: true);
    truckAddress = List.filled(truckDataList.length, "", growable: true);
    stat = List.filled(truckDataList.length, "", growable: true);
    running = List.filled(truckDataList.length, null, growable: true);
    runningAddress = List.filled(truckDataList.length, "", growable: true);
    runningStat = List.filled(truckDataList.length, "", growable: true);
    runningGps = List.filled(truckDataList.length, null, growable: true);
    Stopped = List.filled(truckDataList.length, null, growable: true);
    StoppedAddress = List.filled(truckDataList.length, "", growable: true);
    StoppedStat = List.filled(truckDataList.length, "", growable: true);
    StoppedGps = List.filled(truckDataList.length, null, growable: true);
    //------------------------------------------------
    for (int i = 0; i < truckDataList.length; i++) {
      print("DeviceId is ${truckDataList[i].deviceId}");

      if (truckDataList[i].deviceId != 0 &&
          truckDataList[i].truckApproved == true) {
        var future = getGPSData(truckDataList[i], i);
        futureGroup.add(future);
      }
    }
    futureGroup.close();
    await futureGroup.future; //Fire all APIs at once (not one after the other)

    setState(() {
      gpsDataList = gpsList;
      truckAddressList = truckAddress;
      status = stat;
      runningList = running;
      runningAddressList = runningAddress;
      runningGpsData = runningGps;
      runningStatus = runningStat;

      StoppedList = Stopped;
      StoppedAddressList = StoppedAddress;
      StoppedGpsData = StoppedGps;
      StoppedStatus = StoppedStat;
    });

    //NOW REMOVE EXTRA ELEMENTS FROM RUNNING AND STOPPED LISTS-------

    runningList.removeWhere((item) => item == null);
    runningGpsData.removeWhere((item) => item == null);
    runningAddressList.removeWhere((item) => item == "");
    runningStatus.removeWhere((item) => item == "");

    StoppedList.removeWhere((item) => item == null);
    StoppedGpsData.removeWhere((item) => item == null);
    StoppedAddressList.removeWhere((item) => item == "");
    StoppedAddressList.removeWhere((item) => item == "");

    print("ALL $status");
    print("ALL $truckAddressList");
    print("ALL $gpsDataList");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }

  getStoppedSince(var gpsData, int i) async {
    if (gpsData.last.motion == false) {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Stopped");

      stat.removeAt(i);
      stat.insert(i, "Stopped");
    } else {
      runningStat.removeAt(i);
      runningStat.insert(i, "Running");

      stat.removeAt(i);
      stat.insert(i, "Running");
    }
  }
}

//class
